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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utils setButtonRoundAndTrasparent:buttonLogin];
    [Utils setButtonRoundAndTrasparent:buttonSignup];

    UIImage *image = [UIImage imageNamed:@"path"];
    [imageViewBackground setImage:[Utils makeRoundCornerImage:image withCornerWidth:20 andWithCornerHeight:20]];
}

- (IBAction)exitFromModalView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
