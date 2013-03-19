//
//  MicroPostDetailVCViewController.h
//  Mindigno
//
//  Created by Enrico on 30/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicroPost.h"
#import "CommentEditorVC.h"

@interface MicroPostDetailVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    MicroPost __weak *currentMicroPost;
    
    //
    
    IBOutlet UIView *contentView;
    IBOutlet UIView *contentViewHeader;
    IBOutlet UIView *contentViewDescription;
    IBOutlet UIView *contentViewBody;
    
    IBOutlet UIImageView *imageViewThumb;
    IBOutlet UILabel *labelTitle;
    IBOutlet UILabel *labelDescription;
    
    IBOutlet UILabel *labelSourceText;
    IBOutlet UIView *contentViewCreator;
    
    IBOutlet UIButton *buttonGoToSource;
    IBOutlet UIButton *buttonIndignatiText;
    IBOutlet UIButton *buttonDefaultCommentText;
    
    NSArray *arrayComments;
    IBOutlet UITableView *tableViewComments;
}

@property(nonatomic, weak) MicroPost *currentMicroPost;

- (IBAction)goToSource:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)goBack:(id)sender;

@end
