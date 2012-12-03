//
//  ScrollBarVC.m
//  Mindigno
//
//  Created by Enrico on 03/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "ScrollButtonBar.h"

@interface ScrollButtonBar ()

@end

@implementation ScrollButtonBar

- (id) initWithFrame:(CGRect)frame buttonTitles:(NSArray *)_buttonsTitle {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        buttonsTitle = [NSMutableArray array];
        [buttonsTitle addObjectsFromArray:_buttonsTitle];
        
        //
        
        int numberOfButton = [buttonsTitle count];
        
        const int widthButton = 100;
        const int heightButton = 40;
        
        const int buttonSpace = 15;
        
        int i;
        int pointerToDraw = buttonSpace;
        for (i=0; i<numberOfButton; i++) {
            
            UIFont *buttonFont = [UIFont fontWithName:@"Arial" size:14];
            NSString *buttonTitle = [buttonsTitle objectAtIndex:i];
            CGSize stringSize = [buttonTitle sizeWithFont: buttonFont];
            
            //
            
            CGRect rectButton = CGRectMake(pointerToDraw, 0, stringSize.width, heightButton);
            pointerToDraw += stringSize.width + buttonSpace;
            UIButton *button = [[UIButton alloc] initWithFrame:rectButton];
            
            [[button titleLabel] setFont: buttonFont];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
            
            [self addSubview:button];
        }
        
        [self setContentSize:CGSizeMake(i*widthButton, heightButton)];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setBackgroundColor: [UIColor blackColor]];
    }
    
    return self;
}

@end
