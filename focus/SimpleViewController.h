//
//  SimpleViewController.h
//  focus
//
//  Created by Lancy on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "item.h"
#import <MessageUI/MessageUI.h>


@interface SimpleViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
    UIDatePicker *_datePicker;
    
}


@property BOOL isAdd;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Item* detailItem;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *notificationTextField;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (weak, nonatomic) IBOutlet UIButton *SomedayButton;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *datePickerTool;
@property (strong, nonatomic) IBOutlet UIDatePicker *notificationDatePicker;


@property (weak, nonatomic) IBOutlet UIImageView *priority0Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority1Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority2Image;
@property (weak, nonatomic) IBOutlet UIImageView *priority3Image;

@property (nonatomic, strong) id<MFMailComposeViewControllerDelegate> mailDelegate;
@property (nonatomic, strong) id<MFMessageComposeViewControllerDelegate> msgDelegate;




- (IBAction)changePriority:(id)sender;
- (IBAction)changeTitle:(id)sender;
- (IBAction)changeDate:(id)sender;
- (IBAction)changeFinished:(id)sender;
- (IBAction)changeSomeday:(id)sender;

- (IBAction)pressPickerDoneButton:(id)sender;
- (IBAction)pressPickerStopButton:(id)sender;


- (IBAction)didDoneButton:(id)sender;

- (IBAction)pressDeleteButton:(id)sender;

- (IBAction)pressSaveButton:(id)sender;
- (IBAction)pressSendButton:(id)sender;

@end
