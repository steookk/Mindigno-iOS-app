//
//  ProfileSettingsVC.m
//  Mindigno
//
//  Created by Enrico on 08/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "ProfileSettingsVC.h"
#import "Mindigno.h"
#import "JSONParserMainData.h"
#import "NotificationKeys.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileSettingsVC ()

@end

@implementation ProfileSettingsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    if ([[Mindigno sharedMindigno] isLoggedUser]) {
        [buttonLogout setHidden: NO];
    } else {
        [buttonLogout setHidden: YES];
    }
}

- (void) exitWithAnimation:(BOOL)animation {

    [[self navigationController] popViewControllerAnimated: animation];
}

- (IBAction)logout:(id)sender {
    
    if ([[Mindigno sharedMindigno] isLoggedUser]) {
        
        BOOL logoutOK = [[Mindigno sharedMindigno] logout];
        
        if (logoutOK) {
            //Serve per pulire le info di facebook e quindi far apparire loging invece di logout dalla schermata di login. Questo perchè il login/logout da facebook è separato da quello di mindigno
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [buttonLogout setHidden: YES];
            
            [self exitWithAnimation: NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT_NOTIFICATION object:nil];
        
        } else {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Non è stato possibile effettuare il logout. Riprova più tardi" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (IBAction)goBack:(id)sender {
    [self exitWithAnimation: YES];
}

@end
