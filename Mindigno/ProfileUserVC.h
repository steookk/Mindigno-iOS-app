//
//  ProfileUserVC.h
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol ProfileUserVCDelegate

@optional
- (BOOL)respondsToSelector:(SEL)aSelector;
- (void) clickedButtonLogout;

@end

@interface ProfileUserVC : UIViewController {
    
    id <ProfileUserVCDelegate> __weak delegate;
    
    User* currentUser;
    
    IBOutlet UILabel *labelName;
    IBOutlet UIImageView *imageViewAvatar;
    
    //
    IBOutlet UIButton *buttonLogout;

    //
    IBOutlet UIButton *buttonSettings;
}

@property (nonatomic, weak) id <ProfileUserVCDelegate> delegate;
@property (nonatomic, retain) User* currentUser;

@property (nonatomic, readonly) UIButton *buttonSettings;

- (IBAction)logout:(id)sender;

@end
