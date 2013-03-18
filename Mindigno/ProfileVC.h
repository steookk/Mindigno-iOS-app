//
//  ProfileVC.h
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ProfileUserVC.h"

@interface ProfileVC : UIViewController {

    User* currentUser;
    NSArray *arrayMicroPost;
    
    ProfileUserVC *profileUserVC;
    
    IBOutlet UIButton *buttonSegue;
}

@property (nonatomic) User* currentUser;
@property (nonatomic) NSArray *arrayMicroPost;

- (IBAction)goBack:(id)sender;

@end
