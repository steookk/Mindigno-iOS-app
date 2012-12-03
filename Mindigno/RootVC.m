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
#import "JParserUserAndMicroPost.h"

@interface RootVC ()

@end

@implementation RootVC

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        JParserUserAndMicroPost *jsonParser = [[JParserUserAndMicroPost alloc] init];
        [jsonParser startDownloadAndParsingJsonAtUrl: URL_JSON_MICROPOST_TEST];
        
        arrayMicroPost = [jsonParser microPosts];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [tableViewMicroPost setDataSource:self];
    [tableViewMicroPost setDelegate:self];
    
    ///
    
    scrollBar = [[ScrollButtonBar alloc] initWithFrame:contentViewScrollBar.frame buttonTitles:[NSArray arrayWithObjects:@"Button_11111111", @"Button_222", @"Button_3", @"Button_444444444", @"Button_555", @"Button_6", nil]];
    [[self view] addSubview: scrollBar];
}

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
    
    //NSURL *url = [NSURL URLWithString: @"http://thumbs.dreamstime.com/thumblarge_516/1277756333MAkH05.jpg"];
    //NSData *imageData = [NSData dataWithContentsOfURL:url];
    //UIImage *imageAvatar = [UIImage imageWithData: imageData];
    UIImage *imageAvatar = [UIImage imageNamed:@"Kenny"];
    [imageViewAvatar setImage:imageAvatar];
    
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

@end
