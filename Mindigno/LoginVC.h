//
//  LoginVC.h
//  Mindigno
//
//  Created by Enrico on 05/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <UITextFieldDelegate> {
 
    IBOutlet UITextField *textFieldUsername;
    IBOutlet UITextField *textFieldPassword;
    
}

@end
