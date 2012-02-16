//
//  RootViewController.h
//  test
//
//  Created by Lan Chenyu on 30/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *scrollBar;
@property (weak, nonatomic) IBOutlet UIImageView *InboxIcon;
@property (weak, nonatomic) IBOutlet UIImageView *TodayIcon;

@property (weak, nonatomic) IBOutlet UIImageView *pointer;


- (void)updateBadge;

@end
