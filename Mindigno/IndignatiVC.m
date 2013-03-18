//
//  IndignatiVC.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "IndignatiVC.h"
#import "UIImageView+WebCache.h"
#import "ProfileVC.h"
#import "Mindigno.h"

#define CELL_ROW_HEIGHT_DEFAULT 60.0f

@interface IndignatiVC ()

@end

@implementation IndignatiVC

@synthesize currentMicroPost;

- (id) initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder: aDecoder];
    if (self) {
        
        titleToIndignati = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [tableViewIndignati setDataSource:self];
    [tableViewIndignati setDelegate:self];
    
    int numberOfFollowingIndignati = [[currentMicroPost followingIndignati] count];
    if (numberOfFollowingIndignati > 0) {
        [titleToIndignati setObject:[currentMicroPost followingIndignati] forKey:@"Chi segui"];
    }
    
    [[Mindigno sharedMindigno] downloadAllIndignatiForMicropost: currentMicroPost];
    [titleToIndignati setObject: [currentMicroPost allIndignati] forKey: @"Tutti"];
    
    [tableViewIndignati reloadData];
}

///Start UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[titleToIndignati allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [[titleToIndignati allKeys] objectAtIndex: section];
    return [[titleToIndignati objectForKey:key] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *key = [[titleToIndignati allKeys] objectAtIndex: section];
    return key;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Row_Profile";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    NSString *key = [[titleToIndignati allKeys] objectAtIndex: indexPath.section];
    NSArray *arrayUsers = [titleToIndignati objectForKey: key];
    User *user = [arrayUsers objectAtIndex:indexPath.row];
    
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
    
    if (![[Mindigno sharedMindigno] isLoggedUser]) {
        UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
        [self presentViewController:navController animated:YES completion:nil];
        
    } else {
        
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewIndignati indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        NSString *key = [[titleToIndignati allKeys] objectAtIndex: currentIndexPath.section];
        NSArray *arrayUsers = [titleToIndignati objectForKey: key];
        User *currentUser = [arrayUsers objectAtIndex:currentIndexPath.row];
        
        UIButton *buttonSegue = (UIButton*)sender;
        
        BOOL isSeguito = [buttonSegue isSelected];
        if (!isSeguito) {
            BOOL ok = [[Mindigno sharedMindigno] followUserWithID: [currentUser userID]];
            
            if (ok) {
                [currentUser setIsFollowedFromLoggedUser: !isSeguito];
            }
            
        } else {
            BOOL ok = [[Mindigno sharedMindigno] removeFollowedUserWithID: [currentUser userID]];
            
            if (ok) {
                [currentUser setIsFollowedFromLoggedUser: !isSeguito];
            }
        }
        
        [tableViewIndignati reloadData];
    }
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
    
    if ([[segue identifier] isEqualToString:@"indignatiToProfile"]) {
        
        NSIndexPath* currentIndexPath = [tableViewIndignati indexPathForSelectedRow];
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        ProfileVC *profileVC = (ProfileVC*)[segue destinationViewController];
        
        NSString *key = [[titleToIndignati allKeys] objectAtIndex: currentIndexPath.section];
        NSArray *arrayUsers = [titleToIndignati objectForKey: key];
        
        User *currentUser = [arrayUsers objectAtIndex:currentIndexPath.row];
        [profileVC setCurrentUser:currentUser];
        
        NSArray *micropostOfUser = [[Mindigno sharedMindigno] downloadMicroPostsOfUser: currentUser];
        [profileVC setArrayMicroPost: micropostOfUser];
    }
}

- (IBAction)goBack:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
