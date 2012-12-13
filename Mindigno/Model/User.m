//
//  User.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "User.h"
#import "JsonKeys.h"

@implementation User

@synthesize userID, userUrl, name, urlAvatar;

- (id)initWithJsonRoot:(NSDictionary*)root_user {

    self = [super init];
    if (self) {
        
        [self setUserID: [root_user objectForKey: USER_ID_KEY]];
        [self setUserUrl: [root_user objectForKey: USER_PATH_KEY]];
        [self setName: [root_user objectForKey: USER_NAME_KEY]];
        [self setUrlAvatar: [root_user objectForKey: USER_URL_AVATAR_KEY]];
        
    }
    return self;
}

@end
