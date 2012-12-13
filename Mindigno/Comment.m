//
//  Comment.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "Comment.h"
#import "JsonKeys.h"
#import "Mindigno.h"

@implementation Comment

@synthesize commentID, content, userCreator;

- (id)initWithJsonRoot:(NSDictionary*)root_comment {

    self = [super init];
    if (self) {
        
        [self setCommentID: [root_comment objectForKey: COMMENT_ID_KEY]];
        [self setContent: [root_comment objectForKey: COMMENT_CONTENT_KEY]];
       
        NSString *user_id = [root_comment objectForKey: COMMENT_USER_ID_KEY];
        userCreator = [[Mindigno sharedMindigno] userWithId:user_id];
    }
    
    return self;
}
@end
