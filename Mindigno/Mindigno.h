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
}

@property (nonatomic, retain) User *currentUser;
@property (nonatomic, readonly) NSMutableDictionary *idToUser_dictionary;
@property (nonatomic, copy) NSString *baseURL;

+ (id)sharedMindigno;

- (void) addMicroPostsFromJsonRoot:(NSArray*)microposts;
- (NSArray *) microPosts;

- (void) addUsersFromJsonRoot:(NSArray*)users;
- (User*) userWithId:(NSString*)userId;

- (void) shareInfo:(UIViewController*)controller;

- (NSString*) getStringUrlFromStringPath:(NSString*)path;

@end
