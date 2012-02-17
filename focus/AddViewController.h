//
//  AddViewController.h
//  focus
//
//  Created by Lancy on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)insertNewObject;
- (IBAction)saveItem:(id)sender;


@end
