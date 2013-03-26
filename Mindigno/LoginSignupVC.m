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
#import "Mindigno.h"

@interface LoginSignupVC ()

@end

@implementation LoginSignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///Login
    [textFieldUsername setDelegate:self];
    [textFieldPassword setDelegate:self];
    
    /*
    [textFieldUsername setTextColor: [UIColor whiteColor]];
    [textFieldPassword setTextColor: [UIColor whiteColor]];
    
    [Utils setTextFieldRoundAndTrasparent: textFieldUsername];
    [Utils setTextFieldRoundAndTrasparent: textFieldPassword];
     */
    ///
    
    //
    fbLoginView.delegate = self;
    fbLoginView.readPermissions = @[@"email"];
    fbLoginView.publishPermissions = @[@"publish_actions"];
    fbLoginView.defaultAudience = FBSessionDefaultAudienceOnlyMe;
}

- (void) lanciaMessaggioErroreEPulisciFacebookInfo {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attenzione!" message:@"Non è stato possibile effettuare l'operazione. Riprova più tardi." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
    //Necessario altrimenti ogni volta che si entra nella schermata di login tenta di fare in login con facebook
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
    NSString *userID = user.id;
    NSString *accessToken = [[FBSession.activeSession accessTokenData] accessToken];
    
    //NSLog(@"userID: %@", userID);
    //NSLog(@"access token: %@", accessToken);
    
    BOOL existUser = [[Mindigno sharedMindigno] checkIfExistInMindignoFacebookUserWithID: userID];
    if (existUser) {
        BOOL loginOK = [[Mindigno sharedMindigno] facebookLoginWithAccessToken: accessToken];
        if (loginOK) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self lanciaMessaggioErroreEPulisciFacebookInfo];
        }
        
    } else {
        //Bisogna registrare con facebook solo se accetta le condizioni
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Termini di utilizzo" message:@"Accetti i Termini di utilizzo?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
        [alert show];
    }
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

- (IBAction)login:(id)sender {
    
    NSString *user = [textFieldUsername text];
    NSString *password = [textFieldPassword text];
    
    BOOL loginOK = [[Mindigno sharedMindigno] loginWithUser:user andPassword:password];
    
    if (loginOK && [[Mindigno sharedMindigno] isLoggedUser]) {
        //Esce dalla modal view dopo aver lanciato l'evento
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Non è stato possibile effettuare il login. Riprova più tardi" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *accessToken = [[FBSession.activeSession accessTokenData] accessToken];
    
    if (buttonIndex == 1) {
        //Se viene cliccato il pulsante Si sui Termini e condizioni allora procedo con la registrazione altrimenti non si fa nulla.
        
        SignupResponse *signupResponse = [[Mindigno sharedMindigno] facebookSignupWithAccessToken: accessToken];
        if (signupResponse.isUserCreatedAndLogged) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [self lanciaMessaggioErroreEPulisciFacebookInfo];
        }
    
    } else {
        //Necessario altrimenti ogni volta che si entra nella schermata di login tenta di fare in login con facebook
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (IBAction)exitFromModalView:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DISCARD_LOGIN_SIGNUP_NOTIFICATION object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
