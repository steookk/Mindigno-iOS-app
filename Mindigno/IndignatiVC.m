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
        
        arrayOfArray_indignati = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [tableViewIndignati setDataSource:self];
    [tableViewIndignati setDelegate:self];
    
    NSLog(@"numero indignati: %d", [[currentMicroPost followingIndignati] count]);
    [arrayOfArray_indignati addObject: [currentMicroPost followingIndignati]];
    
    [tableViewIndignati reloadData];
}

///Start UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [arrayOfArray_indignati count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (int)[[arrayOfArray_indignati objectAtIndex:section] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Row_Profile";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    User *userFollowing = [[arrayOfArray_indignati objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    ///
    
    UIImageView *imageViewThumb = (UIImageView*)[cell viewWithTag:1];
    //Default setting
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewThumb setImageWithURL:[NSURL URLWithString:[userFollowing avatarUrl]] placeholderImage:placeHolder];
    
    UILabel *labelName = (UILabel*)[cell viewWithTag:2];
    [labelName setText: [userFollowing name]];
    
    return cell;
}
///Stop UITableViewDataSource


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
        User *currentUser = [[arrayOfArray_indignati objectAtIndex:currentIndexPath.section] objectAtIndex:currentIndexPath.row];
        [profileVC setCurrentUser:currentUser];
        
        NSArray *micropostOfUser = [[Mindigno sharedMindigno] microPostsOfUser: currentUser];
        [profileVC setArrayMicroPost: micropostOfUser];
    }
}

- (IBAction)goBack:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
