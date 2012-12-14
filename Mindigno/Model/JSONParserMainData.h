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

#define URL_JSON_MICROPOST_TEST @"http://192.168.2.90:3000"

@interface JSONParserMainData : NSObject {

}

- (void) startDownloadAndParsingJsonAtUrl:(NSString *)urlString;

@end
