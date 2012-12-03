//
//  ViewController.h
//  Mindigno
//
//  Created by Enrico on 28/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollButtonBar.h"

@interface RootVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *arrayMicroPost;
    
    IBOutlet UITableView *tableViewMicroPost;
    
    //
    IBOutlet UIView *contentViewScrollBar;
    ScrollButtonBar *scrollBar;
}

@end
