//
//  MicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MicroPost.h"

@implementation MicroPost

@synthesize title, description, createdAtText, indignatiText, sourceText, isLink;

- (id) init {
    self = [super init];
    if (self) {
        
        //Default
        isLink = NO;
        
        comments = [NSMutableArray array];
    }
    
    return self;
}

///

- (NSArray*) getAllComments {
    return comments;
}

- (void) addComment:(NSString *)comment {
    [comments addObject:comment];
}

- (void) removeAllComments {
    [comments removeAllObjects];
}

- (int) getNumberOfComments {
    return (int)[comments count];
}

@end
