//
//  Comment.h
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Comment : NSObject {

    NSString *commentID;
    NSString *content;
    User *userCreator;
    
}

@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) User *userCreator;

- (id)initWithJsonRoot:(NSDictionary*)root_comment;

@end
