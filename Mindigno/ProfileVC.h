//
//  ProfileVC.h
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileVC : UIViewController {

    User* currentUser;
    
    IBOutlet UILabel *labelName;
    IBOutlet UIImageView *imageViewAvatar;
}

@property (nonatomic, retain) User* currentUser;

- (IBAction)goBack:(id)sender;

@end
