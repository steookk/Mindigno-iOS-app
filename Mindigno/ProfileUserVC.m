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

@synthesize currentUser, arrayMicroPost, buttonSettings;

- (void) refreshView {
	
    [labelName setText: [currentUser name]];
    
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewAvatar setImageWithURL:[NSURL URLWithString:[currentUser avatarUrl]] placeholderImage:placeHolder];
    
    //
    
    [labelFollowersText setText: [currentUser followersText]];
    [labelFollowingText setText: [currentUser followingText]];
    [labelNumberFollowers setText: [currentUser numberOfFollowers]];
    [labelNumberFollowing setText: [currentUser numberOfFollowing]];
}

@end
