//
//  User.h
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {

    NSString *userID;
    NSString *userUrl;
    NSString *name;
    NSString *avatarUrl;
}

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatarUrl;

- (id)initWithJsonRoot:(NSDictionary*)root_user;

@end
