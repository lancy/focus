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


@interface AddViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate> {
    // Labels
    UILabel *titleLabel;
    UILabel *dueTimeLabel;
    UILabel *notificationLabel;
    UILabel *moreOptionLabel;
    UILabel *dueTimeFetchLabel;
    
    // TextFields
    UITextField *titleField;
    
    // Buttons
    UIButton *priorityBtn;
    UIButton *projectBtn;
    UIButton *sendBtn;
    UIButton *deleteBtn;
    UIButton *pickerCancelBtn;
    
    // Others
    UIDatePicker *datePicker;
    UIView *backgroundView;
    NSString *textContent;
    NSString *objectKey;
    NSMutableDictionary *textContentHolder;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet id <AddViewControllerDelegate> delegate;

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *dueTimeLabel;
@property (retain, nonatomic) UILabel *notificationLabel;
@property (retain, nonatomic) UILabel *moreOptionLabel;
@property (retain, nonatomic) UILabel *dueTimeFetchLabel;
@property (retain, nonatomic) UITextField *titleField;
@property (retain, nonatomic) UIButton *priorityBtn;
@property (retain, nonatomic) UIButton *projectBtn;
@property (retain, nonatomic) UIButton *sendBtn;
@property (retain, nonatomic) UIButton *deleteBtn;
@property (retain, nonatomic) IBOutlet UIButton *pickerCancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *pickerConfirmBtn;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UIView *backgroundView;


- (void)insertNewObject;
//- (IBAction)saveItem:(id)sender;

// ibaction函数集
- (IBAction)doneEvent:(id)sender;
- (IBAction)cancelEvent:(id)sender;
- (IBAction)PickerCancel:(id)sender;
- (IBAction)PickerConfirm:(id)sender;

// 自定义函数
- (void)SetLabelAttribution:(UILabel *)myLabel;
- (void)SetTextAttribution:(UITextField *)myTextField;
- (NSString *)SetDateFormat:(NSDate *)myDate;

@end
