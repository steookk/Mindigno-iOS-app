//
//  IndignatiVC.h
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicroPost.h"

@interface IndignatiVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    NSMutableDictionary *titleToIndignati;
    
    MicroPost __weak *currentMicroPost;
    
    IBOutlet UITableView *tableViewIndignati;
}

@property(nonatomic, weak) MicroPost *currentMicroPost;

- (IBAction)goBack:(id)sender;

@end
