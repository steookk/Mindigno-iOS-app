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
    
    //[[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"rilegatura.png"] forBarMetrics:UIBarMetricsDefault];
    
    [Utils setButtonRoundAndTrasparent:buttonLogin];
    [Utils setButtonRoundAndTrasparent:buttonSignup];
    
    
    fbLoginView.delegate = self;
    fbLoginView.readPermissions = @[@"email"];
    fbLoginView.publishPermissions = @[@"publish_actions"];
    fbLoginView.defaultAudience = FBSessionDefaultAudienceOnlyMe;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
    NSString *userID = user.id;
    NSString *accessToken = [[FBSession.activeSession accessTokenData] accessToken];
    
    NSLog(@"userID: %@", userID);
    NSLog(@"access token: %@", accessToken);
    
    BOOL thereIsError = NO;
    
    BOOL existUser = [[Mindigno sharedMindigno] checkIfExistInMindignoFacebookUserWithID: userID];
    if (existUser) {
        BOOL loginOK = [[Mindigno sharedMindigno] facebookLoginWithAccessToken: accessToken];
        if (loginOK) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            thereIsError = YES;
        }
        
    } else {
        SignupResponse *signupResponse = [[Mindigno sharedMindigno] facebookSignupWithAccessToken: accessToken];
        if (signupResponse.isUserCreatedAndLogged) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            thereIsError = YES;
        }
    }
    
    if (thereIsError) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attenzione!" message:@"Non è stato possibile effettuare l'operazione. Riprova più tardi." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
        //Necessario altrimenti ogni volta che si entra nella schermata di login tenta di fare in login con facebook
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (IBAction)exitFromModalView:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DISCARD_LOGIN_SIGNUP_NOTIFICATION object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
