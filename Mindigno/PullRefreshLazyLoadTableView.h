//
//  PullRefreshTableViewController.h
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

#import <UIKit/UIKit.h>

///

@interface FooterView : UIView {
    
    UIImageView *imageViewBackground;
    
    UILabel *labelLoading;
    UIActivityIndicatorView *indicatorViewLoading;
    
    NSString *textLoad;
    NSString *textLoading;
}

- (void) startLoadingAnimation;
- (void) stopLoadingAnimation;

@end

///

@interface RefreshHeaderView : UIView {
    
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property (nonatomic, readonly) UILabel *refreshLabel;
@property (nonatomic, readonly) UIImageView *refreshArrow;
@property (nonatomic, readonly) UIActivityIndicatorView *refreshSpinner;

@property (nonatomic, readonly) NSString *textPull;
@property (nonatomic, readonly) NSString *textRelease;
@property (nonatomic, readonly) NSString *textLoading;

@end

///

@protocol PullRefreshTableViewDelegate <UITableViewDelegate>

@optional
- (BOOL)respondsToSelector:(SEL)aSelector;
- (void) tableViewHasRefreshed:(UITableView*)tableView;
- (void) loadNewDataInBackgroundForTableView:(UITableView*)tableView;

@end

@interface PullRefreshLazyLoadTableView : UITableView <UITableViewDelegate> {
    
    id <PullRefreshTableViewDelegate> __weak delegate;
    
    //

    BOOL enabledRefresh; //Option
    
    BOOL isDragging;
    BOOL isLoadingRefresh;
    
    BOOL isLoadingLazyLoad;
    RefreshHeaderView *refreshHeaderView;

    //

    BOOL enabledLazyLoad; //Option
    
    FooterView *footerViewLoading;
}

@property (nonatomic, weak) id <PullRefreshTableViewDelegate> delegate;

@property (nonatomic) BOOL enabledRefresh;
@property (nonatomic) BOOL enabledLazyLoad;

@end
