//
//  SignupResponse.h
//  Mindigno
//
//  Created by Enrico on 01/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignupResponse : NSObject {

    BOOL isUserCreated;
    NSString* messageError;
}

@property (nonatomic) BOOL isUserCreated;
@property (nonatomic, copy) NSString* messageError;

- (id)init;
- (id)initWithJsonRoot:(NSDictionary*)root_signupResponse;

- (void) setValuesWithJsonRoot:(NSDictionary*)root_signupResponse;

@end
