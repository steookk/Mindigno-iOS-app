//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshLazyLoadTableView.h"

///

@implementation FooterView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        textLoad = @"Carica nuove indignazioni";
        textLoading = @"Caricamento...";
        
        //
        
        imageViewBackground = [[UIImageView alloc] initWithFrame:self.frame];
        [imageViewBackground setImage:[UIImage imageNamed:@"box-ombrato.jpg"]];
        [self addSubview:imageViewBackground];
        
        labelLoading = [[UILabel alloc] initWithFrame:self.frame];
        [labelLoading setTextAlignment:NSTextAlignmentCenter];
        [labelLoading setBackgroundColor:[UIColor clearColor]];
        [labelLoading setFont:[UIFont fontWithName:@"Arial" size:13]];
        [labelLoading setText: textLoad];
        [self addSubview:labelLoading];
        
        indicatorViewLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicatorViewLoading setFrame:CGRectMake(5, 0, self.frame.size.height, self.frame.size.height)];
        [indicatorViewLoading setHidesWhenStopped: YES];
        [self addSubview:indicatorViewLoading];
    }
    return self;
}

- (void) startLoadingAnimation {
    
    [labelLoading setText: textLoading];
    [indicatorViewLoading startAnimating];
}

- (void) stopLoadingAnimation {
    
    [labelLoading setText: textLoad];
    [indicatorViewLoading stopAnimating];
}

@end

///

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation RefreshHeaderView

@synthesize refreshLabel, refreshArrow, refreshSpinner;
@synthesize textPull, textRelease, textLoading;

- (void)setupStrings {
    
    textPull = @"Pull down to refresh...";
    textRelease = @"Release to refresh...";
    textLoading = @"Loading...";
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
        refreshLabel.backgroundColor = [UIColor clearColor];
        refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
        refreshLabel.textAlignment = NSTextAlignmentCenter;
        
        refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayArrow.png"]];
        [refreshArrow setContentMode:UIViewContentModeScaleAspectFit];
        refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                        (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                        27, 44);
        
        refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
        refreshSpinner.hidesWhenStopped = YES;
        
        [self addSubview:refreshLabel];
        [self addSubview:refreshArrow];
        [self addSubview:refreshSpinner];
        
        [self setupStrings];
    }
    
    return self;
}

@end

///

@interface PullRefreshLazyLoadTableView()

- (void) setup;

- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

@end

@implementation PullRefreshLazyLoadTableView

@synthesize delegate, enabledRefresh, enabledLazyLoad;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (void) setDelegate:(id<PullRefreshTableViewDelegate>)myDelegate {
    
    delegate = myDelegate;
    [super setDelegate:self];
}

- (void) drawRect:(CGRect)rect {
    
    [super drawRect: rect];
    [self addPullToRefreshHeader];
}

- (void) setup {
    
    footerViewLoading = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    isLoadingLazyLoad = NO;
    
    [self setEnabledRefresh:NO];
    [self setEnabledLazyLoad:NO];
}

- (void)addPullToRefreshHeader {
    
    refreshHeaderView = [[RefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    
    [self addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [refreshHeaderView setHidden: !enabledRefresh];
    
    if (enabledRefresh) {
        if (isLoadingRefresh) return;
        isDragging = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (enabledRefresh) {
        
        if (isLoadingRefresh) {
            // Update the content inset, good for section headers
            if (scrollView.contentOffset.y > 0)
                self.contentInset = UIEdgeInsetsZero;
            else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
                self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (isDragging && scrollView.contentOffset.y < 0) {
            // Update the arrow direction and label
            [UIView animateWithDuration:0.25 animations:^{
                if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                    // User is scrolling above the header
                    refreshHeaderView.refreshLabel.text = refreshHeaderView.textRelease;
                    [refreshHeaderView.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                } else { 
                    // User is scrolling somewhere within the header
                    refreshHeaderView.refreshLabel.text = refreshHeaderView.textPull;
                    [refreshHeaderView.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
                }
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (enabledRefresh) {
            
        if (isLoadingRefresh) return;
        isDragging = NO;
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
            // Released above the header
            [self startLoading];
        }
    }
}

- (void)startLoading {
    isLoadingRefresh = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshHeaderView.refreshLabel.text = refreshHeaderView.textLoading;
        refreshHeaderView.refreshArrow.hidden = YES;
        [refreshHeaderView.refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoadingRefresh = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsZero;
        [refreshHeaderView.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } 
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshHeaderView.refreshLabel.text = refreshHeaderView.textPull;
    refreshHeaderView.refreshArrow.hidden = NO;
    [refreshHeaderView.refreshSpinner stopAnimating];
}

- (void)refresh {
    
    if ([delegate respondsToSelector:@selector(tableViewHasRefreshed:)]) {
        [delegate tableViewHasRefreshed:self];
    }
    
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

///

- (void) setEnabledLazyLoad:(BOOL)_enabledLazyLoad {
    
    if (_enabledLazyLoad) {
        [self setTableFooterView:footerViewLoading]; 
    } else {
        [self setTableFooterView:nil];
    }
    
    enabledLazyLoad = _enabledLazyLoad;
}

- (void) finishToLoadNewData:(UITableView*)tableView {

    [footerViewLoading stopLoadingAnimation];
    isLoadingLazyLoad = NO;
}

- (void) startToLoadNewDataInBackground:(UITableView*)tableView {
    
    if ([delegate respondsToSelector: @selector(loadNewDataInBackgroundForTableView:)]) {
        [delegate loadNewDataInBackgroundForTableView: tableView];
    }
    
    [self performSelectorOnMainThread:@selector(finishToLoadNewData:) withObject:tableView waitUntilDone:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (enabledLazyLoad) {
        
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        float actualScrolling = scrollView.contentSize.height;
        
        if (!isLoadingLazyLoad && endScrolling >= actualScrolling) {
            
            isLoadingLazyLoad = YES;
            
            [footerViewLoading startLoadingAnimation];
            [self performSelectorInBackground:@selector(startToLoadNewDataInBackground:) withObject:self];
        }
    }
}

@end
