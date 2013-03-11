//
//  MicroPostEditorVC.m
//  Mindigno
//
//  Created by Enrico on 08/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "MicroPostEditorVC.h"

@interface MicroPostEditorVC ()

@end

@implementation MicroPostEditorVC

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
    
    //[[self navigationController] popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
