//
//  RoundedImageView.h
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundUtils : NSObject {

}

//Is ok only with PNG image
+ (UIImage *)makeRoundCornerImage:(UIImage*)img withCornerWidth:(int)cornerWidth andWithCornerHeight:(int)cornerHeight;

//Button and UITextField must be set to "custom"
+ (void) setButtonRoundAndTrasparent:(UIButton*)button;
+ (void) setTextFieldRoundAndTrasparent:(UITextField*)textField;

+ (NSString*) getRandomImgUrl;

@end
