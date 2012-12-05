//
//  LoginSignUpVC.m
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "LoginSignupVC.h"
#import "RoundUtils.h"

@interface LoginSignupVC ()

@end

@implementation LoginSignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RoundUtils setButtonRoundAndTrasparent:buttonLogin];
    [RoundUtils setButtonRoundAndTrasparent:buttonSignup];

    UIImage *image = [UIImage imageNamed:@"path"];
    [imageViewBackground setImage:[RoundUtils makeRoundCornerImage:image withCornerWidth:20 andWithCornerHeight:20]];
}

- (IBAction)exitFromModalView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
