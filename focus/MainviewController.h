//
//  MainviewController.h
//  focus
//
//  Created by Lancy on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>

@protocol handleDragIssue<NSObject>

- (void)respondToRangeState:(CGPoint)centerPoint ofEclipseView:(UIView *)view WithExpiringLine:(BOOL)expiring;
- (void)respondToTouchUpState:(CGPoint)centerPoint ofEclipseView:(UIView *)view WithExpiringLine:(BOOL)expiring;
- (void)showScrollBar;
- (void)hideScrollBar;

@end

@interface MainViewController : UITableViewController <NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate>
{
    DetailViewController *_detailViewController;
    NSFetchedResultsController *__fetchedResultsController;
    NSManagedObjectContext *__managedObjectContext;
    
    BOOL longPressDetected;
    id<handleDragIssue> dragIssueDelegate;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet id<handleDragIssue>  dragIssueDelegate;
@property (nonatomic, strong) UILabel *pointStateLabel; 
@property (nonatomic, strong) IBOutlet UITableView *inboxTableView;


@end