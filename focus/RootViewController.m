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
@synthesize simpleViewController = _simpleViewController;
@synthesize scrollView;
@synthesize pageControl;
@synthesize scrollBar;
@synthesize pointer;
@synthesize titleImageView;
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
    [self setTitleImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
       
    
//    inboxViewController.dragIssueDelegate = self;
//    todayViewController.dragIssueDelegate = self;
//    afterViewController.dragIssueDelegate = self;
//    somedayViewController.dragIssueDelegate = self;
    
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

#pragma mark - view transition
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"showAdd"]) {
        SimpleViewController *svc = segue.destinationViewController;
        svc.isAdd = YES;
    }
}

#pragma mark - Scroll Bar Methods

- (void)hideScrollBar
{
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationCurveLinear 
                     animations:^{
        [self.scrollBar setAlpha:0];
    }completion:^(BOOL finished){
        [self.scrollBar setAlpha:1];
        [self.scrollBar setHidden:YES];
    }];
        
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.1];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [self.scrollBar setAlpha:0];
//    [UIView commitAnimations];
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
        [UIView animateWithDuration:0.2 
                         animations:^{
            [self.pointer setCenter:CGPointMake(self.pointer.center.x + (page - self.pageControl.currentPage) * 57, self.pointer.center.y)];
             } 
                         completion:^(BOOL finish){
                             
                         }
         ];
        [[[self.childViewControllers objectAtIndex:self.pageControl.currentPage] quickTextField] resignFirstResponder];
        switch (self.pageControl.currentPage) {
            case 0:
                [self.inboxBarImageView setHighlighted:NO];
                break;
            case 1:
                [self.todayBarImageView setHighlighted:NO];
                break;
            case 2:
                [self.afterBarImageView setHighlighted:NO];
                break;
            case 3:
                [self.somedayBarImageView setHighlighted:NO];
                break;
            default:
                break;
        }
        switch (page) {
            case 0:
                [self.titleImageView setImage:[UIImage imageNamed:@"inbox"]];
                [self.inboxBarImageView setHighlighted:YES];
                break;
            case 1:
                [self.titleImageView setImage:[UIImage imageNamed:@"today"]];
                [self.todayBarImageView setHighlighted:YES];
                break;
            case 2:
                [self.titleImageView setImage:[UIImage imageNamed:@"after"]];
                [self.afterBarImageView setHighlighted:YES];
                break;
            case 3:
                [self.titleImageView setImage:[UIImage imageNamed:@"someday"]];
                [self.somedayBarImageView setHighlighted:YES];
                break;
            default:
                break;
        }
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




@end
