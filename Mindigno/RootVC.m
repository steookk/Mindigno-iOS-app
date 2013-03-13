//
//  ViewController.m
//  Mindigno
//
//  Created by Enrico on 28/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "RootVC.h"
#import "Utils.h"
#import "Mindigno.h"
#import "NotificationKeys.h"

@interface RootVC ()

@end

@implementation RootVC

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
    }
    
    return self;
}

- (void) loginButtonSelector {

    UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [mainButtonBar setDelegate:self];
    
    [loginButton addTarget:self action:@selector(loginButtonSelector) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutNotification) name:LOGOUT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginNotification) name:LOGIN_NOTIFICATION object:nil];
    
    [self setCustomButtonToTheRightOfBar];
}

- (void) setCustomButtonToTheRightOfBar {

    if ([[Mindigno sharedMindigno] isLoggedUser]) {
        
        if ([mainButtonBar currentSelectedButton] == [mainButtonBar buttonHome]) {
            [mainButtonBar setCustomVariableButton: [homeVC buttonPlus]];
            
        } else if ([mainButtonBar currentSelectedButton] == [mainButtonBar buttonProfile]) {
            [mainButtonBar setCustomVariableButton: [profileUserVC buttonSettings]];
        }
        
    } else {
        [mainButtonBar setCustomVariableButton: loginButton];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self setCustomButtonToTheRightOfBar];
}

//Start MainButtonBarDelegate
- (void) clickedButtonHome {
    NSLog(@"clickedButtonHome");
    
    [self setCustomButtonToTheRightOfBar];

    [containerViewProfileUser setHidden: YES];
}

- (void) caricaInformazioniProfilo {

    //Setting di eventuali valori al profileVC
    User *currentUser = [[Mindigno sharedMindigno] currentUser];
    NSArray *micropostOfUser = [[Mindigno sharedMindigno] microPostsOfUser: currentUser];
    
    [profileUserVC setCurrentUser:currentUser];
    [profileUserVC setArrayMicroPost: micropostOfUser];
    [profileUserVC refreshView];
}

- (void) clickedButtonProfile {
    NSLog(@"clickedButtonProfile");
    
    //Se l'utente non è loggato
    if (![[Mindigno sharedMindigno] isLoggedUser]) {
        
        UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
        
        [self presentViewController:navController animated:YES completion:^{
            
            //Visualizzo comunque la view. Eventualmente se annulla, viene nascosta;
            [containerViewProfileUser setHidden: NO];
        }];
    
    } else {
        NSLog(@"Utente già loggato");
        
        [self caricaInformazioniProfilo];
        
        //Visualizzo la view
        [containerViewProfileUser setHidden: NO];
        [self setCustomButtonToTheRightOfBar];
    }
}

//Start SignupVCDelegate
- (void) loginSignupDiscarded {
    
    [containerViewProfileUser setHidden: YES];
    [mainButtonBar selectButton: [mainButtonBar buttonHome]];
}
//Stop SignupVCDelegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"rootToHomeVC"]) {
        homeVC = [segue destinationViewController];
    
    } else if ([[segue identifier] isEqualToString:@"rootToProfileVC"]) {
        profileUserVC = [segue destinationViewController];
    }
}

- (void) clickedButtonSearch {
    NSLog(@"clickedButtonSearch");
}
//Stop MainButtonBarDelegate

- (void) handleLogoutNotification {
    
    //Forzo a cliccare il pulsante home
    [mainButtonBar clickButton: [mainButtonBar buttonHome]];
}

- (void) handleLoginNotification {
    
    [self caricaInformazioniProfilo];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
