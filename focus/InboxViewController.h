//
//  InboxViewController.h
//  test
//
//  Created by Lan Chenyu on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>
#import "MainviewController.h"

@interface InboxViewController : MainViewController <UITextFieldDelegate>

- (IBAction)quickAddItem:(id)sender;

@end
