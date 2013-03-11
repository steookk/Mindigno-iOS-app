//
//  ProfileSettingsVC.h
//  Mindigno
//
//  Created by Enrico on 08/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingsVC : UIViewController {

    //
    IBOutlet UIButton *buttonLogout;
}

- (IBAction)logout:(id)sender;
- (IBAction)goBack:(id)sender;

@end
