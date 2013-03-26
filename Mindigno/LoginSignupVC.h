//
//  LoginSignUpVC.h
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GTKeyboardHelper/GTKeyboardHelper.h>

@interface LoginSignupVC : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, FBLoginViewDelegate> {
    
    IBOutlet UIButton *buttonSignup;
    IBOutlet FBLoginView *fbLoginView;
    
    IBOutlet UITextField *textFieldUsername;
    IBOutlet UITextField *textFieldPassword;
}

- (IBAction)login:(id)sender;
- (IBAction)exitFromModalView:(id)sender;

@end
