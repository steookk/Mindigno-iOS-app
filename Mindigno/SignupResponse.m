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

@synthesize isUserCreatedAndLogged, messageError;

- (id)init {
    
    self = [super init];
    if (self) {
        
        [self setIsUserCreatedAndLogged: NO];
        [self setMessageError: @"Non è stato possibile effettuare la registrazione. Riprova più tardi"];
    }
    
    return self;
}

@end
