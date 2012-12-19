//
//  CommentDetailVC.m
//  Mindigno
//
//  Created by Enrico on 17/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "CommentDetailVC.h"
#import "UIImageView+WebCache.h"

@interface CommentDetailVC ()

@end

@implementation CommentDetailVC

@synthesize currentComment;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *userCreator = [currentComment userCreator];
    
    [labelName setText: [userCreator name]];

    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewAvatar setImageWithURL:[NSURL URLWithString:[userCreator avatarUrl]] placeholderImage:placeHolder];
    
    [textViewComment setText: [currentComment content]];
}

- (IBAction)goBack:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
