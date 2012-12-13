//
//  MicroPost.h
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroPost : NSObject {

    NSString *micropostID;
    NSString *micropostUrl;
    
    NSString *title;
    NSString *description;
    
    ///
    BOOL isLink;
    
    //isLink = TRUE {
    NSString *imageUrl;
    NSString *sourceText;
    NSString *link;
    //}
    
    //isLink = FALSE {
    BOOL isUserCreator;

    //isUserCreator = TRUE {
    NSString *preposition;
    NSString *userID;
    //}

    //isUserCreator = FALSE {
    NSString *defaultText;
    //}
    //}
    ///

    NSString *createdAtText;
    
    NSString *indignatiText;
    NSMutableArray *followingIndignati;
    
    NSString *defaultCommentsText;
    NSMutableArray *defaultComments;
}

@property (nonatomic, copy) NSString *micropostID;
@property (nonatomic, copy) NSString *micropostUrl;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;

@property (nonatomic) BOOL isLink;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *sourceText;
@property (nonatomic, copy) NSString *link;

@property (nonatomic) BOOL isUserCreator;
@property (nonatomic, copy) NSString *preposition;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, copy) NSString *defaultText;

@property (nonatomic, copy) NSString *createdAtText;

@property (nonatomic, copy) NSString *indignatiText;
@property (nonatomic, copy) NSString *defaultCommentsText;


- (id)initWithJsonRoot:(NSDictionary*)root_microPost;

- (NSArray*) getAllComments;
- (void) addComment:(NSString *)comment;
- (void) addComments:(NSArray *)comments;
- (void) removeAllComments;
- (int) getNumberOfComments;
- (NSString*) getCommentAtIndex:(int)index;

@end
