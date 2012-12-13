//
//  Mindigno.h
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Mindigno : NSObject {

    NSMutableDictionary *idToUser_dictionary;
}

@property (nonatomic, readonly) NSMutableDictionary *idToUser_dictionary;

+ (id)sharedMindigno;

- (void) addUsersFromJsonRoot:(NSArray*)users;
- (User*) userWithId:(NSString*)userId;

@end
