//
//  Mindigno.h
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Mindigno : NSObject {

    User *currentUser;
    NSMutableArray *microPosts;
    NSMutableArray *microPostsOfFollowing;
    NSMutableArray *microPostsUser;
    NSMutableDictionary *idToUser_dictionary;
    
    NSString *baseURL;
    
    BOOL isLoggedUser;
}

@property (nonatomic, readonly) BOOL isLoggedUser;
@property (nonatomic) User *currentUser;

@property (nonatomic, readonly) NSArray *microPosts;
@property (nonatomic, readonly) NSArray *microPostsOfFollowing;
@property (nonatomic, readonly) NSArray *microPostsUser;

@property (nonatomic, readonly) NSMutableDictionary *idToUser_dictionary;
@property (nonatomic, copy) NSString *baseURL;

+ (id)sharedMindigno;

//Per recuperare i micropost (home)
- (NSArray *) downloadMicroPosts;
//Per recuperare altri 8 micropost (home)
- (NSArray *) downloadMoreOldMicroPosts;

//Per recuperare i micropost di chi segui (home)
- (NSArray *) downloadMicroPostsOfFollowing;
//Per recuperare altri 8 micropost di chi segui (home)
- (NSArray *) downloadMoreOldMicroPostsOfFollowing;

//Per recuperare i micropost di un user
- (NSArray *) downloadMicroPostsOfUser:(User*)user;
//Per recuperare altri 8 micropost dell'user
- (NSArray *) downloadMoreOldMicroPostsOfUser:(User*)user;


- (void) addUsersFromJsonRoot:(NSArray*)users;
- (User*) userWithId:(NSString*)userId;

- (void) shareInfoOnViewController:(UIViewController*)controller;
- (void) shareInfoOnViewController:(UIViewController*)controller withText:(NSString*)text imageName:(NSString*)image url:(NSString*)url;

- (NSString*) getStringUrlFromStringPath:(NSString*)path;

- (BOOL) checkAndUpdateIfUserIsLogged;

- (UIViewController *) apriModaleLogin;

@end
