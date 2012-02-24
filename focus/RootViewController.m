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


const int GTRangeInitial = 0;
const int GTRangeNormal = 100;
const int GTRangeExpired = 1;
const int GTRangeTodayWithExpired = 2;
const int GTRangeTowardsLeft = 3;
const int GTRangeTowardsRight = 4;
const int GTRangeTowardsInbox = 10;
const int GTRangeTowardsToday = 11;
const int GTRangeTowardsAfter = 12;
const int GTRangeTowardsSomeday = 13;

const float GTRangeLeftThreshold = 20.0;
const float GTRangeRightThreshold = 300.0;



@interface RootViewController()
{
    int previousRangeState;
    int originalRangeState;
    int currentRangeState;
}

- (void)configureMainViewControllers;
- (void)configureScrollView;
- (void)configureScrollBar;
- (void)updateBadge;

- (int)senseRange:(CGPoint)centerPoint WithExpiringLine:(BOOL)expiring;
//- (int)detectTouchUpState:(CGPoint)centerPoint ofEclipseView:(UIView *)view;
- (void)respondToRangeState:(CGPoint)centerPoint ofEclipseView:(UIView *)view WithExpiringLine:(BOOL)expiring;
- (void)respondToTouchUpState:(CGPoint)centerPoint ofEclipseView:(UIView *)view WithExpiringLine:(BOOL)expiring;

@end

@implementation RootViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize scrollBar;
@synthesize pointer;
@synthesize rangeStateLabel;
@synthesize inboxBarImageView,todayBarImageView,afterBarImageView,somedayBarImageView;


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
    
//    rangeStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,250,260,20)];
//    [self.view addSubview:rangeStateLabel];
//    [rangeStateLabel setText:@"Range"];
//    previousRangeState = GTRangeInitial;
//    originalRangeState = GTRangeInitial;
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setScrollBar:nil];
    [self setPointer:nil];
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
       
    
    inboxViewController.dragIssueDelegate = self;
    todayViewController.dragIssueDelegate = self;
    afterViewController.dragIssueDelegate = self;
    somedayViewController.dragIssueDelegate = self;
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

#pragma mark - Scroll Bar Methods

- (void)hideScrollBar
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollBar setAlpha:0];
    }completion:^(BOOL finished){
        [self.scrollBar setAlpha:1];
        [self.scrollBar setHidden:YES];
    }];
}

-(void)showScrollBar
{
    [self.scrollBar setHidden:NO];
}

- (void)updateBadge
{
    InboxViewController *inboxVC = [self.childViewControllers objectAtIndex:0];
    TodayViewController *todayVC = [self.childViewControllers objectAtIndex:1];
    [[self.inboxBarImageView badge] setBadgeValue:[inboxVC.fetchedResultsController.fetchedObjects count]];
    [[self.todayBarImageView badge] setBadgeValue:[todayVC.fetchedResultsController.fetchedObjects count]];
    
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
        [self showScrollBar];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self hideScrollBar];
}

#pragma mark - Handle Drag Gestures


- (int)senseRange:(CGPoint)centerPoint WithExpiringLine:(BOOL)expiring
{
    int state = GTRangeNormal;
    
    if (expiring == YES) {
        if (centerPoint.y < 200.0) state = GTRangeExpired;
        if (centerPoint.y >= 200.0) state = GTRangeTodayWithExpired;
    }
    if (centerPoint.x < GTRangeLeftThreshold ) state = GTRangeTowardsLeft;
    if (centerPoint.x > GTRangeRightThreshold) state = GTRangeTowardsRight;
    
    if ((centerPoint.y > scrollBar.frame.origin.y) && (centerPoint.y < scrollBar.frame.origin.y + scrollBar.frame.size.height))
    {
        if ((centerPoint.x-scrollBar.frame.origin.x > inboxBarImageView.frame.origin.x) && (centerPoint.x-scrollBar.frame.origin.x < inboxBarImageView.frame.origin.x + inboxBarImageView.frame.size.width)) {
            state = GTRangeTowardsInbox;
        }
        if ((centerPoint.x-scrollBar.frame.origin.x > todayBarImageView.frame.origin.x) && (centerPoint.x-scrollBar.frame.origin.x < todayBarImageView.frame.origin.x + todayBarImageView.frame.size.width)) {
            state = GTRangeTowardsToday;
        }
        if ((centerPoint.x-scrollBar.frame.origin.x > afterBarImageView.frame.origin.x) && (centerPoint.x-scrollBar.frame.origin.x < afterBarImageView.frame.origin.x + afterBarImageView.frame.size.width)) {
            state = GTRangeTowardsAfter;
        }
        if ((centerPoint.x-scrollBar.frame.origin.x > somedayBarImageView.frame.origin.x) && (centerPoint.x-scrollBar.frame.origin.x < somedayBarImageView.frame.origin.x + somedayBarImageView.frame.size.width)) {
            state = GTRangeTowardsSomeday;
        }
    }
    
    return state;
}


