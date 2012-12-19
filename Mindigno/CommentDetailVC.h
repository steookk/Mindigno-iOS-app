//
//  CommentDetailVC.h
//  Mindigno
//
//  Created by Enrico on 17/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentDetailVC : UIViewController {

    Comment *currentComment;
    
    IBOutlet UILabel *labelName;
    IBOutlet UIImageView *imageViewAvatar;
    
    IBOutlet UITextView *textViewComment;
}

@property(nonatomic, retain) Comment *currentComment;

- (IBAction)goBack:(id)sender;

@end
