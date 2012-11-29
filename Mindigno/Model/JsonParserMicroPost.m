//
//  JsonParserMicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "JsonParserMicroPost.h"

@interface JsonParserMicroPost ()

@end

@implementation JsonParserMicroPost

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void) startDownloadAndParsingJsonAtUrl:(NSString *)urlString {

    NSURL *url = [NSURL URLWithString: urlString];
    NSData *data = [NSData dataWithContentsOfURL: url];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *arrayX = [dictionary objectForKey:@"keyJson"];
    
    NSLog(@"%@", arrayX);
    
    [self performSelectorOnMainThread:@selector(finishParsing) withObject:nil waitUntilDone:YES];
}

@end
