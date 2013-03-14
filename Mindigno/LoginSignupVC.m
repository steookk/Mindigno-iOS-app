//
//  LoginSignUpVC.m
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "LoginSignupVC.h"
#import "Utils.h"
#import "NotificationKeys.h"

@interface LoginSignupVC ()

@end

@implementation LoginSignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"rilegatura.png"] forBarMetrics:UIBarMetricsDefault];
    
    [Utils setButtonRoundAndTrasparent:buttonLogin];
    [Utils setButtonRoundAndTrasparent:buttonSignup];
}

- (IBAction)exitFromModalView:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DISCARD_LOGIN_SIGNUP_NOTIFICATION object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
