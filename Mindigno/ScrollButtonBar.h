//
//  ScrollBarVC.h
//  Mindigno
//
//  Created by Enrico on 03/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollButtonBar;
@protocol ScrollButtonBarDataSource <NSObject>

@required
- (NSInteger) numberOfButtonsInScrollButtonBar:(ScrollButtonBar*)scrollButtonBar;
- (void) setButtonProperties:(UIButton*)button withIndex:(NSInteger)index;

@optional
- (BOOL)respondsToSelector:(SEL)aSelector;
- (NSString*) backgroundImageUrlOfSelectedButton;

@end

//

@protocol ScrollButtonBarDelegate <NSObject>

@optional
- (BOOL)respondsToSelector:(SEL)aSelector;
- (void) buttonClicked:(UIButton*)button withIndex:(NSInteger)index;

@end

///

@interface ScrollButtonBar : UIScrollView {

    id <ScrollButtonBarDataSource> __weak dataSourceBar;
    id <ScrollButtonBarDelegate> __weak delegateBar;
    
    UIButton *currentSelectedButton;
}

@property (nonatomic, weak) id <ScrollButtonBarDataSource> dataSourceBar;
@property (nonatomic, weak) id <ScrollButtonBarDelegate> delegateBar;

- (int) indexOfCurrentSelectedButton;

@end

