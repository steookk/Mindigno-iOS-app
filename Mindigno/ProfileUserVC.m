//
//  ProfileUserVC.m
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "ProfileUserVC.h"
#import "UIImageView+WebCache.h"

@interface ProfileUserVC ()

@end

@implementation ProfileUserVC

@synthesize currentUser, buttonSettings;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [labelName setText: [currentUser name]];
    
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewAvatar setImageWithURL:[NSURL URLWithString:[currentUser avatarUrl]] placeholderImage:placeHolder];
}

@end
