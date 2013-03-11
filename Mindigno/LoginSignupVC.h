//
//  LoginSignUpVC.h
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@protocol LoginSignupVCDelegate

@optional
- (void) loginSignupDiscarded;
- (BOOL)respondsToSelector:(SEL)aSelector;

@end

@interface LoginSignupVC : UIViewController {

    id <LoginSignupVCDelegate> __weak delegate;
    
    IBOutlet UIButton *buttonLogin;
    IBOutlet UIButton *buttonSignup;
}

@property (nonatomic, weak) id <LoginSignupVCDelegate> delegate;

- (IBAction)exitFromModalView:(id)sender;

@end
