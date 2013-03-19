//
//  Mindigno.h
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "JSONParserMainData.h"

@interface Mindigno : NSObject {

    User *currentUser;
    
    NSMutableArray *microPostsOfHome;
    NSMutableArray *microPostsOfFollowing;
    
    NSMutableDictionary *idToUser_dictionary;
    
    NSString *baseURL;
    
    BOOL isLoggedUser;
}

@property (nonatomic, readonly) BOOL isLoggedUser;
@property (nonatomic) User *currentUser;

@property (nonatomic, readonly) NSArray *microPostsOfHome;
@property (nonatomic, readonly) NSArray *microPostsOfFollowing;

@property (nonatomic, readonly) NSMutableDictionary *idToUser_dictionary;
@property (nonatomic, copy) NSString *baseURL;

+ (id)sharedMindigno;

- (void) addMicroPostToMicroPostsOfHome:(MicroPost*)micropost;
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

- (void) downloadAllIndignatiForMicropost:(MicroPost*)micropost;

- (BOOL) loginWithUser:(NSString*)user andPassword:(NSString*)password;
- (SignupResponse*) signupWithName:(NSString*)name mail:(NSString*)mail password:(NSString*)password passwordConfirmation:(NSString*)passwordConfirmation;
- (BOOL) logout;

- (BOOL) indignatiSulMicroPostConID:(NSString*)micropostID;
- (BOOL) rimuoviIndignazioneSulMicroPostConID:(NSString*)micropostID;

- (BOOL) followUserWithID:(NSString*)userID;
- (BOOL) removeFollowedUserWithID:(NSString*)userID;

- (NSArray*) downloadFollowingUsers;
- (NSArray*) downloadFollowersUsers;

//Crea il micropost o ritorna nil se l'operazione non va a buon fine.
- (MicroPost*) createNewMicropostWithTitle:(NSString*)title andDescription:(NSString*)description;

- (BOOL) createNewCommentWithContent:(NSString*)content forMicropost:(MicroPost*)micropost;

- (void) addUsersFromJsonRoot:(NSArray*)users;
- (User*) userWithId:(NSString*)userId;

- (void) shareInfoOnViewController:(UIViewController*)controller;
- (void) shareInfoOnViewController:(UIViewController*)controller withText:(NSString*)text imageName:(NSString*)image url:(NSString*)url;

- (NSString*) getStringUrlFromStringPath:(NSString*)path;

- (BOOL) checkAndUpdateIfUserIsLogged;

- (UIViewController *) apriModaleLogin;

@end
