//
//  Vignetta.h
//  Mindigno
//
//  Created by Enrico on 14/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vignetta : NSObject {

    NSString *vignettaUrl;
    NSString *authorName;
    NSString *authorLink;
}

@property (nonatomic, copy) NSString *vignettaUrl;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *authorLink;

- (id)initWithJsonRoot:(NSDictionary*)root_vignetta;

@end
