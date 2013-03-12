//
//  User.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "User.h"
#import "JsonKeys.h"
#import "Mindigno.h"

@implementation User

@synthesize userID, userUrl, name, avatarUrl;
@synthesize followersText, followingText, numberOfFollowers, numberOfFollowing;

- (id)initWithJsonRoot:(NSDictionary*)root_user {

    self = [super init];
    if (self) {
        
        [self setUserID: [root_user objectForKey: USER_ID_KEY]];
        
        NSString *completeUserUrl = [[Mindigno sharedMindigno] getStringUrlFromStringPath: [root_user objectForKey: USER_PATH_KEY]];
        [self setUserUrl: completeUserUrl];
        [self setName: [root_user objectForKey: USER_NAME_KEY]];
        [self setAvatarUrl: [root_user objectForKey: USER_AVATAR_URL_KEY]];
        
        //
        [self setFollowersText: [root_user objectForKey: USER_FOLLOWERS_TEXT]];
        [self setFollowingText: [root_user objectForKey: USER_FOLLOWING_TEXT]];
        [self setNumberOfFollowers: [[root_user objectForKey: USER_NUMBER_FOLLOWERS] stringValue]];
        [self setNumberOfFollowing: [[root_user objectForKey: USER_NUMBER_FOLLOWING] stringValue]];
    }
    
    return self;
}

@end
