//
//  MicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MicroPost.h"
#import "RoundUtils.h"

@implementation MicroPost

@synthesize micropostID, title, description, imageUrl, createdAtText, indignatiText, sourceText, isLink;

- (id) init {
    self = [super init];
    if (self) {
        
        //Default
        isLink = NO;
        
        comments = [NSMutableArray array];
        
        //For test: Get random image url
        imageUrl = [RoundUtils getRandomImgUrl];
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

- (void) addComments:(NSArray *)_comments {
    [comments addObjectsFromArray:_comments];
}

- (void) removeAllComments {
    [comments removeAllObjects];
}

- (int) getNumberOfComments {
    return (int)[comments count];
}

- (NSString*) getCommentAtIndex:(int)index {
    return [comments objectAtIndex:index];
}

@end
