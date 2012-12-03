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
        //TODO: Non serve l'url per ora.
        [jsonParser startDownloadAndParsingJsonAtUrl: URL_JSON_MICROPOST_TEST];
        
        arrayMicroPost = [jsonParser microPosts];
        
        //
        
        /*
        MicroPost *micropost = [[MicroPost alloc] init];
        [micropost setTitle:@"Title"];
        [micropost setDescription:@"Description"];
        [micropost setCreatedAtText:@"Created 3 hours ago"];
        [micropost setIndignatiText:@"3 indignati found"];
        [micropost setSourceText:@"from corriere"];
        [micropost setIsLink:YES];
        
        MicroPost *micropost2 = [[MicroPost alloc] init];
        [micropost2 setTitle:@"Title 2 "];
        [micropost2 setDescription:@"Description 2"];
        [micropost2 setCreatedAtText:@"Created 3 hours ago 2"];
        [micropost2 setIndignatiText:@"3 indignati found 2"];
        [micropost2 setSourceText:@"from corriere 2"];
        [micropost2 setIsLink:YES];
        
        MicroPost *micropost3 = [[MicroPost alloc] init];
        [micropost3 setTitle:@"Title 3"];
        [micropost3 setDescription:@"Description 3"];
        [micropost3 setCreatedAtText:@"Created 3 hours ago 3"];
        [micropost3 setIndignatiText:@"3 indignati found 3"];
        [micropost3 setSourceText:@"from corriere 3"];
        [micropost3 setIsLink:YES];
        
        MicroPost *micropost4 = [[MicroPost alloc] init];
        [micropost4 setTitle:@"Title 4"];
        [micropost4 setDescription:@"Description 4"];
        [micropost4 setCreatedAtText:@"Created 3 hours ago 4"];
        [micropost4 setIndignatiText:@"3 indignati found 4"];
        [micropost4 setSourceText:@"from corriere 4"];
        [micropost4 setIsLink:YES];
        
        MicroPost *micropost5 = [[MicroPost alloc] init];
        [micropost5 setTitle:@"Title 5"];
        [micropost5 setDescription:@"Description 5"];
        [micropost5 setCreatedAtText:@"Created 3 hours ago 5"];
        [micropost5 setIndignatiText:@"3 indignati found 5"];
        [micropost5 setSourceText:@"from corriere 5"];
        [micropost5 setIsLink:YES];
        
        [arrayMicroPost addObject: micropost];
        [arrayMicroPost addObject: micropost2];
        [arrayMicroPost addObject: micropost3];
        [arrayMicroPost addObject: micropost4];
        [arrayMicroPost addObject: micropost5];
        */
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [tableViewMicroPost setDataSource:self];
    [tableViewMicroPost setDelegate:self];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[tableViewMicroPost reloadData];
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
