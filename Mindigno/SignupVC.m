//
//  LoginSelectorVC.m
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "SignupVC.h"
#import "Utils.h"
#import "JSONParserMainData.h"

@interface SignupVC ()

@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [textFieldNome setDelegate:self];
    [textFieldMail setDelegate:self];
    [textFieldPassword setDelegate:self];
    [textFieldRetipedPassword setDelegate:self];
    
    [textFieldNome setTextColor: [UIColor whiteColor]];
    [textFieldMail setTextColor: [UIColor whiteColor]];
    [textFieldPassword setTextColor: [UIColor whiteColor]];
    [textFieldRetipedPassword setTextColor: [UIColor whiteColor]];
    
    [Utils setTextFieldRoundAndTrasparent: textFieldNome];
    [Utils setTextFieldRoundAndTrasparent: textFieldMail];
    [Utils setTextFieldRoundAndTrasparent: textFieldPassword];
    [Utils setTextFieldRoundAndTrasparent: textFieldRetipedPassword];
}

//Start UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == textFieldNome) {
        [textFieldMail becomeFirstResponder];
        
    } else if (textField == textFieldMail) {
        [textFieldPassword becomeFirstResponder];
        
    } else if (textField == textFieldPassword) {
        [textFieldRetipedPassword becomeFirstResponder];
        
    } else if (textField == textFieldRetipedPassword) {
        [textFieldRetipedPassword resignFirstResponder];
    }
    
    return YES;
}
//Stop UITextFieldDelegate

- (IBAction)signup:(id)sender {

    NSLog(@"%@", @"signup clicked");
    
    if ([[textFieldNome text] isEqualToString:@""] ||
        [[textFieldMail text] isEqualToString:@""] ||
        [[textFieldPassword text] isEqualToString:@""] ||
        [[textFieldRetipedPassword text] isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Compilare tutti i campi" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    
    }
    /*
     
     //Non ha senso farlo? Perchè lo fa il server
    else if (![[textFieldPassword text] isEqualToString:[textFieldRetipedPassword text]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Le password non corrispondono" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    
    }
     */
    
    else {
        //Tutto ok, procedere con la richiesta di registrazione
        
        JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
        
        SignupResponse *signupResponse = [jsonParser startSignupWithName:[textFieldNome text] mail:[textFieldMail text] password:[textFieldPassword text] passwordConfirmation: [textFieldRetipedPassword text]];
        
        if ([signupResponse isUserCreated]) {
            //Esco dalla modale
            [self dismissViewControllerAnimated:YES completion:nil];
        
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:[signupResponse messageError] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (IBAction)switchContrattoHasChangedValue:(id)sender {

    if ([switchAccettaContratto isOn]) {
        [switchAccettaContratto setOn:YES animated:YES];
        [buttonBarRegistrati setEnabled: YES];
    } else {
        [switchAccettaContratto setOn:NO animated:YES];
        [buttonBarRegistrati setEnabled: NO];
    }
}

@end
