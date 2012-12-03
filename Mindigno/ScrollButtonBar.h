//
//  ScrollBarVC.h
//  Mindigno
//
//  Created by Enrico on 03/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollButtonBar : UIScrollView {

    NSMutableArray *buttonsTitle;
}

- (id) initWithFrame:(CGRect)frame buttonTitles:(NSArray *)_buttonsTitle;

@end
