//
//  ViewController.h
//  Mindigno
//
//  Created by Enrico on 28/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainButtonBar.h"
#import "HomeVC.h"
#import "ProfileUserVC.h"
#import "LoginSignupVC.h"

@interface RootVC : UIViewController <MainButtonBarDelegate, LoginSignupVCDelegate> {
    
    IBOutlet MainButtonBar *mainButtonBar;
    
    IBOutlet UIView *containerViewProfileUser;
    HomeVC *homeVC;
    ProfileUserVC *profileUserVC;
    
    IBOutlet UIButton *loginButton;
}



@end
