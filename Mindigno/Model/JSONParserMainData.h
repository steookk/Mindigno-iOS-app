//
//  JsonParserMicroPost.h
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MicroPost.h"
#import "SignupResponse.h"

#define URL_JSON_MICROPOST_TEST @"http://staging.mindigno.com"
//#define URL_JSON_MICROPOST_TEST @"http://151.42.152.165"

#define USER_NAME_TEST @"andrea@prova.it"
#define USER_PASSWORD_TEST @"ciaociao"

@interface JSONParserMainData : NSObject

+ (NSMutableArray*) startDownloadFeedAtUrl:(NSString *)urlString thereIsUserField:(BOOL)yesOrNot;

//Effettua il login e ritorna SI o NO in base al fatto se è effettivamente loggato o no.
+ (BOOL) startLoginWithUser:(NSString*)user andPassword:(NSString*)password;
//Effettua il logout e ritorna SI se è andato a buon fine. NO altrimenti.
+ (BOOL) startLogout;

//Ritorna SignupResponse con le rispettive proprietà
+ (SignupResponse*) startSignupWithName:(NSString*)name mail:(NSString*)mail password:(NSString*)password passwordConfirmation:(NSString*)passwordConfirmation;

+ (BOOL) startFacebookLoginWithAccessToken:(NSString*)accessToken;
+ (SignupResponse*) startFacebookSignupWithAccessToken:(NSString*)accessToken;

+ (BOOL) startCheckIfExistInMindignoFacebookUserWithID:(NSString*)userID;

+ (BOOL) startIndignatiSulMicroPostConID:(NSString*)micropostID;
+ (BOOL) startRimuoviIndignazioneSulMicroPostConID:(NSString*)micropostID;

+ (void) startDownloadAllIndignatiForMicropost:(MicroPost*)micropost;

+ (BOOL) startFollowUserWithID:(NSString*)userID;
+ (BOOL) startRemoveFollowedUserWithID:(NSString*)userID;

+ (NSArray*) startDownloadUsersWithUrl:(NSString*)urlString;

+ (MicroPost*) startCreateNewMicropostWithTitle:(NSString*)title andDescription:(NSString*)description;

+ (BOOL) startCreateNewCommentWithContent:(NSString*)content forMicropost:(MicroPost*)micropost;

+ (NSArray*) startDownloadNewCommentsAtUrl:(NSString*)urlString;

@end
