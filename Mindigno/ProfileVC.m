//
//  ProfileVC.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "ProfileVC.h"
#import "UIImageView+WebCache.h"
#import "Mindigno.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

@synthesize currentUser, arrayMicroPost;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder: aDecoder];
    if (self) {
    
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (currentUser == [[Mindigno sharedMindigno] currentUser]) {
        [buttonSegue setHidden: YES];
    } else {
        [buttonSegue setHidden: NO];
    }
    
    [buttonSegue setSelected: [currentUser isFollowedFromLoggedUser]];
    [buttonSegue addTarget:self action:@selector(buttonSegueClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) buttonSegueClicked:(id)sender {
    //NSLog(@"buttonSegueClicked");
    
    if (![[Mindigno sharedMindigno] isLoggedUser]) {
        UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
        [self presentViewController:navController animated:YES completion:nil];
        
    } else {
        
        BOOL isSeguito = [buttonSegue isSelected];
        if (!isSeguito) {
            BOOL ok = [[Mindigno sharedMindigno] followUserWithID: [currentUser userID]];
            
            if (ok) {
                [currentUser setIsFollowedFromLoggedUser: YES];
                [buttonSegue setSelected: YES];
                [[[Mindigno sharedMindigno] currentUser] addOneToNumberOfFollowing];
            }
            
        } else {
            BOOL ok = [[Mindigno sharedMindigno] removeFollowedUserWithID: [currentUser userID]];
            
            if (ok) {
                [currentUser setIsFollowedFromLoggedUser: NO];
                [buttonSegue setSelected: NO];
                [[[Mindigno sharedMindigno] currentUser] removeOneToNumberOfFollowing];
            }
        }
        
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"profileToProfileUser"]) {
        profileUserVC = [segue destinationViewController];
        
        [profileUserVC setCurrentUser: currentUser];
        [profileUserVC setArrayMicroPost: arrayMicroPost];
    } 
}

- (IBAction)goBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
