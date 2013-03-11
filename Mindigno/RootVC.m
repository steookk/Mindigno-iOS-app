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

    UINavigationController *navController = (UINavigationController *) [self apriModaleLogin];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [mainButtonBar setDelegate:self];
    
    [loginButton addTarget:self action:@selector(loginButtonSelector) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutNotification) name:@"logoutNotification" object:nil];
    
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

- (UIViewController *) apriModaleLogin {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateInitialViewController];
    LoginSignupVC *loginSignupVC = (LoginSignupVC *)[navController topViewController];
    [loginSignupVC setDelegate: self];
    
    return navController;
}

- (void) clickedButtonProfile {
    NSLog(@"clickedButtonProfile");
    
    //Se l'utente non è loggato
    if (![[Mindigno sharedMindigno] isLoggedUser]) {
        
        UINavigationController *navController = (UINavigationController *) [self apriModaleLogin];
        
        [self presentViewController:navController animated:YES completion:^{
            
            //Visualizzo comunque la view. Eventualmente se annulla, viene nascosta;
            [containerViewProfileUser setHidden: NO];
        }];
    
    } else {
        NSLog(@"Utente già loggato");
        
        //Setting di eventuali valori al profileVC
        //TODO
        
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

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
