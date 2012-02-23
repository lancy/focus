//
//  DetailViewController.m
//  test
//
//  Created by Lan Chenyu on 28/01/2012.
//  Modified by Palibox on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize titleLabel = _titleLabel;
@synthesize noteLabel = _noteLabel;
@synthesize startTimeLabel = _startTimeLabel;
@synthesize startTimeFetchLabel = _startTimeFetchLabel;
@synthesize dueTimeLabel = _dueTimeLabel;
@synthesize dueTimeFetchLabel = _dueTimeFetchLabel;
@synthesize duringLabel = _duringLabel;
@synthesize notificationLabel = _notificationLabel;
@synthesize repeatLabel = _repeatLabel;
@synthesize tagLabel = _tagLabel;
@synthesize titleField = _titleField;
@synthesize noteField = _noteFiled;
@synthesize priorityBtn = _priorityBtn;
@synthesize projectBtn = _projectBtn;
@synthesize sendBtn = _sendBtn;
@synthesize deleteBtn = _deleteBtn;
@synthesize pickerCancelBtn = _pickerCancelBtn;
@synthesize pickerConfirmBtn = _pickerConfirmBtn;
@synthesize datePicker = _datePicker;
@synthesize backgroundView = _backgroundView;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

// 功能不详，有待了解
- (void)configureView
{
    // Update the user interface for the detail item.
    if ([self.detailItem dueDate] != nil)
    {
        
        [self.datePicker setDate:[self.detailItem dueDate]]; 
    }
    
    if ([self.detailItem title] != nil)
    {
        [self.titleField setText:[self.detailItem title]];
    }
    
    /*
     if (self.detailItem) {
     self.detailDescriptionLabel.text = [[self.detailItem dueDate] description];
     }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

// 设置隐藏picker
- (void)PickerCancel:(id)sender {
    [_backgroundView setHidden:YES];
}

// picker数据确认
- (void)PickerConfirm:(id)sender {
    // 获取picker时间
    NSDate *date = [_datePicker date];
    // 将时间转换为字符串
    NSString *myString = [self SetDateFormat:date];
    // choiceSwitch用以判断回显哪一个label
    (choiceSwitch == 0) ? (_startTimeFetchLabel.text = myString) : (_dueTimeFetchLabel.text = myString);
    // 将NSDate数据存入holder中以便调用
    [textContentHolder setObject:date forKey:objectKey];
    // 设置picker隐藏
    [_backgroundView setHidden:YES];
}

- (IBAction)Save:(id)sender {
    [self.detailItem setStartDate:[textContentHolder objectForKey:@"startTime"]];
    [self.detailItem setDueDate:[textContentHolder objectForKey:@"dueTime"]];
    [self.detailItem setTitle:[textContentHolder objectForKey:@"titleField"]];
    [self.detailItem setNote:[textContentHolder objectForKey:@"noteField"]];
    /*
     * 测试用例
     NSLog(@"%@, %@, %@, %@", [self.detailItem startDate], [self.detailItem dueDate], [self.detailItem title], [self.detailItem note]);
     * 经测试输出正确，说明已经保存在detailItem，可以和lancy的数据整合
     */
}


#pragma mark - View lifecycleß

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    choiceSwitch = -1;
    textContentHolder = [[NSMutableDictionary alloc] initWithCapacity:4];
    [self configureView];   // Mark!!
    [_backgroundView setHidden:YES];
}

