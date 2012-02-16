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

@interface MainViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    DetailViewController *_detailViewController;
    NSFetchedResultsController *__fetchedResultsController;
    NSManagedObjectContext *__managedObjectContext;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
