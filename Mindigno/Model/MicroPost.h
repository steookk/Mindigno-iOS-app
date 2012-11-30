//
//  MicroPost.h
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroPost : NSObject {

    NSString *title;
    NSString *description;
    
    NSString *createdAtText;
    NSString *indignatiText;
    NSString *sourceText;
    
    BOOL isLink;

    NSMutableArray *comments;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;

@property (nonatomic, copy) NSString *createdAtText;
@property (nonatomic, copy) NSString *indignatiText;
@property (nonatomic, copy) NSString *sourceText;

@property (nonatomic) BOOL isLink;

- (NSArray*) getAllComments;
- (void) addComment:(NSString *)comment;
- (void) addComments:(NSArray *)comments;
- (void) removeAllComments;
- (int) getNumberOfComments;
- (NSString*) getCommentAtIndex:(int)index;

@end
