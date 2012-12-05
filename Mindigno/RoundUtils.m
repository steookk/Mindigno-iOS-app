//
//  RoundedImageView.m
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "RoundUtils.h"

//NB: import <QuartzCore/QuartzCore.h>

@implementation RoundUtils

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *)makeRoundCornerImage:(UIImage*)img withCornerWidth:(int)cornerWidth andWithCornerHeight:(int)cornerHeight {

	UIImage *newImage = nil;
	
	if( nil != img) {
        
		//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		int w = img.size.width;
		int h = img.size.height;
        
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		CGContextClosePath(context);
		CGContextClip(context);
        
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		//[img release];
        
        
		//newImage = [[UIImage imageWithCGImage:imageMasked] retain];
        newImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
		
		//[pool release];
	}
	
    return newImage;
}

//

+ (void) setButtonRoundAndTrasparent:(UIButton*)button {
    
    CALayer *layer = button.layer;
    layer.backgroundColor = [[UIColor colorWithRed:200 green:200 blue:200 alpha:0.3] CGColor];
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.cornerRadius = 8.0f;
    layer.borderWidth = 1.0f;
}

//

+ (void) setTextFieldRoundAndTrasparent:(UITextField*)textField {
    
    CALayer *layer = textField.layer;
    layer.backgroundColor = [[UIColor colorWithRed:200 green:200 blue:200 alpha:0.3] CGColor];
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.cornerRadius = 8.0f;
    layer.borderWidth = 1.0f;
    
    //Add margin to left
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

@end
