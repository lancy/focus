//
//  MainviewController.h
//  focus
//
//  Created by Lancy on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleViewController.h"

@class SimpleViewController;

#import <CoreData/CoreData.h>


@interface MainViewController : UITableViewController <NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    SimpleViewController *_simpleViewController;
    NSFetchedResultsController *__fetchedResultsController;
    NSManagedObjectContext *__managedObjectContext;
    
}


@property (strong, nonatomic) SimpleViewController *simpleViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (weak, nonatomic) UITextField *quickTextField;




@end
