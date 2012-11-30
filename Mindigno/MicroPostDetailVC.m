//
//  MicroPostDetailVCViewController.m
//  Mindigno
//
//  Created by Enrico on 30/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MicroPostDetailVC.h"

@interface MicroPostDetailVC ()

@end

@implementation MicroPostDetailVC

@synthesize currentMicropost;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [imageViewAvatar setImage: [UIImage imageNamed:@"Kenny"]];
    
    [labelTitle setText:[currentMicropost title]];
    [textViewDescription setText:[currentMicropost description]];
    [labelIndignatiText setText:[currentMicropost indignatiText]];
}

- (IBAction)goBack:(id)sender {

    [[self navigationController] popViewControllerAnimated:YES];
}

@end
