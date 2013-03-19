//
//  EditorVC.h
//  Mindigno
//
//  Created by Enrico on 18/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicroPost.h"

@interface CommentEditorVC : UIViewController <UITextViewDelegate> {

    MicroPost __weak *currentMicroPost;
    
    IBOutlet UITextView *textViewContent;
}

@property (nonatomic, weak) MicroPost *currentMicroPost;

- (IBAction)done:(id)sender;
- (IBAction)goBack:(id)sender;

@end
