//
//  RootViewController.m

//
//  Created by Lan Chenyu on 30/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "RootViewController.h"
#import "InboxViewController.h"
#import "TodayViewController.h"
#import "AfterViewController.h"
#import "SomedayViewController.h"
#import "UIView+Badge.h"

@interface RootViewController()

- (void)configureMainViewControllers;
- (void)configureScrollView;
- (void)configureScrollBar;
- (void)updateBadge;

@end

@implementation RootViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize scrollBar;
@synthesize InboxIcon;
@synthesize TodayIcon;
@synthesize pointer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureMainViewControllers];
    [self configureScrollView];
    [self configureScrollBar];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setScrollBar:nil];
    [self setPointer:nil];
    [self setInboxIcon:nil];
    [self setTodayIcon:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)configureMainViewControllers
{
    InboxViewController *inboxViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"inbox"];
    TodayViewController *todayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"today"];
    AfterViewController *afterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"after"];
    SomedayViewController *somedayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"someday"];
       
    
    
    [self addChildViewController:inboxViewController];
    [self addChildViewController:todayViewController];
    [self addChildViewController:afterViewController];
    [self addChildViewController:somedayViewController];
}

- (void)configureScrollView
{
    [self.scrollView setDirectionalLockEnabled:YES];
    self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.childViewControllers count], scrollView.frame.size.height);
    for (int i = 0; i < [self.childViewControllers count]; i++) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * i;		
        frame.origin.y = 0;
        [[[self.childViewControllers objectAtIndex:i] view] setFrame:frame]; 
        [scrollView addSubview:[[self.childViewControllers objectAtIndex:i] view]];
    }
}

- (void)configureScrollBar
{

    [self updateBadge];
}

- (void)updateBadge
{
    InboxViewController *inboxVC = [self.childViewControllers objectAtIndex:0];
    TodayViewController *todayVC = [self.childViewControllers objectAtIndex:1];
    [[self.InboxIcon badge] setBadgeValue:[inboxVC.fetchedResultsController.fetchedObjects count]];
    [[self.TodayIcon badge] setBadgeValue:[todayVC.fetchedResultsController.fetchedObjects count]];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateBadge];
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage != page)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.pointer setCenter:CGPointMake(self.pointer.center.x + (page - self.pageControl.currentPage) * 62, self.pointer.center.y)];
             }];
        self.pageControl.currentPage = page;
        
    }
    if ((int)(self.scrollView.contentOffset.x) % (int)(pageWidth) > 20)
    {
        [self.scrollBar setHidden:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollBar setAlpha:0];
    }completion:^(BOOL finished){
        [self.scrollBar setAlpha:1];
        [self.scrollBar setHidden:YES];
    }];
}




@end
