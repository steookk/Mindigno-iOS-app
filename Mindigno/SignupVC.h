//
//  LoginSelectorVC.h
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GTKeyboardHelper/GTKeyboardHelper.h>

@interface SignupVC : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {

    IBOutlet UITextField *textFieldNome;
    IBOutlet UITextField *textFieldMail;
    
    IBOutlet UITextField *textFieldPassword;
    IBOutlet UITextField *textFieldRetipedPassword;
    
    IBOutlet UIBarButtonItem *buttonBarRegistrati;
}

- (IBAction)signup:(id)sender;

@end
