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

    MicroPost __weak *currentMicropost;
    
    //
    
    IBOutlet UIImageView *imageViewAvatar;
    IBOutlet UILabel *labelTitle;
    IBOutlet UITextView *textViewDescription;
    IBOutlet UILabel *labelIndignatiText;
}

@property(nonatomic, weak) MicroPost *currentMicropost;

- (IBAction)goBack:(id)sender;

@end
