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

@interface RootVC ()

@end

@implementation RootVC

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        arrayButtonTitle = [NSArray arrayWithObjects:@"Tutte le indignazioni", @"Solo chi seguo", @"Politica", @"Sport", nil];
        
        //
        
        jsonParser = [[JParserUserAndMicroPost alloc] init];
        [jsonParser startDownloadAndParsingJsonAtUrl: URL_JSON_MICROPOST_TEST];
        
        arrayMicroPost = [NSMutableArray array];
        [arrayMicroPost addObjectsFromArray: [jsonParser microPosts]];
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
    
    [self presentModalViewController:vc animated:YES];

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
    
    static NSString *CellIdentifier = @"Row_MicroPost";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    MicroPost *currentMicroPost = [arrayMicroPost objectAtIndex:indexPath.row];
    
    ///
    
    UIImageView *imageViewAvatar = (UIImageView*)[cell viewWithTag:1];
    //Default setting
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewAvatar setImage: placeHolder];
    
    UILabel *labelTitle = (UILabel*)[cell viewWithTag:2];
    [labelTitle setText: [currentMicroPost title]];
    
    UILabel *labelDescription = (UILabel*)[cell viewWithTag:3];
    [labelDescription setText: [currentMicroPost description]];
    
    UILabel *labelSourceText = (UILabel*)[cell viewWithTag:4];
    
    if ([currentMicroPost isLink]) {
        
        NSString *imgUrl = [currentMicroPost imageUrl];
        if (imgUrl != nil) {
            [imageViewAvatar setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:placeHolder];
        }
        
        [labelSourceText setText: [currentMicroPost sourceText]];
    
    } else {
        
        if ([currentMicroPost isUserCreator]) {
            //TODO: recuperare autore e prendere il nome
            NSString *prepositionAuthor = [NSString stringWithFormat:@"%@ %@", [currentMicroPost preposition], @"Autore ancora da inserire"];
            [labelSourceText setText: prepositionAuthor];
            
        } else {
            [labelSourceText setText: [currentMicroPost defaultText]];
        }
    }
    
    UILabel *labelCreatedAtText = (UILabel*)[cell viewWithTag:5];
    [labelCreatedAtText setText: [currentMicroPost createdAtText]];
    
    UIButton *buttonIndignati = (UIButton*)[cell viewWithTag:6];
    
    UIButton *buttonComments = (UIButton*)[cell viewWithTag:7];
    
    UIButton *buttonShare = (UIButton*)[cell viewWithTag:8];
    [buttonShare addTarget:self action:@selector(buttonShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonMindigno = (UIButton*)[cell viewWithTag:9];

    return cell;
}
///Stop UITableViewDataSource

- (void) buttonShareClicked:(id)sender {

    NSString *textToShare = @"I just shared this from my App";
    UIImage *imageToShare = [UIImage imageNamed:@"Default.png"];
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.bronron.com"];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities: nil];
    
    //This is an array of excluded activities to appear on the UIActivityViewController
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [self presentModalViewController:activityVC animated:YES];
}

///Start UITableViewDelegate
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
        [microPostDetailVC setCurrentMicropost: [arrayMicroPost objectAtIndex:currentIndexPath.row]];
        
    } else if ([[segue identifier] isEqualToString:@"homeToIndignati"]) {
        
        NSLog(@"homeToIndignati");
    
    } else if ([[segue identifier] isEqualToString:@"homeToComments"]) {
        
        NSLog(@"homeToComments");
        
    }
}

//Start PullRefreshTableViewDelegate
- (void) tableViewHasRefreshed:(UITableView*)tableView {
    
    NSLog(@"Refreshed table -> button selected index: %d", [scrollButtonBar indexOfCurrentSelectedButton]);
    
}

- (void) loadNewDataInBackgroundForTableView:(UITableView*)tableView {

    sleep(1);
    
    [jsonParser startDownloadAndParsingJsonAtUrl: URL_JSON_MICROPOST_TEST];
    [arrayMicroPost addObjectsFromArray: [jsonParser microPosts]];
    
    /*
    int _3days = 60*60*24*3;
    [[[SDWebImageManager sharedManager] imageCache] setMaxCacheAge: _3days];
    //[[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [[[SDWebImageManager sharedManager] imageCache] cleanDisk];
     */
}
//Stop PullRefreshTableViewDelegate


@end