- (void)viewDidUnload
{
    self.datePicker = nil;
    self.titleField = nil;
    // 各种等于nil，记得补全
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    switch (section) {
        case 0:
            rowNum = 2;
            break;
            
        case 1:
        case 2:
            rowNum = 3;
            break;
            
        default:
            break;
    }
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *DetailCellIdentifier = @"DetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifier];
    
    // 添加每一section的每一row內容
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 13, 50, 20)];
                [self SetLabelAttribution:_titleLabel];
                _titleLabel.text = @"Title";
                [cell addSubview:_titleLabel];
                
                _titleField = [[UITextField alloc] initWithFrame:CGRectMake(100, 11, 200, 20)];
                [self SetTextAttribution:_titleField];
                _titleField.text = [textContentHolder objectForKey:@"titleField"];
                _titleField.tag = 1;
                [cell addSubview:_titleField];
                
            } else {
                _noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 13, 50, 20)];
                [self SetLabelAttribution:_noteLabel];
                _noteLabel.text = @"Note";
                [cell addSubview:_noteLabel];
                
                _noteFiled = [[UITextField alloc] initWithFrame:CGRectMake(100, 11, 200, 20)];
                [self SetTextAttribution:_noteFiled];  
                _noteFiled.text = [textContentHolder objectForKey:@"noteField"];
                _noteFiled.tag = 2;
                [cell addSubview:_noteFiled];
            }
            break;
            
        case 1:
            if (indexPath.row == 0) {
                _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_startTimeLabel];
                _startTimeLabel.text = @"Start Time";
                [cell addSubview:_startTimeLabel];
                
                _startTimeFetchLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13, 200, 20)];
                [self SetLabelAttribution:_startTimeFetchLabel];
                NSDate *myDate = [textContentHolder objectForKey:@"startTime"];
                _startTimeFetchLabel.text = [self SetDateFormat:myDate];
                [cell addSubview:_startTimeFetchLabel];
                
            } else if (indexPath.row == 1) {
                _dueTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_dueTimeLabel];
                _dueTimeLabel.text = @"Due Time";
                [cell addSubview:_dueTimeLabel];
                
                _dueTimeFetchLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13, 200, 20)];
                [self SetLabelAttribution:_dueTimeFetchLabel];
                NSDate *myDate = [textContentHolder objectForKey:@"dueTime"];
                _dueTimeFetchLabel.text = [self SetDateFormat:myDate];   
                [cell addSubview:_dueTimeFetchLabel];
                
            } else {
                _duringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_duringLabel];
                _duringLabel.text = @"During";
                [cell addSubview:_duringLabel];
            }
            break;
            
        case 2:
            if (indexPath.row == 0) {
                _notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_notificationLabel];
                _notificationLabel.text = @"Notification";
                [cell addSubview:_notificationLabel];
                
            } else if (indexPath.row == 1) {
                _repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_repeatLabel];
                _repeatLabel.text = @"Repeat";
                [cell addSubview:_repeatLabel];
                
            } else {
                _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_tagLabel];
                _tagLabel.text = @"Tag";
                [cell addSubview:_tagLabel];
                
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 20;
    else if (section == 2)
        return  10;
    else
        return 60;
}


// 用来添加各种button，呵呵
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        priorityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        priorityBtn.frame = CGRectMake(20, 125 , 80, 40);
        [priorityBtn setTitle:@"Priority" forState:UIControlStateNormal];
        [tableView addSubview:priorityBtn];
        
        projectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        projectBtn.frame = CGRectMake(220, 125, 80, 40);
        [projectBtn setTitle:@"Project" forState:UIControlStateNormal];
        [tableView addSubview:projectBtn];
    }
    else if (section == 3) {
        sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sendBtn.frame = CGRectMake(20, 480, 80, 40);
        [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
        [tableView addSubview:sendBtn];
        
        deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteBtn.frame = CGRectMake(220, 480, 80, 40);
        [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [tableView addSubview:deleteBtn];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                objectKey = @"titleField";
                break;
                
            case 1:
                objectKey = @"noteField";
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                choiceSwitch = 0; 
                [_backgroundView setHidden:NO];
                objectKey = @"startTime";
                break;
                
            case 1:
                choiceSwitch = 1;
                [_backgroundView setHidden:NO];
                objectKey = @"dueTime";
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
     * 测试用例
     NSLog(@"Did Select Row, %@, %d", objectKey, choiceSwitch);
     NSLog(@"%@", objectKey);
     *
     */
}

// 设置文本输入框的初始化属性
#pragma UserDefined Function
- (void)SetTextAttribution:(UITextField *)myTextField {
    myTextField.placeholder = @"< Hello, write here ! >";
    myTextField.autocorrectionType = UITextAutocorrectionTypeYes;
    myTextField.returnKeyType = UIReturnKeyDone;
    myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    myTextField.delegate = self;
}

// 设置标识的初始化属性
- (void)SetLabelAttribution:(UILabel *)myLabel {
    myLabel.textAlignment = UITextAlignmentLeft;
    myLabel.textColor = [UIColor purpleColor];
    myLabel.font = [UIFont systemFontOfSize:16.0];
}

// 设置时间的显示格式
- (NSString *)SetDateFormat:(NSDate *)myDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:myDate];
    
}

#pragma UITextViewDelegate

// 当文本输入的done按键按下时重置firstresponder
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  YES;
}

// 当文本输入的done按键按下时获取文本字符，tag用以区别若干个textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    textContent = textField.text;
    if (textField.tag == 1) {
        [textContentHolder setObject:textContent forKey:@"titleField"];
        objectKey = @"titleField";
    } else if (textField.tag == 2) {
        [textContentHolder setObject:textContent forKey:@"noteField"];
        objectKey = @"noteField";
    }
    /*
     * 测试用例
     NSLog(@"Field did end editing, %@, %@", objectKey, textContent);
     *
     */
}


#pragma UIAlertView

// 当alertview的cancel button按下时modal－view controller消失
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
