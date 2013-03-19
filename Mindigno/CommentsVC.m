//
//  CommentsDettailVC.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "CommentsVC.h"
#import "Comment.h"
#import "UIImageView+WebCache.h"
#import "CommentDetailVC.h"
#import "Mindigno.h"

#define BUTTON_TUTTI_I_COMMENTI_INDEX 0
#define BUTTON_MIEI_COMMENTI_INDEX 1

@interface CommentsVC ()

@end

@implementation CommentsVC

@synthesize currentMicroPost, indexRowToSelect;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder: aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[Mindigno sharedMindigno] isLoggedUser]) {
        [buttonGoToEditor setUserInteractionEnabled: YES];
        [buttonGoToEditor setAlpha: 1.0];
    } else {
        [buttonGoToEditor setUserInteractionEnabled: NO];
        [buttonGoToEditor setAlpha: 0.3];
    }
    
    arrayButtonTitle = [currentMicroPost commentsTabs_buttons];
    //NSLog(@"number of arrayButtonTitle: %d", [arrayButtonTitle count]);
    
    //
    [scrollButtonBar setDataSourceBar:self];
    [scrollButtonBar setDelegateBar:self];
    [scrollButtonBar startInizialization];
    
    //
    [tableViewComments setDataSource:self];
    [tableViewComments setDelegate:self];
    
    /*
    [tableViewComments reloadData];
    [tableViewComments selectRowAtIndexPath: indexRowToSelect animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableViewComments scrollToRowAtIndexPath:indexRowToSelect atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
     */
    
    arrayComments = nil;
    [scrollButtonBar clickButtonWithIndex: BUTTON_TUTTI_I_COMMENTI_INDEX];
    //NSLog(@"number of comments: %d", [arrayComments count]);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [tableViewComments reloadData];
}

- (void)viewDidAppear:(BOOL)animated {

    [tableViewComments deselectRowAtIndexPath:indexRowToSelect animated:YES];
}

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
    
    if (index == BUTTON_TUTTI_I_COMMENTI_INDEX) {
        arrayComments = [[Mindigno sharedMindigno] downloadAllCommentsForMicropost: currentMicroPost];
        
    } else if (index == BUTTON_MIEI_COMMENTI_INDEX) {
        arrayComments = [[Mindigno sharedMindigno] downloadUserCommentsForMicropost: currentMicroPost];
    }
    
    [tableViewComments reloadData];
}
//Stop ScrollButtonBarDelegate


///Start UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrayComments count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Row_Comment";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    Comment *comment = [arrayComments objectAtIndex: indexPath.row];
    User *user = [comment userCreator];
    ///
    
    UIImageView *imageViewUserAvatar = (UIImageView*)[cell viewWithTag:1];
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewUserAvatar setImageWithURL:[NSURL URLWithString:[user avatarUrl]] placeholderImage:placeHolder];
    
    UILabel *labelUserName = (UILabel*)[cell viewWithTag:2];
    [labelUserName setText: [user name]];
    
    UILabel *labelComment = (UILabel*)[cell viewWithTag:3];
    //[labelComment setAutoresizingMask: UIViewAutoresizingFlexibleHeight];
    //[labelComment setNumberOfLines:0];
    [labelComment setText: [comment content]];
    //[labelComment sizeToFit];
    
    //[cell setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    //[cell sizeToFit];
    
    return cell;
}
///Stop UITableViewDataSource

///Start UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Comment *comment = [arrayComments objectAtIndex: indexPath.row];
    NSString *textComment = [comment content];
    
    double textHeight = [textComment sizeWithFont:[UIFont fontWithName:@"Arial" size:13] constrainedToSize:CGSizeMake(310, 500) lineBreakMode:NSLineBreakByTruncatingTail].height;
    
    double cellHeight = 62.0;
    double labelHeight = 20.0;
    
    double defaultHeight = (cellHeight-labelHeight)+textHeight;
    
    return defaultHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath clicked section: %d, row: %d", indexPath.section, indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
///Stop UITableViewDelegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"commentsToDetailComment"]) {
        
        NSIndexPath* currentIndexPath = [tableViewComments indexPathForSelectedRow];
        
        CommentDetailVC *commentDetailVC = (CommentDetailVC*)[segue destinationViewController];
        [commentDetailVC setCurrentComment: [arrayComments objectAtIndex:currentIndexPath.row]];
    
    } else if ([[segue identifier] isEqualToString:@"commentsToEditor"]) {
        
        CommentEditorVC *editorVC = (CommentEditorVC*)[segue destinationViewController];
        [editorVC setCurrentMicroPost: currentMicroPost];
    }
}

- (IBAction)goBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
