//
//  ButtonWithBadge.h
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface ButtonWithBadge : UIButton {

    CustomBadge *badge;
}

- (void) setBadgeString:(NSString*)string;
- (void) hideBadge:(BOOL)yOrN;

@end
