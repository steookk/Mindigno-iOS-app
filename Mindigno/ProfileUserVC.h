//
//  ProfileUserVC.h
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileUserVC : UIViewController {
    
    User* currentUser;
    
    IBOutlet UILabel *labelName;
    IBOutlet UIImageView *imageViewAvatar;
    
    //
    IBOutlet UIButton *buttonLogout;
}

@property (nonatomic, retain) User* currentUser;

- (IBAction)logout:(id)sender;

@end
