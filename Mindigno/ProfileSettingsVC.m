//
//  ProfileSettingsVC.m
//  Mindigno
//
//  Created by Enrico on 08/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "ProfileSettingsVC.h"

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

- (IBAction)goBack:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
