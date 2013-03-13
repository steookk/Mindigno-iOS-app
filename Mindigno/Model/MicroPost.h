//
//  MicroPost.h
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Vignetta.h"

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
    
    //Se l'utente è indignato sul micropost. Se siamo sulla home, e quindi non è loggato nessun utente, di default è false
    BOOL isIndignato;
    
    //isLink = FALSE {
    BOOL isUserCreator;

    //isUserCreator = TRUE {
    NSString *preposition;
    User *userCreator;
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
    
    BOOL isVignetta;
    Vignetta *vignetta;
    
    NSString *numberOfIndignati;
    NSString *numberOfComments;
    
    NSString *indignatiUrl;
    
    ///
    // titleButton
    NSMutableArray *commentsTabs_buttons;
    // url
    NSMutableArray *commentsTabs_urls;
    ///
}

@property (nonatomic, copy) NSString *micropostID;
@property (nonatomic, copy) NSString *micropostUrl;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;

@property (nonatomic) BOOL isLink;
@property (nonatomic) BOOL isIndignato;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *sourceText;
@property (nonatomic, copy) NSString *link;

@property (nonatomic) BOOL isUserCreator;
@property (nonatomic, copy) NSString *preposition;
@property (nonatomic, retain) User *userCreator;
@property (nonatomic, copy) NSString *defaultText;

@property (nonatomic, copy) NSString *createdAtText;

@property (nonatomic, copy) NSString *indignatiText;
@property (nonatomic, copy) NSString *defaultCommentsText;

@property (nonatomic, readonly) NSArray *followingIndignati;
@property (nonatomic, readonly) NSArray *defaultComments;

@property (nonatomic) BOOL isVignetta;
@property (nonatomic, retain) Vignetta *vignetta;

@property (nonatomic, copy) NSString *numberOfIndignati;
@property (nonatomic, copy) NSString *numberOfComments;

@property (nonatomic, copy) NSString *indignatiUrl;
@property (nonatomic, readonly) NSArray *commentsTabs_buttons;
@property (nonatomic, readonly) NSArray *commentsTabs_urls;

- (id)initWithJsonRoot:(NSDictionary*)root_microPost;

- (NSString *) addOneToNumberIndignati;
- (NSString *) removeOneToNumberIndignati;

@end
