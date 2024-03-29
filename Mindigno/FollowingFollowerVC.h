//
//  FollowingFollowerVC.h
//  Mindigno
//
//  Created by Enrico on 18/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FollowingFollowerVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    IBOutlet UITableView *tableViewFollowingOrFollower;
    NSArray *arrayFollowingOrFollower;
    
    IBOutlet UILabel *labelHeader;
    
    User *currentUser;
    
    BOOL isFollowing;
}

@property (nonatomic) BOOL isFollowing;
@property (nonatomic) NSString *stringHeader;

- (IBAction)goBack:(id)sender;

@end
