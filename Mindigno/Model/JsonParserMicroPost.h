//
//  JsonParserMicroPost.h
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define URL_JSON_MICROPOST @"http://www.mindigno.com/"

@interface JsonParserMicroPost : NSObject {

}

- (void) startDownloadAndParsingJsonAtUrl:(NSString *)urlString;

@end
