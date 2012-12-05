//
//  MainButtonBar.m
//  Mindigno
//
//  Created by Enrico on 04/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MainButtonBar.h"

@implementation MainButtonBar

@synthesize delegate;

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

    CGRect rectButtonHome = CGRectMake(77, 7, 50, 33);
    buttonHome = [[UIButton alloc] initWithFrame: rectButtonHome];
    [buttonHome setTag: 0];
    [buttonHome addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonHome setBackgroundImage:[UIImage imageNamed:@"ico-home.png"] forState:UIControlStateNormal];
    [buttonHome setBackgroundImage:[UIImage imageNamed:@"ico-home_hover.png"] forState:UIControlStateHighlighted];
    [buttonHome setBackgroundImage:[UIImage imageNamed:@"ico-home_active.png"] forState:UIControlStateSelected];
    
    CGRect rectButtonProfile = CGRectMake(135, 7, 50, 33);
    buttonProfile = [[UIButton alloc] initWithFrame: rectButtonProfile];
    [buttonProfile setTag: 1];
    [buttonProfile addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonProfile setBackgroundImage:[UIImage imageNamed:@"ico-profile.png"] forState:UIControlStateNormal];
    [buttonProfile setBackgroundImage:[UIImage imageNamed:@"ico-profile_hover.png"] forState:UIControlStateHighlighted];
    [buttonProfile setBackgroundImage:[UIImage imageNamed:@"ico-profile_active.png"] forState:UIControlStateSelected];
    
    CGRect rectButtonSearch = CGRectMake(193, 7, 50, 33);
    buttonSearch = [[UIButton alloc] initWithFrame: rectButtonSearch];
    [buttonSearch setTag: 2];
    [buttonSearch addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonSearch setBackgroundImage:[UIImage imageNamed:@"ico-search.png"] forState:UIControlStateNormal];
    
    [buttonSearch setUserInteractionEnabled:NO];
    [buttonSearch setAlpha:0.25];
    //[buttonSearch setBackgroundImage:[UIImage imageNamed:@"ico-search_hover.png"] forState:UIControlStateHighlighted];
    //[buttonSearch setBackgroundImage:[UIImage imageNamed:@"ico-search_active.png"] forState:UIControlStateSelected];
    
    //
    
    currentSelectedButton = buttonHome;
    [buttonHome setSelected:YES];
    [buttonHome setUserInteractionEnabled:NO];
    
    //
    
    [self addSubview:buttonHome];
    [self addSubview:buttonProfile];
    [self addSubview:buttonSearch];
}

- (void) buttonClicked:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    [currentSelectedButton setSelected:NO];
    [currentSelectedButton setUserInteractionEnabled:YES];
    currentSelectedButton = button;
    [currentSelectedButton setSelected:YES];
    [currentSelectedButton setUserInteractionEnabled:NO];
    
    switch ([button tag]) {
        case 0:
            if ([delegate respondsToSelector:@selector(clickedButtonHome)]) {
                [delegate clickedButtonHome];
            }
            break;
            
        case 1:
            if ([delegate respondsToSelector:@selector(clickedButtonProfile)]) {
                [delegate clickedButtonProfile];
            }
            break;
            
        case 2:
            if ([delegate respondsToSelector:@selector(clickedButtonSearch)]) {
                [delegate clickedButtonSearch];
            }
            break;
            
        default:
            break;
    }
    
    
}

@end
