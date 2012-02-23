//
//  AddViewController.h
//  focus
//
//  Created by Lancy on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddViewController;

@protocol AddViewControllerDelegate
- (void)AddViewControllerDidFinish:(AddViewController *)controller;
@end


@interface AddViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet id <AddViewControllerDelegate> delegate;

- (void)insertNewObject;
- (IBAction)saveItem:(id)sender;
@end
