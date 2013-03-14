//
//  LoginSignUpVC.h
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface LoginSignupVC : UIViewController {
    
    IBOutlet UIButton *buttonLogin;
    IBOutlet UIButton *buttonSignup;
}

- (IBAction)exitFromModalView:(id)sender;

@end
