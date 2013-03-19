//
//  MicroPostDetailVCViewController.m
//  Mindigno
//
//  Created by Enrico on 30/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MicroPostDetailVC.h"
#import "UIImageView+WebCache.h"
#import "IndignatiVC.h"
#import "CommentEditorVC.h"
#import "CommentsVC.h"
#import "Mindigno.h"
#import "Comment.h"

@interface MicroPostDetailVC ()

@end

@implementation MicroPostDetailVC

@synthesize currentMicroPost;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
    arrayComments = [currentMicroPost defaultComments];
    
    [tableViewComments setDataSource:self];
    [tableViewComments setDelegate:self];
    
    [tableViewComments reloadData];
    
    //
    
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewThumb setImageWithURL: [NSURL URLWithString:[currentMicroPost imageUrl]] placeholderImage:placeHolder];
    
    [labelTitle setText:[currentMicroPost title]];
    
    ///Settings of heights of header of tableView
    
    NSString *description = [currentMicroPost description];
    double textHeight = [description sizeWithFont:labelTitle.font constrainedToSize:CGSizeMake(310, 500) lineBreakMode:labelTitle.lineBreakMode].height;
    
    [labelDescription setText: description];
    double labelDescriptionHeight = 20.0;
    CGRect descriptionRect = [contentViewDescription frame];
    CGRect newDescriptionRect = CGRectMake(descriptionRect.origin.x, descriptionRect.origin.y, descriptionRect.size.width, descriptionRect.size.height-labelDescriptionHeight+textHeight);
    [contentViewDescription setFrame:newDescriptionRect];
    
    CGRect bodyRect = [contentViewBody frame];
    double yBody = newDescriptionRect.origin.y + newDescriptionRect.size.height;
    CGRect newBodyRect = CGRectMake(bodyRect.origin.x, yBody, bodyRect.size.width, bodyRect.size.height);
    [contentViewBody setFrame:newBodyRect];
    
    double contentHeigth = contentViewHeader.frame.size.height + contentViewDescription.frame.size.height + contentViewBody.frame.size.height;
    CGRect newContentRect = CGRectMake(0, 0, contentView.frame.size.width, contentHeigth);
    [contentView setFrame:newContentRect];
    
    [tableViewComments setTableHeaderView:contentView];
    
    UIColor *clearColor = [UIColor clearColor];
    
    [contentView setBackgroundColor: clearColor];
    [contentViewHeader setBackgroundColor: clearColor];
    [contentViewDescription setBackgroundColor: clearColor];
    [contentViewBody setBackgroundColor: clearColor];
    
    ///
    
    [labelSourceText setHidden: NO];
    [contentViewCreator setHidden: YES];
    [buttonGoToSource setHidden: YES];
    
    if ([currentMicroPost isLink]) {
        
        [buttonGoToSource setHidden: NO];
        [labelSourceText setText: [currentMicroPost sourceText]];
        
    } else {
        
        if ([currentMicroPost isUserCreator]) {
            
            [labelSourceText setHidden: YES];
            [contentViewCreator setHidden: NO];
            
            UILabel *labelPreposition = (UILabel*)[contentViewCreator viewWithTag:11];
            UIImageView *imageViewAvatar = (UIImageView*)[contentViewCreator viewWithTag:12];
            UILabel *labelUsername = (UILabel*)[contentViewCreator viewWithTag:13];
            
            User *user = [currentMicroPost userCreator];
            
            [labelPreposition setText:[currentMicroPost preposition]];
            [imageViewAvatar setImageWithURL:[NSURL URLWithString: [user avatarUrl]] placeholderImage:placeHolder];
            [labelUsername setText:[user name]];
            
        } else {
            [labelSourceText setText: [currentMicroPost defaultText]];
        }
    }
    
    [[buttonIndignatiText titleLabel] setNumberOfLines:2];
    [[buttonIndignatiText titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[buttonIndignatiText titleLabel] setTextAlignment:NSTextAlignmentLeft];
    [buttonIndignatiText setTitle:[currentMicroPost indignatiText] forState:UIControlStateNormal];
    
    [[buttonDefaultCommentText titleLabel] setNumberOfLines:2];
    [[buttonDefaultCommentText titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[buttonDefaultCommentText titleLabel] setTextAlignment:NSTextAlignmentLeft];
    [buttonDefaultCommentText setTitle:[currentMicroPost defaultCommentsText] forState:UIControlStateNormal];
    
    if ([arrayComments count] == 0) {
        [buttonDefaultCommentText setUserInteractionEnabled:NO];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [buttonDefaultCommentText setTitle:[currentMicroPost defaultCommentsText] forState:UIControlStateNormal];
    [tableViewComments reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"micropostDetailToIndignati"]) {
        
        IndignatiVC *indignatiVC = (IndignatiVC*)[segue destinationViewController];
        [indignatiVC setCurrentMicroPost: currentMicroPost];
    
    } else if ([[segue identifier] isEqualToString:@"micropostDetailToEditor"]) {
        
        CommentEditorVC *editorVC = (CommentEditorVC*)[segue destinationViewController];
        [editorVC setCurrentMicroPost: currentMicroPost];
    
    } else if ([[segue identifier] isEqualToString:@"micropostDetailToComments"]) {
    
        CommentsVC *commentsDettailVC = (CommentsVC*)[segue destinationViewController];
        
        [commentsDettailVC setCurrentMicroPost: currentMicroPost];
        
        NSIndexPath* currentIndexPath = [tableViewComments indexPathForSelectedRow];
        [commentsDettailVC setIndexRowToSelect: currentIndexPath];
    }
}

///Start UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (int)[arrayComments count];
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

- (IBAction)goToSource:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [currentMicroPost link]]];
}

- (IBAction)share:(id)sender {
    [[Mindigno sharedMindigno] shareInfoOnViewController: self];
}

- (IBAction)goBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
