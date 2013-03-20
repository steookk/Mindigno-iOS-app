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

@interface LoginSignupVC : UIViewController <FBLoginViewDelegate> {
    
    IBOutlet UIButton *buttonLogin;
    IBOutlet UIButton *buttonSignup;
    
    IBOutlet FBLoginView *fbLoginView;
}

- (IBAction)exitFromModalView:(id)sender;

@end
