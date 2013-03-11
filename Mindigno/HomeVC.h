//
//  HomeVC.h
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshLazyLoadTableView.h"
#import "ScrollButtonBar.h"

@interface HomeVC : UIViewController <ScrollButtonBarDataSource, ScrollButtonBarDelegate, UITableViewDataSource, PullRefreshTableViewDelegate> {

    NSArray *arrayButtonTitle;
    IBOutlet ScrollButtonBar *scrollButtonBar;
    
    NSMutableArray *arrayMicroPost;
    IBOutlet PullRefreshLazyLoadTableView *tableViewMicroPost;
    
    //
    IBOutlet UIButton *buttonPlus;
}

@property (nonatomic, readonly) UIButton *buttonPlus;

@end
