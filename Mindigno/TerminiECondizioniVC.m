//
//  TerminiECondizioniVC.m
//  Mindigno
//
//  Created by Enrico on 26/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "TerminiECondizioniVC.h"

@interface TerminiECondizioniVC ()

@end

@implementation TerminiECondizioniVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [indicatorView setHidesWhenStopped: YES];
    
    [webView setDelegate: self];
    [webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: @"http://www.mindigno.com/terms"]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

    [indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [indicatorView stopAnimating];
}

@end
