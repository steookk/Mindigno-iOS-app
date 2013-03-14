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
    
    NSMutableArray *arrayOfButtons;
    UIButton *currentSelectedButton;
}

@property (nonatomic, readonly) UIButton *currentSelectedButton;

@property (nonatomic, weak) id <ScrollButtonBarDataSource> dataSourceBar;
@property (nonatomic, weak) id <ScrollButtonBarDelegate> delegateBar;

- (void) startInizialization;

- (int) indexOfCurrentSelectedButton;

//Simula un click forzato con conseguente scattare del target
- (void) clickButtonWithIndex:(int)index_button;
//Forza a selezionare un pulsante senza far scattare il target
- (void) selectButtonWithIndex:(int)index_button;

@end

