//
//  TerminiECondizioniVC.h
//  Mindigno
//
//  Created by Enrico on 26/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TerminiECondizioniVC : UIViewController <UIWebViewDelegate> {

    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *indicatorView;
}

- (IBAction) goBack:(id)sender;

@end
