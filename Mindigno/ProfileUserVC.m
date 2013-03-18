//
//  ProfileUserVC.m
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "ProfileUserVC.h"
#import "Mindigno.h"
#import "UIImageView+WebCache.h"
#import "MicroPost.h"
#import "ButtonWithBadge.h"
#import "IndignatiVC.h"
#import "CommentsVC.h"
#import "MicroPostDetailVC.h"
#import "JSONParserMainData.h"
#import "FollowingFollowerVC.h"

#define CELL_ROW_HEIGHT_DEFAULT 200.0f

@interface ProfileUserVC ()

@end

@implementation ProfileUserVC

@synthesize currentUser, arrayMicroPost, buttonSettings;

- (void) refreshView {
    
    if (currentUser == [[Mindigno sharedMindigno] currentUser]) {
        [buttonSegue setHidden: YES];
    } else {
        [buttonSegue setHidden: NO];
    }
    
    [buttonSegue setSelected: [currentUser isFollowedFromLoggedUser]];
    [buttonSegue addTarget:self action:@selector(buttonSegueClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //
	
    [labelName setText: [currentUser name]];
    
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewAvatar setImageWithURL:[NSURL URLWithString:[currentUser avatarUrl]] placeholderImage:placeHolder];
    
    //
    
    [buttonFollowersText setTitle:[currentUser followersText] forState:UIControlStateNormal];
    [buttonFollowingText setTitle:[currentUser followingText] forState:UIControlStateNormal];
    
    BOOL isCurrentUser = (currentUser == [[Mindigno sharedMindigno] currentUser]);
    
    NSString *numberOfFollowers = [currentUser numberOfFollowers];
    NSString *numberOfFollowing = [currentUser numberOfFollowing];
    
    if (isCurrentUser && [numberOfFollowers intValue]>0) {
        [buttonFollowersText setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [buttonFollowersText setEnabled: YES];
    } else {
        [buttonFollowersText setEnabled: NO];
    }
    
    if (isCurrentUser && [numberOfFollowing intValue]>0) {
        [buttonFollowingText setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [buttonFollowingText setEnabled: YES];
    } else {
        [buttonFollowingText setEnabled: NO];
    }
    
    [labelNumberFollowers setText: numberOfFollowers];
    [labelNumberFollowing setText: numberOfFollowing];
    
    [tableViewMicroPost reloadData];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [tableViewMicroPost setDataSource:self];
    [tableViewMicroPost setDelegate:self];
    
    [tableViewMicroPost setEnabledRefresh: YES];
    [tableViewMicroPost setEnabledLazyLoad: YES];
    
    [self refreshView];
}

- (void) buttonSegueClicked:(id)sender {
    //NSLog(@"buttonSegueClicked");
    
    if (![[Mindigno sharedMindigno] isLoggedUser]) {
        UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
        [self presentViewController:navController animated:YES completion:nil];
        
    } else {
        
        BOOL isSeguito = [buttonSegue isSelected];
        if (!isSeguito) {
            BOOL ok = [[Mindigno sharedMindigno] followUserWithID: [currentUser userID]];
            
            if (ok) {
                [currentUser setIsFollowedFromLoggedUser: !isSeguito];
                [buttonSegue setSelected: YES];
            }
            
        } else {
            BOOL ok = [[Mindigno sharedMindigno] removeFollowedUserWithID: [currentUser userID]];
            
            if (ok) {
                [currentUser setIsFollowedFromLoggedUser: !isSeguito];
                [buttonSegue setSelected: NO];
            }
        }
        
    }
}

///Start UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (int)[arrayMicroPost count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifierDefault = @"Row_MicroPost";
    static NSString *CellIdentifierVignetta = @"Row_MicroPost_Vignetta";
    
    NSString *CellIdentifier = CellIdentifierDefault;
    
    MicroPost *currentMicroPost = [arrayMicroPost objectAtIndex:indexPath.row];
    
    if ([currentMicroPost isVignetta]) {
        CellIdentifier = CellIdentifierVignetta;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    ///
    
    UIImageView *imageViewThumb = (UIImageView*)[cell viewWithTag:1];
    //Default setting
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    
    UILabel *labelTitle = (UILabel*)[cell viewWithTag:2];
    [labelTitle setText: [currentMicroPost title]];
    
    UILabel *labelDescription = (UILabel*)[cell viewWithTag:3];
    [labelDescription setText: [currentMicroPost description]];
    
    UILabel *labelSourceText = (UILabel*)[cell viewWithTag:4];
    [labelSourceText setHidden: NO];
    
    UIView *contentViewCreator = (UIView*)[cell viewWithTag:10];
    [contentViewCreator setHidden: YES];
    
    NSString *imgUrl = [currentMicroPost imageUrl];
    if (imgUrl != nil) {
        [imageViewThumb setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:placeHolder];
    }
    
    if ([currentMicroPost isLink]) {
        [labelSourceText setText: [currentMicroPost sourceText]];
        
    } else {
        
        if ([currentMicroPost isUserCreator]) {
            
            [labelSourceText setHidden: YES];
            [contentViewCreator setHidden: NO];
            
            UILabel *labelPreposition = (UILabel*)[cell viewWithTag:11];
            UIImageView *imageViewAvatarUser = (UIImageView*)[cell viewWithTag:12];
            UILabel *labelUsername = (UILabel*)[cell viewWithTag:13];
            
            User *user = [currentMicroPost userCreator];
            
            [labelPreposition setText:[currentMicroPost preposition]];
            [imageViewAvatarUser setImageWithURL:[NSURL URLWithString: [user avatarUrl]] placeholderImage:placeHolder];
            [labelUsername setText:[user name]];
            
        } else {
            [labelSourceText setText: [currentMicroPost defaultText]];
        }
    }
    
    UILabel *labelCreatedAtText = (UILabel*)[cell viewWithTag:5];
    [labelCreatedAtText setText: [currentMicroPost createdAtText]];
    
    ButtonWithBadge *buttonIndignati = (ButtonWithBadge*)[cell viewWithTag:6];
    
    //Debug
    //[buttonIndignati setTitle:[currentMicroPost numberOfIndignati] forState:UIControlStateNormal];
    //NSLog(@"indignati number: \"%@\"", [currentMicroPost numberOfIndignati]);
    //
    
    //Quando non ci sono indignati allora non visualizzo il badge e rendo non cliccabile il pulsante
    BOOL zeroIndignati = [[currentMicroPost numberOfIndignati] intValue] == 0;
    [buttonIndignati setBadgeString:[currentMicroPost numberOfIndignati]];
    if (zeroIndignati) {
        [buttonIndignati hideBadge: YES];
        [buttonIndignati setUserInteractionEnabled: NO];
        [buttonIndignati setAlpha: 0.4];
    } else {
        [buttonIndignati hideBadge: NO];
        [buttonIndignati setUserInteractionEnabled: YES];
        [buttonIndignati setAlpha: 1.0];
    }
    
    ButtonWithBadge *buttonComments = (ButtonWithBadge*)[cell viewWithTag:7];
    
    //Debug
    //[buttonComments setTitle:[currentMicroPost numberOfComments] forState:UIControlStateNormal];
    //NSLog(@"commenti number: \"%@\"", [currentMicroPost numberOfComments]);
    //
    
    //Quando non ci sono commenti allora non visualizzo il badge e rendo non cliccabile il pulsante
    BOOL zeroCommenti = [[currentMicroPost numberOfComments] intValue] == 0;
    if (zeroCommenti) {
        [buttonComments hideBadge: YES];
        [buttonComments setUserInteractionEnabled: NO];
        [buttonComments setAlpha: 0.4];
    } else {
        [buttonComments setBadgeString:[currentMicroPost numberOfComments]];
        [buttonComments hideBadge: NO];
        [buttonComments setUserInteractionEnabled: YES];
        [buttonComments setAlpha: 1.0];
    }
    
    UIButton *buttonShare = (UIButton*)[cell viewWithTag:8];
    [buttonShare addTarget:self action:@selector(buttonShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonMindigno = (UIButton*)[cell viewWithTag:9];
    [buttonMindigno addTarget:self action:@selector(buttonMindignoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonMindigno setSelected: [currentMicroPost isIndignato]];
    
    if ([currentMicroPost isVignetta]) {
        UIImageView *imageViewVignetta = (UIImageView*)[cell viewWithTag:15];
        
        NSString *vignettaUrl = [[currentMicroPost vignetta] vignettaUrl];
        [imageViewVignetta setImageWithURL:[NSURL URLWithString:vignettaUrl] placeholderImage:placeHolder];
    }
    
    return cell;
}
///Stop UITableViewDataSource

- (void) buttonShareClicked:(id)sender {
    
    //The indexPath must be taken from button and not from the tableView
    NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    MicroPost *currentMicroPost = [arrayMicroPost objectAtIndex: currentIndexPath.row];
    
    NSString *textToShare = [NSString stringWithFormat:@"%@ #mindigno", [currentMicroPost title]];
    [[Mindigno sharedMindigno] shareInfoOnViewController:self withText:textToShare imageName:nil url:[currentMicroPost micropostUrl]];
}

- (void) buttonMindignoClicked:(id)sender {
    //NSLog(@"buttonMindignoClicked");
    
    if (![[Mindigno sharedMindigno] isLoggedUser]) {
        UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
        [self presentViewController:navController animated:YES completion:nil];
        
    } else {
        
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        MicroPost *currentMicroPost = [arrayMicroPost objectAtIndex: currentIndexPath.row];
        
        UIButton *buttonMindigno = (UIButton*)sender;
        
        BOOL isIndignato = [buttonMindigno isSelected];
        if (!isIndignato) {
            BOOL ok = [[Mindigno sharedMindigno] indignatiSulMicroPostConID: [currentMicroPost micropostID]];
            
            if (ok) {
                [currentMicroPost addOneToNumberIndignati];
                [currentMicroPost setIsIndignato: !isIndignato];
            }
            
        } else {
            BOOL ok = [[Mindigno sharedMindigno] rimuoviIndignazioneSulMicroPostConID: [currentMicroPost micropostID]];
            
            if (ok) {
                [currentMicroPost removeOneToNumberIndignati];
                [currentMicroPost setIsIndignato: !isIndignato];
            }
        }
        
        [tableViewMicroPost reloadData];
    }
}

///Start UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    double defaultHeight = CELL_ROW_HEIGHT_DEFAULT;
    MicroPost *currentMicroPost = [arrayMicroPost objectAtIndex:indexPath.row];
    
    if ([currentMicroPost isVignetta]) {
        return defaultHeight*2;
        
    } else {
        return defaultHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"didSelectRowAtIndexPath clicked row number: %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
///Stop UITableViewDelegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"profileUserToMicropostDetail"]) {
        
        NSIndexPath* currentIndexPath = [tableViewMicroPost indexPathForSelectedRow];
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        MicroPostDetailVC *microPostDetailVC = (MicroPostDetailVC*)[segue destinationViewController];
        [microPostDetailVC setCurrentMicroPost: [arrayMicroPost objectAtIndex:currentIndexPath.row]];
        
    } else if ([[segue identifier] isEqualToString:@"profileUserToIndignati"]) {
        
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        IndignatiVC *indignatiVC = (IndignatiVC*)[segue destinationViewController];
        [indignatiVC setCurrentMicroPost: [arrayMicroPost objectAtIndex: currentIndexPath.row]];
        
    } else if ([[segue identifier] isEqualToString:@"profileUserToComments"]) {
        
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        CommentsVC *commentsDettailVC = (CommentsVC*)[segue destinationViewController];
        
        MicroPost *currentMicroPost = [arrayMicroPost objectAtIndex: currentIndexPath.row];
        [commentsDettailVC setCurrentMicroPost: currentMicroPost];
    
    } else if ([[segue identifier] isEqualToString:@"profileUserToFollowing"]) {
        
        FollowingFollowerVC *followingFollowerVC = (FollowingFollowerVC*)[segue destinationViewController];
        [followingFollowerVC setIsFollowing: YES];
    
    } else if ([[segue identifier] isEqualToString:@"profileUserToFollower"]) {
    
        FollowingFollowerVC *followingFollowerVC = (FollowingFollowerVC*)[segue destinationViewController];
        [followingFollowerVC setIsFollowing: NO];
    }
}

//Start PullRefreshTableViewDelegate
- (void) tableViewHasRefreshed:(UITableView*)tableView {
    
    [self setArrayMicroPost: [[Mindigno sharedMindigno] downloadMicroPostsOfUser: currentUser]];
    
    //[tableViewMicroPost setEnabledLazyLoad:YES];
    [tableViewMicroPost reloadData];
}

- (void) loadNewDataInBackgroundForTableView:(UITableView*)tableView {
    
    //Ritorna nil se non ci sono più vecchi micropost
    NSArray *microposts = [[Mindigno sharedMindigno] downloadMoreOldMicroPostsOfUser: currentUser];
    
    if (microposts == nil) {
        [tableViewMicroPost setEnabledLazyLoad:NO];
    }
    
    [tableViewMicroPost reloadData];
}
//Stop PullRefreshTableViewDelegate

@end
