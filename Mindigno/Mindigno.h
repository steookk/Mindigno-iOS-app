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
    NSMutableDictionary *idToUser_dictionary;
    
    NSString *baseURL;
    
    BOOL isLoggedUser;
}

@property (nonatomic, readonly) BOOL isLoggedUser;
@property (nonatomic) User *currentUser;
@property (nonatomic, readonly) NSMutableDictionary *idToUser_dictionary;
@property (nonatomic, copy) NSString *baseURL;

+ (id)sharedMindigno;

- (NSArray *) microPosts;
- (NSArray *) microPostsOfUser:(User*)user;

- (void) addUsersFromJsonRoot:(NSArray*)users;
- (User*) userWithId:(NSString*)userId;

- (void) shareInfo:(UIViewController*)controller;

- (NSString*) getStringUrlFromStringPath:(NSString*)path;

- (BOOL) checkAndUpdateIfUserIsLogged;

@end
