//
//  DetailViewController.h
//  test
//
//  Created by Lan Chenyu on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "item.h"


@interface DetailViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {    
    UIDatePicker *_datePicker;

}

@property (strong, nonatomic) Item* detailItem;


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *datePickerTool;

- (IBAction)changePriority:(id)sender;
- (IBAction)changeTitle:(id)sender;
- (IBAction)changeNote:(id)sender;
- (IBAction)changeDate:(id)sender;

- (IBAction)pressPickerDoneButton:(id)sender;


- (IBAction)didDoneButton:(id)sender;

- (IBAction)pressSaveButton:(id)sender;

@end