- (void)respondToRangeState:(CGPoint)centerPoint ofEclipseView:(UIView *)view WithExpiringLine:(BOOL)expiring;
{
    
    currentRangeState = [self senseRange:centerPoint WithExpiringLine:expiring];
    NSString *RangeState;
    if (currentRangeState != previousRangeState) 
    {
        if (expiring == YES && previousRangeState == GTRangeInitial) {
            originalRangeState = currentRangeState;
        }
        if (currentRangeState == GTRangeNormal) {
            RangeState = [NSString stringWithFormat:@"GTRangeNormal"];
        }
        if (currentRangeState == GTRangeExpired) {
            RangeState = [NSString stringWithFormat:@"GTRangeExpired"];
        }    
        if (currentRangeState == GTRangeTodayWithExpired) {
            RangeState = [NSString stringWithFormat:@"GTRangeTodayWithExpired"];
        }
        //    if (currentRangeState == GTRangeTowardsLeft) {
        //        RangeState = [NSString stringWithFormat:@"GTRangeTowardsLeft"];
        //    }
        //    if (currentRangeState == GTRangeTowardsRight) {
        //        RangeState = [NSString stringWithFormat:@"GTRangeTowardsRgiht"];
        //    }
        if (currentRangeState == GTRangeTowardsInbox) {
            RangeState = [NSString stringWithFormat:@"GTRangeTowardsInbox"];
        }
        if (currentRangeState == GTRangeTowardsToday) {
            RangeState = [NSString stringWithFormat:@"GTRangeTowardsToday"];
        }
        if (currentRangeState == GTRangeTowardsAfter) {
            RangeState = [NSString stringWithFormat:@"GTRangeTowardsAfter"];
        }
        if (currentRangeState == GTRangeTowardsSomeday) {
            RangeState = [NSString stringWithFormat:@"GTRangeTowarsSomeday"];
        }
        previousRangeState=currentRangeState;
        [rangeStateLabel setText:RangeState];
    }
}

- (void)respondToTouchUpState:(CGPoint)centerPoint ofEclipseView:(UIView *)view WithExpiringLine:(BOOL)expiring;
{
    NSString *RangeState;
    if (currentRangeState == GTRangeNormal) {
        RangeState = [NSString stringWithFormat:@"GTRangeNormal, Animate Back"];
    }
    if (currentRangeState == GTRangeExpired) {
        RangeState = [NSString stringWithFormat:@"GTRangeExpired, Arrange for Animating to Expired"];
    }    
    if (currentRangeState == GTRangeTodayWithExpired) {
        RangeState = [NSString stringWithFormat:@"GTRangeTodayWithExpired, Arrange for Animating"];
    }
    
    if (currentRangeState == GTRangeTowardsInbox) {
        RangeState = [NSString stringWithFormat:@"GTRangeTowardsInbox, Throw it"];
    }
    if (currentRangeState == GTRangeTowardsToday) {
        RangeState = [NSString stringWithFormat:@"GTRangeTowardsToday, Throw it"];
    }
    if (currentRangeState == GTRangeTowardsAfter) {
        RangeState = [NSString stringWithFormat:@"GTRangeTowardsAfter, Trrow it"];
    }
    if (currentRangeState == GTRangeTowardsSomeday) {
        RangeState = [NSString stringWithFormat:@"GTRangeTowarsSomeday, Throw it"];
    }
    if (RangeState == nil) {
        RangeState = [NSString stringWithFormat:@"Perhaps a special Place... Let it back to be Normal"];
    }
    
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"Touch up"
                                                    message:RangeState
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    previousRangeState = GTRangeInitial;
    currentRangeState = GTRangeNormal;
}

- (void)AddViewControllerDidFinish:(AddViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAdd"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}



@end
