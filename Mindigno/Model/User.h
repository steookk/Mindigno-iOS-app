//
//  User.h
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MicroPost;

@interface User : NSObject {

    NSString *userID;
    NSString *userUrl;
    NSString *name;
    NSString *avatarUrl;
    
    BOOL isFollowedFromLoggedUser;
    
    //Solo nell'utente per cui si fa richiesta
    NSString *followersText;
    NSString *followingText;
    NSString *numberOfFollowers;
    NSString *numberOfFollowing;
    //
    
    NSMutableArray *microposts;
}

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic) BOOL isFollowedFromLoggedUser;

//
@property (nonatomic, copy) NSString *followersText;
@property (nonatomic, copy) NSString *followingText;
@property (nonatomic, copy) NSString *numberOfFollowers;
@property (nonatomic, copy) NSString *numberOfFollowing;
//

- (id)initWithJsonRoot:(NSDictionary*)root_user;
- (void)addMoreUserInfoWithJsonRoot:(NSDictionary*)root_user;

- (NSArray*) microposts;
//Cancella tutti quelli precedenti e imposta i nuovi.
- (void) setMicroposts:(NSArray*)new_microposts;
//Aggiunge i nuovi ai vecchi
- (void) addMicroposts:(NSArray*)new_microposts;

//Aggiunge un micropost ai vecchi;
- (void) addMicropost:(MicroPost*)new_micropost;

- (void) removeAllMicroposts;

@end
