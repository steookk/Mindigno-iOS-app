//
//  SignupResponse.m
//  Mindigno
//
//  Created by Enrico on 01/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "SignupResponse.h"
#import "JsonKeys.h"

@implementation SignupResponse

@synthesize isUserCreated, messageError;

- (id)init {
    
    self = [super init];
    if (self) {
        
        [self setIsUserCreated: NO];
        [self setMessageError: @"Non è stato possibile effettuare la registrazione. Riprova più tardi"];
    }
    
    return self;
}

- (void) setValuesWithJsonRoot:(NSDictionary*)root_signupResponse {
    
    [self setIsUserCreated: [[root_signupResponse objectForKey: SIGNUP_USER_CREATED] boolValue]];
    //[self setMessageError: [root_signupResponse objectForKey: SIGNUP_MESSAGE_KEY]];
}

- (id)initWithJsonRoot:(NSDictionary*)root_signupResponse {
    
    self = [super init];
    if (self) {
        [self setValuesWithJsonRoot: root_signupResponse];
    }
    
    return self;
}



@end
