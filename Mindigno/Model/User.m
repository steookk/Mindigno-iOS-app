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

@synthesize userID, userUrl, name, avatarUrl, isFollowedFromLoggedUser;
@synthesize followersText, followingText, numberOfFollowers, numberOfFollowing;

- (void) addMoreUserInfoWithJsonRoot:(NSDictionary*)root_user {
    
    //
    [self setFollowersText: [root_user objectForKey: USER_FOLLOWERS_TEXT_KEY]];
    [self setFollowingText: [root_user objectForKey: USER_FOLLOWING_TEXT_KEY]];
    [self setNumberOfFollowers: [[root_user objectForKey: USER_NUMBER_FOLLOWERS_KEY] stringValue]];
    [self setNumberOfFollowing: [[root_user objectForKey: USER_NUMBER_FOLLOWING_KEY] stringValue]];
}

- (id)initWithJsonRoot:(NSDictionary*)root_user {

    self = [super init];
    if (self) {
        
        microposts = [NSMutableArray array];
        
        //
        [self setUserID: [root_user objectForKey: USER_ID_KEY]];
        
        NSString *completeUserUrl = [[Mindigno sharedMindigno] getStringUrlFromStringPath: [root_user objectForKey: USER_PATH_KEY]];
        [self setUserUrl: completeUserUrl];
        [self setName: [root_user objectForKey: USER_NAME_KEY]];
        [self setAvatarUrl: [root_user objectForKey: USER_AVATAR_URL_KEY]];
        
        [self setIsFollowedFromLoggedUser: [[root_user objectForKey: USER_IS_FOLLOWED_FROM_LOGGED_USER] boolValue]];
    
        //
        [self addMoreUserInfoWithJsonRoot: root_user];
    }
    
    return self;
}

//

- (NSArray*) microposts {

    return microposts;
}

- (void) setMicroposts:(NSArray*)new_microposts {

    [microposts removeAllObjects];
    [microposts setArray: new_microposts];
}

- (void) addMicroposts:(NSArray*)new_microposts {
    
    [microposts addObjectsFromArray: new_microposts];
}

- (void) addMicropost:(MicroPost*)new_micropost {
    
    [microposts addObject: new_micropost];
}

- (void) removeAllMicroposts {
    [microposts removeAllObjects];
}

@end
