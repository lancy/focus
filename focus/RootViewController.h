//
//  RootViewController.h
//  test
//
//  Created by Lan Chenyu on 30/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleViewController.h"

@interface RootViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    UIImageView *dragView;
}

@property (strong, nonatomic) SimpleViewController *simpleViewController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *scrollBar;
@property (weak, nonatomic) IBOutlet UIImageView *pointer;


@property (nonatomic, strong) UILabel *rangeStateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *inboxBarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *todayBarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *afterBarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *somedayBarImageView;

- (void)updateBadge;

@end
