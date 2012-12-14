//
//  LoginVC.m
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "LoginVC.h"
#import "Utils.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [textFieldUsername setDelegate:self];
    [textFieldPassword setDelegate:self];
    
    [Utils setTextFieldRoundAndTrasparent:textFieldUsername];
    [Utils setTextFieldRoundAndTrasparent:textFieldPassword];

}

//Start UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == textFieldUsername) {
        [textFieldPassword becomeFirstResponder];
        return NO;
    
    } else if (textField == textFieldPassword) {
        [textFieldPassword resignFirstResponder];
    }
    
    return YES;
}
//Stop UITextFieldDelegate

@end
