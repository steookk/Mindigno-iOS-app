//
//  Vignetta.m
//  Mindigno
//
//  Created by Enrico on 14/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "Vignetta.h"
#import "JsonKeys.h"

@implementation Vignetta

@synthesize vignettaUrl, authorName, authorLink;

- (id)initWithJsonRoot:(NSDictionary*)root_vignetta {

    self = [super init];
    
    if (self) {
        
        [self setVignettaUrl:[root_vignetta objectForKey: VIGNETTA_URL_KEY]];
        [self setAuthorName:[root_vignetta objectForKey: VIGNETTA_AUTHOR_NAME_KEY]];
        [self setAuthorLink:[root_vignetta objectForKey: VIGNETTA_AUTHOR_URL_KEY]];
    }
    return self;
}

@end
