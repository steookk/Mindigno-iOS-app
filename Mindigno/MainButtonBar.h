//
//  MainButtonBar.h
//  Mindigno
//
//  Created by Enrico on 04/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MainButtonBarDelegate

@optional
- (BOOL)respondsToSelector:(SEL)aSelector;
- (void) clickedButtonHome;
- (void) clickedButtonProfile;
- (void) clickedButtonSearch;

@end

@interface MainButtonBar : UIView {

    id <MainButtonBarDelegate> __weak delegate;
    
    UIButton *buttonHome;
    UIButton *buttonProfile;
    UIButton *buttonSearch;
    
    UIButton *currentSelectedButton;
    
    //
    UIView *containerCustomVariableButton;
    UIButton __weak *customVariableButton;
}

@property (nonatomic, readonly) UIButton *buttonHome;
@property (nonatomic, readonly) UIButton *buttonProfile;
@property (nonatomic, readonly) UIButton *buttonSearch;

@property (nonatomic, readonly) UIButton *currentSelectedButton;

@property (nonatomic, weak) id <MainButtonBarDelegate> delegate;

//Simula un click forzato con conseguente scattare del target
- (void) clickButton:(UIButton *)button;

//Forza a selezionare un pulsante senza far scattare il target
- (void) selectButton:(UIButton *)button;

- (void) setCustomVariableButton:(UIButton*)button;

@end
