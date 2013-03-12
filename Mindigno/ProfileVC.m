//
//  ProfileVC.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "ProfileVC.h"
#import "UIImageView+WebCache.h"

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
