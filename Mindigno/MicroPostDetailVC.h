//
//  MicroPostDetailVCViewController.h
//  Mindigno
//
//  Created by Enrico on 30/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicroPost.h"

@interface MicroPostDetailVC : UIViewController {

    MicroPost __weak *currentMicroPost;
    
    //
    
    IBOutlet UIImageView *imageViewThumb;
    IBOutlet UILabel *labelTitle;
    IBOutlet UITextView *textViewDescription;
    
    IBOutlet UILabel *labelSourceText;
    IBOutlet UIView *contentViewCreator;
    
    IBOutlet UIButton *buttonIndignatiText;
    IBOutlet UILabel *labelDefaultCommentText;
    
    IBOutlet UIButton *buttonGoToSource;
}

@property(nonatomic, weak) MicroPost *currentMicroPost;

- (IBAction)goToSource:(id)sender;
- (IBAction)goBack:(id)sender;

@end
