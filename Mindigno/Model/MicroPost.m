//
//  MicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MicroPost.h"
#import "Utils.h"
#import "JsonKeys.h"
#import "Comment.h"
#import "Mindigno.h"

@interface MicroPost ()

@end

@implementation MicroPost

@synthesize micropostID, micropostUrl, title, description, isLink, isIndignato, imageUrl, sourceText, link, isUserCreator, preposition, userCreator, defaultText, createdAtText, indignatiText, defaultCommentsText, followingIndignati, defaultComments, isVignetta, vignetta, numberOfIndignati, numberOfComments, indignatiUrl, commentsTabs_buttons;
@synthesize allComments, userCommentsOnMicropost, allIndignati;

- (id) init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithJsonRoot:(NSDictionary*)root_microPost {

    self = [super init];
    if (self) {
        
        allComments = [NSMutableArray array];
        userCommentsOnMicropost = [NSMutableArray array];
        
        allIndignati = [NSMutableArray array];
        
        ///
        
        [self setMicropostID: [root_microPost objectForKey: MICROPOST_ID_KEY]];
        
        NSString *completeMicropostUrl = [[Mindigno sharedMindigno] getStringUrlFromStringPath: [root_microPost objectForKey: MICROPOST_PATH_KEY]];
        [self setMicropostUrl: completeMicropostUrl];
        
        [self setTitle: [root_microPost objectForKey: MICROPOST_TITLE_KEY]];
        [self setDescription: [root_microPost objectForKey: MICROPOST_DESCRIPTION_KEY]];
        
        [self setIsIndignato: [[root_microPost objectForKey: MICROPOST_IS_INDIGNATO_KEY] boolValue]];
        [self setIsLink: [[root_microPost objectForKey: MICROPOST_IS_LINK_KEY] boolValue]];
        
        NSString *imgUrl = [root_microPost objectForKey: MICROPOST_IMAGE_URL_KEY];
        if ([imgUrl isKindOfClass:[NSNull class]]) imgUrl = nil;
        [self setImageUrl: imgUrl];
        
        [self setSourceText: [root_microPost objectForKey: MICROPOST_SOURCE_TEXT_KEY]];
        [self setLink: [root_microPost objectForKey: MICROPOST_LINK_URL_KEY]];
        
        [self setIsUserCreator: [[root_microPost objectForKey: MICROPOST_IS_USER_CREATOR_KEY] boolValue]];
        [self setPreposition: [root_microPost objectForKey: MICROPOST_PREPOSITION_KEY]];
        
        NSString *userID = [root_microPost objectForKey: MICROPOST_USER_ID_KEY];
        [self setUserCreator: [[Mindigno sharedMindigno] userWithId: userID]];
        
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
        
        for (NSDictionary *comment_dictionary in array_comments) {
            Comment *comment = [[Comment alloc] initWithJsonRoot: comment_dictionary];
            [defaultComments addObject:comment];
        }
        
        [self setIsVignetta: [[root_microPost objectForKey:MICROPOST_IS_VIGNETTA_KEY] boolValue]];
        
        if (isVignetta) {
            NSDictionary *vignetta_dictionary = [root_microPost objectForKey: VIGNETTA_KEY];
            vignetta = [[Vignetta alloc] initWithJsonRoot: vignetta_dictionary];
        } else {
            vignetta = nil;
        }
        
        [self setNumberOfIndignati: [[root_microPost objectForKey:MICROPOST_NUMBER_INDIGNATI_KEY] stringValue]];
        [self setNumberOfComments: [[root_microPost objectForKey:MICROPOST_NUMBER_COMMENTS_KEY] stringValue]];
        
        NSString *completeIndignatiUrl = [[Mindigno sharedMindigno] getStringUrlFromStringPath: [root_microPost objectForKey: MICROPOST_INDIGNATI_PATH_KEY]];
        [self setIndignatiUrl: completeIndignatiUrl];
        
        NSString *commentsTabsString = [root_microPost objectForKey: MICROPOST_COMMENTS_TABS_KEY];
        // (titleButton, url_path)+
        NSArray *components = [commentsTabsString componentsSeparatedByString:@","];
        
        int numberOfValues = [components count];
        commentsTabs_buttons = [NSMutableArray arrayWithCapacity: numberOfValues];
        
        for (int i=0; i<[components count]; i++) {
            NSString *titleButton = [components objectAtIndex:i];
            [commentsTabs_buttons addObject: titleButton];
        }
    }
    
    return self;
}

- (NSString *) addOneToNumberIndignati {

    int currentNumberOfIndignati = [[self numberOfIndignati] intValue];
    currentNumberOfIndignati++;
    
    NSString *newNumberOfIndignati = [NSString stringWithFormat:@"%d", currentNumberOfIndignati];
    [self setNumberOfIndignati: newNumberOfIndignati];
    
    return numberOfIndignati;
}

- (NSString*)removeOneToNumberIndignati {

    int currentNumberOfIndignati = [[self numberOfIndignati] intValue];
    currentNumberOfIndignati--;
    
    NSString *newNumberOfIndignati = [NSString stringWithFormat:@"%d", currentNumberOfIndignati];
    [self setNumberOfIndignati: newNumberOfIndignati];
    
    return numberOfIndignati;
}

- (void) addAllIndignati:(NSArray*)users {

    [allIndignati removeAllObjects];
    
    for (NSDictionary *user_dictionary in users) {
        User *user = [[Mindigno sharedMindigno] userWithId: [user_dictionary objectForKey: USER_ID_KEY]];
        [allIndignati addObject:user];
    }
}

- (void) addCommentAndUpdateValues:(NSDictionary*)root_dictionary {

    Comment *comment = [[Comment alloc] initWithJsonRoot: [root_dictionary objectForKey: COMMENT_KEY]];
    
    /*
     //Aggiunge in testa
    [defaultComments insertObject:comment atIndex:0];
    [allComments insertObject:comment atIndex:0];
    [userCommentsOnMicropost insertObject:comment atIndex:0];
     */
    
    //Aggiunge in coda
    [defaultComments addObject: comment];
    [allComments addObject: comment];
    [userCommentsOnMicropost addObject: comment];
    
    [self setDefaultCommentsText: [root_dictionary objectForKey: MICROPOST_COMMENTS_TEXT_KEY]];
    
    int new_numberOfComments = [defaultComments count];
    [self setNumberOfComments: [NSString stringWithFormat:@"%d", new_numberOfComments]];
}

- (void) setAllComments:(NSArray*)comments {

    [allComments removeAllObjects];
    
    for (NSDictionary *userDictionary in comments) {
        Comment *comment = [[Comment alloc] initWithJsonRoot: userDictionary];
        [allComments addObject: comment];
    }
}

- (void) setUserCommentsOnMicropst:(NSArray*)comments {

    [userCommentsOnMicropost removeAllObjects];
    
    for (NSDictionary *userDictionary in comments) {
        Comment *comment = [[Comment alloc] initWithJsonRoot: userDictionary];
        [userCommentsOnMicropost addObject: comment];
    }
}

@end
