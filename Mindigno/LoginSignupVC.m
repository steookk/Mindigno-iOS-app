//
//  LoginSignUpVC.m
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "LoginSignupVC.h"
#import "Utils.h"

@interface LoginSignupVC ()

@end

@implementation LoginSignupVC

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"rilegatura.png"] forBarMetrics:UIBarMetricsDefault];
    
    [Utils setButtonRoundAndTrasparent:buttonLogin];
    [Utils setButtonRoundAndTrasparent:buttonSignup];
}

- (IBAction)exitFromModalView:(id)sender {
    
    if ([delegate respondsToSelector: @selector(loginSignupDiscarded)]) {
        [delegate loginSignupDiscarded];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
