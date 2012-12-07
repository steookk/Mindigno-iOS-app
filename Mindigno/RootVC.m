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
#import <SDWebImage/UIImageView+WebCache.h>

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
    
    //UIImage *imageAvatar = [UIImage imageNamed:@"Kenny"];
    //[imageViewAvatar setImage:imageAvatar];
    
    [imageViewAvatar setImageWithURL:[NSURL URLWithString:[currentMicroPost imageUrl]]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    UILabel *labelTitle = (UILabel*)[cell viewWithTag:2];
    [labelTitle setText: [currentMicroPost title]];
    
    UILabel *labelDescription = (UILabel*)[cell viewWithTag:3];
    [labelDescription setText: [currentMicroPost description]];
    
    UILabel *labelIndignatiText = (UILabel*)[cell viewWithTag:4];
    [labelIndignatiText setText: [currentMicroPost indignatiText]];
    
    UILabel *labelCreatedAtText = (UILabel*)[cell viewWithTag:9];
    [labelCreatedAtText setText: [currentMicroPost createdAtText]];
    
    UIButton *buttonFacebook = (UIButton*)[cell viewWithTag:5];
    
    UIButton *buttonTwitter = (UIButton*)[cell viewWithTag:6];
    
    UIButton *buttonMindigno = (UIButton*)[cell viewWithTag:7];
    
    UIButton *buttonCommenta = (UIButton*)[cell viewWithTag:8];

    return cell;
}
///Stop UITableViewDataSource

///Start UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"didSelectRowAtIndexPath clicked row number: %d", indexPath.row);
}
///Stop UITableViewDelegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath* currentIndexPath = [tableViewMicroPost indexPathForSelectedRow];
    NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
    
    MicroPostDetailVC *microPostDetailVC = (MicroPostDetailVC*)[segue destinationViewController];
    [microPostDetailVC setCurrentMicropost: [arrayMicroPost objectAtIndex:currentIndexPath.row]];
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
