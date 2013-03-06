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
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
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
    
    NSMutableArray *viewsToInsert = [NSMutableArray arrayWithCapacity: numberOfButton];
    
    for (i=0; i<numberOfButton; i++) {

        CGRect rectButton = CGRectZero;
        UIButton *button = [[UIButton alloc] initWithFrame:rectButton];
        [button setBackgroundColor: [UIColor clearColor]];
        
        NSString *buttonTitle = [NSString stringWithFormat:@"Button_%d", i];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        
        //Get setting from dataSource
        [dataSourceBar setButtonProperties:button withIndex:i];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([dataSourceBar respondsToSelector:@selector(backgroundImageUrlOfSelectedButton)]) {
            
            NSString *urlImage = [dataSourceBar backgroundImageUrlOfSelectedButton];
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
            [currentSelectedButton setUserInteractionEnabled:NO];
        }
        
        pointerToDraw += (stringSize.width + buttonMargin) + buttonSpace;
        
        [viewsToInsert addObject: button];
        //[self addSubview:button];
    }
    
    [self setContentSize:CGSizeMake(pointerToDraw, heightButton)];
    
    //Se entra nello schermo disponibile allora viene centrato il tutto, altrimenti si ha la barra scrollabile
    if (pointerToDraw <= 320) {
        
        CGRect rectScrollButtonBar = [self frame];
        CGRect contentCenteredRect = CGRectMake((320.0-pointerToDraw)/2.0, 0, pointerToDraw, rectScrollButtonBar.size.height);
        
        NSString *test = [[@"ciao/pluto/" stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"/pippo"];
        NSLog(@"NOTE: %@", test);
        
        UIView *contentCenteredView = [[UIView alloc] initWithFrame: contentCenteredRect];
        [contentCenteredView setBackgroundColor:[UIColor clearColor]];
        
        for (UIView *button in viewsToInsert) {
            [contentCenteredView addSubview:button];
        }
        
        [self addSubview: contentCenteredView];
    
    } else {
     
        for (UIView *button in viewsToInsert) {
            [self addSubview:button];
        }
    }
    
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
}

- (void) buttonClicked:(id)sender {
 
    UIButton *button = (UIButton*)sender;
    
    [currentSelectedButton setSelected:NO];
    [currentSelectedButton setUserInteractionEnabled:YES];
    currentSelectedButton = button;
    [currentSelectedButton setSelected:YES];
    [currentSelectedButton setUserInteractionEnabled:NO];
    
    if ([delegateBar respondsToSelector:@selector(buttonClicked:withIndex:)]) {
        [delegateBar buttonClicked:button withIndex:[button tag]];
    }
}

- (int) indexOfCurrentSelectedButton {
    return [currentSelectedButton tag];
}

@end
