//
//  ViewController.h
//  Mindigno
//
//  Created by Enrico on 28/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainButtonBar.h"
#import "PullRefreshTableView.h"
#import "ScrollButtonBar.h"

@interface RootVC : UIViewController <MainButtonBarDelegate, UITableViewDataSource, PullRefreshTableViewDelegate, ScrollButtonBarDataSource, ScrollButtonBarDelegate> {
    
    IBOutlet MainButtonBar *mainButtonBar;
    
    NSArray *arrayMicroPost;
    IBOutlet PullRefreshTableView *tableViewMicroPost;
    
    //
    NSArray *arrayButtonTitle;
    IBOutlet ScrollButtonBar *scrollButtonBar;
}

@end
