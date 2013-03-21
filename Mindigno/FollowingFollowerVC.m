//
//  FollowingFollowerVC.m
//  Mindigno
//
//  Created by Enrico on 18/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "FollowingFollowerVC.h"
#import "UIImageView+WebCache.h"
#import "Mindigno.h"
#import "ProfileVC.h"

#define CELL_ROW_HEIGHT_DEFAULT 60.0f

@interface FollowingFollowerVC ()

@end

@implementation FollowingFollowerVC

@synthesize isFollowing, stringHeader;

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder: aDecoder];
    if (self) {
        currentUser = [[Mindigno sharedMindigno] currentUser];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [labelHeader setText: stringHeader];
    
    [tableViewFollowingOrFollower setDataSource:self];
    [tableViewFollowingOrFollower setDelegate:self];
    
    if (isFollowing) {
        arrayFollowingOrFollower = [[Mindigno sharedMindigno] downloadFollowingUsers];
        [labelHeader setText: [currentUser followingText]];
        
    } else {
        arrayFollowingOrFollower = [[Mindigno sharedMindigno] downloadFollowersUsers];
        [labelHeader setText: [currentUser followersText]];
    }
    
    [tableViewFollowingOrFollower reloadData];
}

///Start UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrayFollowingOrFollower count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Row_User";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    User *user = [arrayFollowingOrFollower objectAtIndex:indexPath.row];
    
    ///
    
    UIImageView *imageViewThumb = (UIImageView*)[cell viewWithTag:1];
    //Default setting
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewThumb setImageWithURL:[NSURL URLWithString:[user avatarUrl]] placeholderImage:placeHolder];
    
    UILabel *labelName = (UILabel*)[cell viewWithTag:2];
    [labelName setText: [user name]];
    
    UIButton *buttonSegue = (UIButton*)[cell viewWithTag: 3];
    [buttonSegue setSelected: [user isFollowedFromLoggedUser]];
    [buttonSegue addTarget:self action:@selector(buttonSegueClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
///Stop UITableViewDataSource

- (void) buttonSegueClicked:(id)sender {
    //NSLog(@"buttonSegueClicked");
        
    //The indexPath must be taken from button and not from the tableView
    NSIndexPath *currentIndexPath = [tableViewFollowingOrFollower indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    User *clickedUser = [arrayFollowingOrFollower objectAtIndex:currentIndexPath.row];
    
    UIButton *buttonSegue = (UIButton*)sender;
    
    BOOL isSeguito = [buttonSegue isSelected];
    if (!isSeguito) {
        BOOL ok = [[Mindigno sharedMindigno] followUserWithID: [clickedUser userID]];
        
        if (ok) {
            [clickedUser setIsFollowedFromLoggedUser: YES];
            [currentUser addOneToNumberOfFollowing];
        }
        
    } else {
        BOOL ok = [[Mindigno sharedMindigno] removeFollowedUserWithID: [clickedUser userID]];
        
        if (ok) {
            [clickedUser setIsFollowedFromLoggedUser: NO];
            [currentUser removeOneToNumberOfFollowing];
        }
    }
    
    [tableViewFollowingOrFollower reloadData];
}

///Start UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath clicked section: %d, row: %d", indexPath.section, indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    double defaultHeight = CELL_ROW_HEIGHT_DEFAULT;
    
    return defaultHeight;
}
///Stop UITableViewDelegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"followingFollowerToProfile"]) {
        
        NSIndexPath* currentIndexPath = [tableViewFollowingOrFollower indexPathForSelectedRow];
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        ProfileVC *profileVC = (ProfileVC*)[segue destinationViewController];
        
        User *clickedUser = [arrayFollowingOrFollower objectAtIndex:currentIndexPath.row];
        [profileVC setCurrentUser:clickedUser];
        
        NSArray *micropostOfUser = [[Mindigno sharedMindigno] downloadMicroPostsOfUser: clickedUser];
        [profileVC setArrayMicroPost: micropostOfUser];
    }
}

- (IBAction)goBack:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}


@end
