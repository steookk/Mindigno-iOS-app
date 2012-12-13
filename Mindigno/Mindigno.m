//
//  Mindigno.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "Mindigno.h"

@implementation Mindigno

@synthesize idToUser_dictionary;

+ (id)sharedMindigno {

    static Mindigno *sharedMindigno = nil;

    @synchronized(self) {
        if (sharedMindigno == nil) {
            sharedMindigno = [[self alloc] init];
        }
    }
    
    return sharedMindigno;
}

- (id) init {

    self = [super init];
    if (self) {
        
        idToUser_dictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) addUsersFromJsonRoot:(NSArray*)users {
    
    for (NSDictionary *user_dictionary in users) {
        
        User *user = [[User alloc] initWithJsonRoot:user_dictionary];
        
        if ([idToUser_dictionary objectForKey: [user userID]] == nil) {
            [idToUser_dictionary setObject:user forKey: [user userID]];
        }
    }
}

- (User*) userWithId:(NSString*)userId {

    User *retUser = [idToUser_dictionary objectForKey: userId];
    
    return retUser;
}

@end
