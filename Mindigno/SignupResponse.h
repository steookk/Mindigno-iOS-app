//
//  SignupResponse.h
//  Mindigno
//
//  Created by Enrico on 01/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignupResponse : NSObject {

    BOOL isUserCreatedAndLogged;
    NSString* messageError;
}

@property (nonatomic) BOOL isUserCreatedAndLogged;
@property (nonatomic, copy) NSString* messageError;

@end
