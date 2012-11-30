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
    NSString *name;
    //NSString *password;
    
    NSString *urlAvatar;
    
    //NSString *numberOfFollowing;
    //NSString *numberOfFollower;
}

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *urlAvatar;

@end
