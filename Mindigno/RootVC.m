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

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [mainButtonBar setDelegate:self];
}

//Start MainButtonBarDelegate
- (void) clickedButtonHome {
    NSLog(@"clickedButtonHome");
    
    [containerViewProfileUser setHidden: YES];
}

- (void) clickedButtonProfile {
    NSLog(@"clickedButtonProfile");
    
    //Se l'utente non è loggato
    if (![[Mindigno sharedMindigno] isLoggedUser]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
        
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateInitialViewController];
        LoginSignupVC *loginSignupVC = (LoginSignupVC *)[navController topViewController];
        [loginSignupVC setDelegate: self];
        
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

@end
