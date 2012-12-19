//
//  CommentsDettailVC.h
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditorVC.h"
#import "ScrollButtonBar.h"
#import "MicroPost.h"

@interface CommentsVC : UIViewController <UITableViewDataSource, UITableViewDelegate, EditorVCDelegate, ScrollButtonBarDataSource, ScrollButtonBarDelegate> {

    MicroPost __weak *currentMicroPost;
    
    NSMutableArray *arrayComments;
    IBOutlet UITableView *tableViewComments;
    
    //
    NSArray *arrayButtonTitle;
    IBOutlet ScrollButtonBar *scrollButtonBar;
    
    NSIndexPath *indexRowToSelect;
}

@property(nonatomic, weak) MicroPost *currentMicroPost;
@property(nonatomic, retain) NSIndexPath *indexRowToSelect;

- (IBAction)goBack:(id)sender;

@end
