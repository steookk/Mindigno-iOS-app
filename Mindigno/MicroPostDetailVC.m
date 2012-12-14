//
//  MicroPostDetailVCViewController.m
//  Mindigno
//
//  Created by Enrico on 30/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MicroPostDetailVC.h"
#import "UIImageView+WebCache.h"

@interface MicroPostDetailVC ()

@end

@implementation MicroPostDetailVC

@synthesize currentMicroPost;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewThumb setImageWithURL: [NSURL URLWithString:[currentMicroPost imageUrl]] placeholderImage:placeHolder];
    
    [labelTitle setText:[currentMicroPost title]];
    [textViewDescription setText:[currentMicroPost description]];
    
    [labelSourceText setHidden: NO];
    [contentViewCreator setHidden: YES];
    [buttonGoToSource setHidden: YES];
    
    if ([currentMicroPost isLink]) {
        
        [buttonGoToSource setHidden: NO];
        [labelSourceText setText: [currentMicroPost sourceText]];
        
    } else {
        
        if ([currentMicroPost isUserCreator]) {
            
            [labelSourceText setHidden: YES];
            [contentViewCreator setHidden: NO];
            
            UILabel *labelPreposition = (UILabel*)[contentViewCreator viewWithTag:11];
            UIImageView *imageViewAvatar = (UIImageView*)[contentViewCreator viewWithTag:12];
            UILabel *labelUsername = (UILabel*)[contentViewCreator viewWithTag:13];
            
            User *user = [currentMicroPost userCreator];
            
            [labelPreposition setText:[currentMicroPost preposition]];
            [imageViewAvatar setImageWithURL:[NSURL URLWithString: [user avatarUrl]] placeholderImage:placeHolder];
            [labelUsername setText:[user name]];
            
        } else {
            [labelSourceText setText: [currentMicroPost defaultText]];
        }
    }
    
    [[buttonIndignatiText titleLabel] setNumberOfLines:2];
    [[buttonIndignatiText titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[buttonIndignatiText titleLabel] setTextAlignment:NSTextAlignmentLeft];
    //[[buttonIndignatiText titleLabel] setText: [currentMicroPost indignatiText]];
    [buttonIndignatiText setTitle:[currentMicroPost indignatiText] forState:UIControlStateNormal];
    
    [labelDefaultCommentText setText:[currentMicroPost defaultCommentsText]];
}

- (IBAction)goToSource:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [currentMicroPost link]]];
}

- (IBAction)goBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
