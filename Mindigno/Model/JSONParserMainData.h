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

@interface JSONParserMainData : NSObject {

}

//Return TRUE if it worked out (there is connection).
- (BOOL) startDownloadAndParsingJsonAtUrl:(NSString *)urlString;

- (void) testHttpPost;

@end
