//
//  ViewController.m
//  Mindigno
//
//  Created by Enrico on 28/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "RootVC.h"
#import "MicroPost.h"
#import "MicroPostDetailVC.h"
#import "UIImageView+WebCache.h"
#import "Mindigno.h"
#import "Utils.h"
#import "IndignatiVC.h"
#import "CommentsVC.h"

#define CELL_ROW_HEIGHT_DEFAULT 200.0f

@interface RootVC ()

@end

@implementation RootVC

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        arrayButtonTitle = [NSArray arrayWithObjects:@"Tutte le indignazioni", @"Solo chi seguo", @"Politica", @"Sport", nil];
        
        //
        
        NSArray *microPosts = [[Mindigno sharedMindigno] microPosts];
        arrayMicroPost = [NSMutableArray arrayWithArray: microPosts];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [mainButtonBar setDelegate:self];
    
    [tableViewMicroPost setDataSource:self];
    [tableViewMicroPost setDelegate:self];
    
    [scrollButtonBar setDataSourceBar:self];
    [scrollButtonBar setDelegateBar:self];
}

//Start MainButtonBarDelegate
- (void) clickedButtonHome {
    NSLog(@"clickedButtonHome");
}

- (void) clickedButtonProfile {
    NSLog(@"clickedButtonProfile");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    
    [self presentViewController:vc animated:YES completion:nil];

}

- (void) clickedButtonSearch {
    NSLog(@"clickedButtonSearch");
}
//Stop MainButtonBarDelegate

//Start ScrollButtonBarDataSource
- (NSInteger) numberOfButtonsInScrollButtonBar:(ScrollButtonBar*)scrollButtonBar {
    return [arrayButtonTitle count];
}

- (void) setButtonProperties:(UIButton*)button withIndex:(NSInteger)index {

    NSString *title = [arrayButtonTitle objectAtIndex:index];
    [button setTitle:title forState:UIControlStateNormal];
    [[button titleLabel] setFont: [UIFont fontWithName:@"Arial" size:14]];
}

- (NSString*) backgroundImageUrlOfSelectedButton {
    
    return @"barra-gialla.png";
}
//Stop ScrollButtonBarDataSource

//Start ScrollButtonBarDelegate
- (void) buttonClicked:(UIButton*)button withIndex:(NSInteger)index {
    
    NSLog(@"Button clicked with title: %@", [[button titleLabel] text]);
    NSLog(@"Button selected index: %d", [scrollButtonBar indexOfCurrentSelectedButton]);
    
    if (index != 1) {
        [tableViewMicroPost setEnabledRefresh:NO];
        [tableViewMicroPost setEnabledLazyLoad:NO];
    } else {
        [tableViewMicroPost setEnabledRefresh:YES];
        [tableViewMicroPost setEnabledLazyLoad:YES];
    }
}
//Stop ScrollButtonBarDelegate

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
            UIImageView *imageViewAvatar = (UIImageView*)[cell viewWithTag:12];
            UILabel *labelUsername = (UILabel*)[cell viewWithTag:13];
            
            User *user = [currentMicroPost userCreator];
            
            [labelPreposition setText:[currentMicroPost preposition]];
            [imageViewAvatar setImageWithURL:[NSURL URLWithString: [user avatarUrl]] placeholderImage:placeHolder];
            [labelUsername setText:[user name]];
            
        } else {
            [labelSourceText setText: [currentMicroPost defaultText]];
        }
    }
    
    UILabel *labelCreatedAtText = (UILabel*)[cell viewWithTag:5];
    [labelCreatedAtText setText: [currentMicroPost createdAtText]];
    
    UIButton *buttonIndignati = (UIButton*)[cell viewWithTag:6];
    [buttonIndignati setTitle:[currentMicroPost numberOfIndignati] forState:UIControlStateNormal];
    
    UIButton *buttonComments = (UIButton*)[cell viewWithTag:7];
    [buttonComments setTitle:[currentMicroPost numberOfComments] forState:UIControlStateNormal];
    
    UIButton *buttonShare = (UIButton*)[cell viewWithTag:8];
    [buttonShare addTarget:self action:@selector(buttonShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonMindigno = (UIButton*)[cell viewWithTag:9];
    
    if ([currentMicroPost isVignetta]) {
        UIImageView *imageViewVignetta = (UIImageView*)[cell viewWithTag:15];
        
        NSString *vignettaUrl = [[currentMicroPost vignetta] vignettaUrl];
        [imageViewVignetta setImageWithURL:[NSURL URLWithString:vignettaUrl] placeholderImage:placeHolder];
    }

    return cell;
}
///Stop UITableViewDataSource

- (void) buttonShareClicked:(id)sender {

    [[Mindigno sharedMindigno] shareInfo: self];
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
    
    if ([[segue identifier] isEqualToString:@"homeToMicropostDetail"]) {
        
        NSIndexPath* currentIndexPath = [tableViewMicroPost indexPathForSelectedRow];
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        MicroPostDetailVC *microPostDetailVC = (MicroPostDetailVC*)[segue destinationViewController];
        [microPostDetailVC setCurrentMicroPost: [arrayMicroPost objectAtIndex:currentIndexPath.row]];
        
    } else if ([[segue identifier] isEqualToString:@"homeToIndignati"]) {
        
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        NSLog(@"homeToIndignati");
        
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        IndignatiVC *indignatiVC = (IndignatiVC*)[segue destinationViewController];
        [indignatiVC setCurrentMicroPost: [arrayMicroPost objectAtIndex: currentIndexPath.row]];
    
    } else if ([[segue identifier] isEqualToString:@"homeToComments"]) {
        
        NSLog(@"homeToComments");
        
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        CommentsVC *commentsDettailVC = (CommentsVC*)[segue destinationViewController];
        
        MicroPost *currentMicroPost = [arrayMicroPost objectAtIndex: currentIndexPath.row];
        [commentsDettailVC setCurrentMicroPost: currentMicroPost];
    }
}

//Start PullRefreshTableViewDelegate
- (void) tableViewHasRefreshed:(UITableView*)tableView {
    
    NSLog(@"Refreshed table -> button selected index: %d", [scrollButtonBar indexOfCurrentSelectedButton]);
    
}

- (void) loadNewDataInBackgroundForTableView:(UITableView*)tableView {

    sleep(1);
    
    //[jsonParser startDownloadAndParsingJsonAtUrl: URL_JSON_MICROPOST_TEST];
    //[arrayMicroPost addObjectsFromArray: [jsonParser microPosts]];
    
    /*
    int _3days = 60*60*24*3;
    [[[SDWebImageManager sharedManager] imageCache] setMaxCacheAge: _3days];
    //[[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [[[SDWebImageManager sharedManager] imageCache] cleanDisk];
     */
}
//Stop PullRefreshTableViewDelegate


@end
