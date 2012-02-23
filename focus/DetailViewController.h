//
//  DetailViewController.h
//  test
//
//  Created by Lan Chenyu on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "item.h"


#import <UIKit/UIKit.h>
#import "item.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate> {
    // Labels
    UILabel *titleLabel;
    UILabel *noteLabel;
    UILabel *startTimeLabel;
    UILabel *dueTimeLabel;
    UILabel *duringLabel;
    UILabel *notificationLabel;
    UILabel *repeatLabel;
    UILabel *tagLabel;
    
    // Fields
    UITextField *titleField;
    UITextField *noteField;
    
    // Buttons
    UIButton *priorityBtn;
    UIButton *projectBtn;
    UIButton *sendBtn;
    UIButton *deleteBtn;
    UIButton *pickerCancelBtn;
    UIButton *pickerConfirmBtn;
    
    // Others
    UIDatePicker *datePicker;
    UIView *backgroundView;
    NSInteger choiceSwitch;
    NSString *textContent;
    NSString *objectKey;
    NSMutableDictionary *textContentHolder;
}


@property (strong, nonatomic) Item* detailItem;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *noteLabel;
@property (retain, nonatomic) UILabel *startTimeLabel;
@property (retain, nonatomic) UILabel *startTimeFetchLabel;
@property (retain, nonatomic) UILabel *dueTimeLabel;
@property (retain, nonatomic) UILabel *dueTimeFetchLabel;
@property (retain, nonatomic) UILabel *duringLabel;
@property (retain, nonatomic) UILabel *notificationLabel;
@property (retain, nonatomic) UILabel *repeatLabel;
@property (retain, nonatomic) UILabel *tagLabel;
@property (retain, nonatomic) UITextField *titleField;
@property (retain, nonatomic) UITextField *noteField;
@property (retain, nonatomic) UIButton *priorityBtn;
@property (retain, nonatomic) UIButton *projectBtn;
@property (retain, nonatomic) UIButton *sendBtn;
@property (retain, nonatomic) UIButton *deleteBtn;
@property (retain, nonatomic) IBOutlet UIButton *pickerCancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *pickerConfirmBtn;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UIView *backgroundView;

// IBAction函数集
- (IBAction)Save:(id)sender;
- (IBAction)PickerCancel:(id)sender;
- (IBAction)PickerConfirm:(id)sender;

// 自定义函数集
- (void)SetLabelAttribution:(UILabel *)myLabel;
- (void)SetTextAttribution:(UITextField *)myTextField;
- (NSString *)SetDateFormat:(NSDate *)myDate;

@end
