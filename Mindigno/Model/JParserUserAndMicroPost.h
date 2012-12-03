//
//  JsonParserMicroPost.h
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MicroPost.h"

#define URL_JSON_MICROPOST_TEST @"http://staging.mindigno.com"

@interface JParserUserAndMicroPost : NSObject {

    User *user;
    NSMutableArray *microPosts;
}

@property (nonatomic, readonly) User *user;
@property (nonatomic, readonly) NSArray *microPosts;

- (void) startDownloadAndParsingJsonAtUrl:(NSString *)urlString;

@end
