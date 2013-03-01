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

#define USER_NAME_TEST @"andrea@prova.it"
#define USER_PASSWORD_TEST @"ciaociao"

@interface JSONParserMainData : NSObject {

}

//Return TRUE if it worked out (there is connection). Not require authentication
- (BOOL) startDownloadAndParsingJsonAtUrl:(NSString *)urlString;

//Controlla e aggiorna lo stato di login dell'utente
- (void) startLoginWithUser:(NSString*)user andPassword:(NSString*)password;
- (void) startLogout;

//Ritorna SignupResponse con le rispettive proprietà
- (SignupResponse*) startSignupWithName:(NSString*)name mail:(NSString*)mail password:(NSString*)password passwordConfirmation:(NSString*)passwordConfirmation;

@end
