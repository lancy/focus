//
//  SimpleViewController.h
//  focus
//
//  Created by Lancy on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "item.h"

@interface SimpleViewController : UITableViewController <UITextFieldDelegate> {
    UIDatePicker *_datePicker;
    
}


@property BOOL isAdd;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Item* detailItem;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *datePickerTool;


@property (weak, nonatomic) IBOutlet UIImageView *priority0Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority1Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority2Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority3Image;



- (IBAction)changePriority:(id)sender;
- (IBAction)changeTitle:(id)sender;
- (IBAction)changeDate:(id)sender;

- (IBAction)pressPickerDoneButton:(id)sender;


- (IBAction)didDoneButton:(id)sender;

- (IBAction)pressDeleteButton:(id)sender;

- (IBAction)pressSaveButton:(id)sender;

@end
