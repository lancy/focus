//
//  DetailViewController.h
//  test
//
//  Created by Lan Chenyu on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "item.h"
#import <MessageUI/MessageUI.h>



@interface DetailViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {    
    UIDatePicker *_datePicker;
    UIPickerView *_durationPicker;
    NSArray *_durationPickerData;
    id <MFMailComposeViewControllerDelegate> _mailDelegate;
    id <MFMessageComposeViewControllerDelegate> _msgDelegate;

}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Item* detailItem;


@property (weak, nonatomic) IBOutlet UIImageView *priority0Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority1Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority2Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority3Image;


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *datePickerTool;
@property (strong, nonatomic) IBOutlet UIPickerView *durationPicker;
@property (strong, nonatomic) NSArray *durationPickerData;
@property (nonatomic, strong) id<MFMailComposeViewControllerDelegate> mailDelegate;
@property (nonatomic, strong) id<MFMessageComposeViewControllerDelegate> msgDelegate;



- (IBAction)changePriority:(id)sender;
- (IBAction)changeTitle:(id)sender;
- (IBAction)changeNote:(id)sender;
- (IBAction)changeDate:(id)sender;

- (IBAction)pressPickerDoneButton:(id)sender;


- (IBAction)didDoneButton:(id)sender;

- (IBAction)pressSaveButton:(id)sender;
- (IBAction)pressDeleteButton:(id)sender;
- (IBAction)pressSendButton:(id)sender;
//- (void)mailSent:(MFMailComposeResult)result;

@end
