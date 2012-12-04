//
//  ScrollBarVC.m
//  Mindigno
//
//  Created by Enrico on 03/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "ScrollButtonBar.h"

@interface ScrollButtonBar ()

- (void) startInizialization;

@end

@implementation ScrollButtonBar

@synthesize dataSourceBar, delegateBar;

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect {

    [super drawRect:rect];
    
    [self startInizialization];
}

- (void) startInizialization {
    
    int numberOfButton = [dataSourceBar numberOfButtonsInScrollButtonBar:self];
    
    //const int widthButton = 100;
    const int heightButton = self.frame.size.height;
    
    const int buttonSpace = 10;
    const int buttonMargin = 10;
    
    int i;
    int pointerToDraw = buttonSpace;
    for (i=0; i<numberOfButton; i++) {

        CGRect rectButton = CGRectZero;
        UIButton *button = [[UIButton alloc] initWithFrame:rectButton];
        
        NSString *buttonTitle = [NSString stringWithFormat:@"Button_%d", i];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        //Get setting from dataSource
        [dataSourceBar setButtonProperties:button withIndex:i];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([dataSourceBar respondsToSelector:@selector(backgroundImageOfSelectedButton)]) {
            
            NSString *urlImage = [dataSourceBar backgroundImageOfSelectedButton];
            UIImage *backgroundImage = [UIImage imageNamed:urlImage];
            [button setBackgroundImage:backgroundImage forState:UIControlStateSelected];
        }
        
        //For testing
        //[button setBackgroundColor:[UIColor greenColor]];
        
        CGSize stringSize = [[[button titleLabel] text] sizeWithFont: [[button titleLabel] font]];
        rectButton = CGRectMake(pointerToDraw, 0, stringSize.width+buttonMargin, heightButton);
        [button setFrame:rectButton];
        [button setTag: i];
        
        //Default selected button
        if (i==0) {
            currentSelectedButton = button;
            [currentSelectedButton setSelected:YES];
        }
        
        pointerToDraw += (stringSize.width + buttonMargin) + buttonSpace;
        
        [self addSubview:button];
    }
    
    [self setContentSize:CGSizeMake(pointerToDraw, heightButton)];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
}

- (void) buttonClicked:(id)sender {
 
    UIButton *button = (UIButton*)sender;
    
    [currentSelectedButton setSelected:NO];
    currentSelectedButton = button;
    [currentSelectedButton setSelected:YES];
    
    if ([delegateBar respondsToSelector:@selector(buttonClicked:withIndex:)]) {
        [delegateBar buttonClicked:button withIndex:[button tag]];
    }
}

- (int) indexOfCurrentSelectedButton {
    return [currentSelectedButton tag];
}

@end
