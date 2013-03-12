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
    
    IBOutlet UILabel *labelFollowersText;
    IBOutlet UILabel *labelFollowingText;
    IBOutlet UILabel *labelNumberFollowers;
    IBOutlet UILabel *labelNumberFollowing;
    
    IBOutlet UITableView *tableViewMicroPost;
    NSArray *arrayMicroPost;

    //
    IBOutlet UIButton *buttonSettings;
}

@property (nonatomic, retain) User* currentUser;
@property (nonatomic) NSArray *arrayMicroPost;

@property (nonatomic, readonly) UIButton *buttonSettings;

- (void) refreshView;

@end
