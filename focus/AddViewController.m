//
//  AddViewController.m
//  focus
//
//  Created by Lancy on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddViewController.h"

@implementation AddViewController

@synthesize managedObjectContext;
@synthesize delegate = _delegate;

@synthesize titleLabel = _titleLabel;
@synthesize dueTimeLabel = _dueTimeLabel;
@synthesize notificationLabel = _notificationLabel;
@synthesize moreOptionLabel = _moreOptionLabel;
@synthesize titleField = _titleField;
@synthesize dueTimeFetchLabel = _dueTimeFetchLabel;
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
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// 按键done的事件响应函数入口，待修改。。
- (void)doneEvent:(id)sender {
    [self insertNewObject];
    [self.delegate AddViewControllerDidFinish:self];
    [self.navigationController popViewControllerAnimated:YES];
}


// 按键cancel的事件响应函数入口，待修改。。
- (void)cancelEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// UIDatePicker中用于隐藏picker的函数
// backgroundView中包含了picker和取消picker，确认picker的两个button
- (void)PickerCancel:(id)sender {
    [_backgroundView setHidden:YES];
}

// picker中用于确认picker的函数
- (void)PickerConfirm:(id)sender {    
    NSDate *date = [_datePicker date];
    // SetDateFormat自定义函数，用于字符化时间
    NSString *myString = [self SetDateFormat:date];
    // 设置dueTime的cell更新回显
    _dueTimeFetchLabel.text = myString;
    // 保存picker中的时间至holder中
    [textContentHolder setObject:date forKey:objectKey];
    // 设置picker显示
    [_backgroundView setHidden:YES];
}

/*
- (IBAction)saveItem:(id)sender {
    [self insertNewObject];
    [self.delegate AddViewControllerDidFinish:self];
    
}
 */


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


//Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_backgroundView setHidden:YES];
    textContentHolder = [[NSMutableDictionary alloc] initWithCapacity:2];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // grouped－style table view
    NSInteger rowNum = 0;
    switch (section) {
        case 0:
            rowNum = 1;
            break;
            
        case 1:
            rowNum = 3;
            
        default:
            break;
    }
    return rowNum;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *addBtnCellIdentifier = @"addBtnCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addBtnCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addBtnCellIdentifier];
    
    // 构建整个table view的表项目
    switch (indexPath.section) {
        case 0:
            // 设置新增项目标题
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 13, 50, 20)];
            [self SetLabelAttribution:_titleLabel];
            _titleLabel.text = @"Title";
            [cell addSubview:_titleLabel];
            
            _titleField = [[UITextField alloc] initWithFrame:CGRectMake(100, 11, 200, 20)];
            [self SetTextAttribution:_titleField]; 
            _titleField.text = [textContentHolder objectForKey:@"titleField"];
            _titleField.tag = 1;
            [cell addSubview:_titleField];
            break;
            
        case 1:
            // 设置截至时间
            if (indexPath.row == 0) {
                _dueTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_dueTimeLabel];
                _dueTimeLabel.text = @"Due Time";
                [cell addSubview:_dueTimeLabel];
                
                // 设置cell更新回显dueTime信息
                _dueTimeFetchLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13, 200, 20)];
                [self SetLabelAttribution:_dueTimeFetchLabel];
                NSDate *myDate = [textContentHolder objectForKey:@"dueTime"];
                _dueTimeFetchLabel.text = [self SetDateFormat:myDate];
                [cell addSubview:_dueTimeFetchLabel];
                
            } else if (indexPath.row == 1) {
                // 通知项目设置
                _notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_notificationLabel];
                _notificationLabel.text = @"Notification";
                [cell addSubview:_notificationLabel];
                
            } else {
                // 多选项设置
                _moreOptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 20)];
                [self SetLabelAttribution:_moreOptionLabel];
                _moreOptionLabel.text = @"More Options";
                [cell addSubview:_moreOptionLabel];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        // 优先级按键
        priorityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        priorityBtn.frame = CGRectMake(20, 80 , 80, 40);
        [priorityBtn setTitle:@"Priority" forState:UIControlStateNormal];
        [tableView addSubview:priorityBtn];
        
        // 项目按键
        projectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        projectBtn.frame = CGRectMake(220, 80, 80, 40);
        [projectBtn setTitle:@"Project" forState:UIControlStateNormal];
        [tableView addSubview:projectBtn];
    }
    else if (section == 2) {
        // 发送按键
        sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sendBtn.frame = CGRectMake(20, 280, 80, 40);
        [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
        [tableView addSubview:sendBtn];
        
        // 删除按键
        deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteBtn.frame = CGRectMake(220, 280, 80, 40);
        [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [tableView addSubview:deleteBtn];
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // objectKey是获取回显信息的关键字
    if (indexPath.section == 0 && indexPath.row == 0) {
        objectKey = @"titleField";
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        objectKey = @"dueTime";
        [_backgroundView setHidden:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)insertNewObject
{
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"creatTime"];
    [newManagedObject setValue:@"no title" forKey:@"title"];
    [newManagedObject setValue:[NSDate date] forKey:@"dueDate"];
    [newManagedObject setValue:[NSNumber numberWithInt:1] forKey:@"priority"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma UserDefined Function

// 设置文本输入框的初始化属性
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
    }
    
    //[textContentHolder setObject:textContent forKey:objectKey];
    /*
     * 测试用例
     NSLog(@"%@", textContentHolder);
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
