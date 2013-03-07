//
//  ButtonWithBadge.m
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "ButtonWithBadge.h"

@implementation ButtonWithBadge

- (void) initCommon {

    // Create simple Badge
    badge = [CustomBadge customBadgeWithString:@""
                               withStringColor:[UIColor whiteColor]
                                withInsetColor:[UIColor redColor]
                                withBadgeFrame:YES
                           withBadgeFrameColor:[UIColor whiteColor]
                                     withScale:0.75
                                   withShining:YES];
    
    // Set Position of Badge 1
    [badge setFrame: CGRectMake(self.frame.size.width/1.5-badge.frame.size.width/2, self.frame.size.height*0.0, badge.frame.size.width, badge.frame.size.height)];
    
    // Add Badge to View
	[self addSubview: badge];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (void) setBadgeString:(NSString*)string {

    [badge setBadgeText:string];
}

- (void) hideBadge:(BOOL)yOrN {
    
    [badge setHidden:yOrN];
}

@end
