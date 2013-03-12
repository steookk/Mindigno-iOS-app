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
    
    //Solo nell'utente per cui si fa richiesta
    NSString *followersText;
    NSString *followingText;
    NSString *numberOfFollowers;
    NSString *numberOfFollowing;
    //
}

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatarUrl;

//
@property (nonatomic, copy) NSString *followersText;
@property (nonatomic, copy) NSString *followingText;
@property (nonatomic, copy) NSString *numberOfFollowers;
@property (nonatomic, copy) NSString *numberOfFollowing;
//

- (id)initWithJsonRoot:(NSDictionary*)root_user;

@end
