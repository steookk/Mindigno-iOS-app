//
//  ProfileUserVC.m
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "ProfileUserVC.h"
#import "UIImageView+WebCache.h"
#import "JSONParserMainData.h"
#import "Mindigno.h"

@interface ProfileUserVC ()

@end

@implementation ProfileUserVC

@synthesize delegate, currentUser, buttonSettings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [labelName setText: [currentUser name]];
    
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewAvatar setImageWithURL:[NSURL URLWithString:[currentUser avatarUrl]] placeholderImage:placeHolder];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    if ([[Mindigno sharedMindigno] isLoggedUser]) {
        [buttonLogout setHidden: NO];
    } else {
        [buttonLogout setHidden: YES];
    }
}

- (IBAction)logout:(id)sender {
    
    if ([[Mindigno sharedMindigno] isLoggedUser]) {
        JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
        [jsonParser startLogout];
        
        [buttonLogout setHidden: YES];
        
        if ([delegate respondsToSelector:@selector(clickedButtonLogout)]) {
            [delegate clickedButtonLogout];
        }
    }
}

@end
