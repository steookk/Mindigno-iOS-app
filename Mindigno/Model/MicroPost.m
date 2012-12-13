//
//  MicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MicroPost.h"
#import "RoundUtils.h"
#import "JsonKeys.h"
#import "Comment.h"
#import "Mindigno.h"

@interface MicroPost ()

- (void) setup;

@end

@implementation MicroPost

@synthesize micropostID, micropostUrl, title, description, isLink, imageUrl, sourceText, link, isUserCreator, preposition, userID, defaultText, createdAtText, indignatiText, defaultCommentsText;

- (id) init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithJsonRoot:(NSDictionary*)root_microPost {

    self = [super init];
    if (self) {
        
        //[self setup];
        
        [self setMicropostID: [root_microPost objectForKey: MICROPOST_ID_KEY]];
        
        [self setMicropostUrl: [root_microPost objectForKey: MICROPOST_PATH_KEY]];
        
        [self setTitle: [root_microPost objectForKey: MICROPOST_TITLE]];
        //[self setDescription: [root_microPost objectForKey: MICROPOST_DESCRIPTION_KEY]];
        
        [self setIsLink: [[root_microPost objectForKey: MICROPOST_IS_LINK_KEY] boolValue]];
        
        NSString *imgUrl = [root_microPost objectForKey: MICROPOST_IMAGE_PATH_KEY];
        if ([imgUrl isKindOfClass:[NSNull class]]) imgUrl = nil;
        [self setImageUrl: imgUrl];
        
        [self setSourceText: [root_microPost objectForKey: MICROPOST_SOURCE_TEXT_KEY]];
        [self setLink: [root_microPost objectForKey: MICROPOST_LINK_PATH_KEY]];
        
        [self setIsUserCreator: [[root_microPost objectForKey: MICROPOST_IS_USER_CREATOR_KEY] boolValue]];
        [self setPreposition: [root_microPost objectForKey: MICROPOST_PREPOSITION_KEY]];
        [self setUserID: [root_microPost objectForKey: MICROPOST_USER_ID_KEY]];
        [self setDefaultText: [root_microPost objectForKey: MICROPOST_DEFAULT_TEXT_KEY]];
        
        [self setCreatedAtText: [root_microPost objectForKey: MICROPOST_CREATED_AT_TEXT_KEY]];
        
        [self setIndignatiText: [root_microPost objectForKey: MICROPOST_INDIGNATI_TEXT_KEY]];
        
        followingIndignati = [NSMutableArray array];
        
        NSArray *array_indignati = [root_microPost objectForKey: MICROPOST_FOLLOWING_INDIGNATI_KEY];
        
        for (NSString *user_id in array_indignati) {
            User *user = [[Mindigno sharedMindigno] userWithId: user_id];
            [followingIndignati addObject:user];
        }
        
        [self setDefaultCommentsText: [root_microPost objectForKey: MICROPOST_COMMENTS_TEXT_KEY]];
        
        defaultComments = [NSMutableArray array];
        
        NSArray *array_comments = [root_microPost objectForKey: MICROPOST_COMMENTS_KEY];
        
        for (NSDictionary *comments_dictionary in array_comments) {
            Comment *comment = [[Comment alloc] initWithJsonRoot: comments_dictionary];
            [defaultComments addObject:comment];
        }
        
    }
    
    return self;
}

- (void) setup {
    
}

///

- (NSArray*) getAllComments {
    return defaultComments;
}

- (void) addComment:(NSString *)comment {
    [defaultComments addObject:comment];
}

- (void) addComments:(NSArray *)_comments {
    [defaultComments addObjectsFromArray:_comments];
}

- (void) removeAllComments {
    [defaultComments removeAllObjects];
}

- (int) getNumberOfComments {
    return (int)[defaultComments count];
}

- (NSString*) getCommentAtIndex:(int)index {
    return [defaultComments objectAtIndex:index];
}

@end
