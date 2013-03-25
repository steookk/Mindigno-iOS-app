//
//  CommentDetailVC.m
//  Mindigno
//
//  Created by Enrico on 17/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "CommentDetailVC.h"
#import "UIImageView+WebCache.h"
#import "ProfileVC.h"
#import "Mindigno.h"

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
    
    [buttonName setTitle: [userCreator name] forState: UIControlStateNormal];

    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [imageViewAvatar setImageWithURL:[NSURL URLWithString:[userCreator avatarUrl]] placeholderImage:placeHolder];
    
    [textViewComment setText: [currentComment content]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"commentDetailToProfile"]) {
        
        ProfileVC *profileVC = (ProfileVC*)[segue destinationViewController];
        
        User *currentUser = [currentComment userCreator];
        
        [profileVC setCurrentUser:currentUser];
        
        NSArray *micropostOfUser = [[Mindigno sharedMindigno] downloadMicroPostsOfUser: currentUser];
        [profileVC setArrayMicroPost: micropostOfUser];
    }
}

- (IBAction)goBack:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
