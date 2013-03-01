//
//  LoginVC.m
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "LoginVC.h"
#import "Utils.h"
#import "JSONParserMainData.h"
#import "Mindigno.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [textFieldUsername setDelegate:self];
    [textFieldPassword setDelegate:self];
    
    [textFieldUsername setTextColor: [UIColor whiteColor]];
    [textFieldPassword setTextColor: [UIColor whiteColor]];
    
    [Utils setTextFieldRoundAndTrasparent: textFieldUsername];
    [Utils setTextFieldRoundAndTrasparent: textFieldPassword];
}

//Start UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == textFieldUsername) {
        [textFieldPassword becomeFirstResponder];
        return NO;
    
    } else if (textField == textFieldPassword) {
        //[textFieldPassword resignFirstResponder];
    }
    
    return YES;
}
//Stop UITextFieldDelegate

- (IBAction)login:(id)sender {
    
    NSString *user = [textFieldUsername text];
    NSString *password = [textFieldPassword text];

    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    [jsonParser startLoginWithUser:user andPassword:password];
    
    if ([[Mindigno sharedMindigno] isLoggedUser]) {
        //Esce dalla modal view
        [self dismissViewControllerAnimated:YES completion:nil];
    
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Non è stato possibile effettuare il login. Riprova più tardi" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

@end
