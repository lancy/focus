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
- (void)configureItem;
- (NSString *)dateStringFromNSDate:(NSDate *)date;
- (void)updateDate;
- (void)deleteItem;
@end

@implementation DetailViewController

@synthesize managedObjectContext;
@synthesize detailItem = _detailItem;
@synthesize titleTextField = _titleTextField;
@synthesize noteTextField = _noteTextField;
@synthesize prioritySegment = _prioritySegment;
@synthesize startDateTextField = _startDateTextField;
@synthesize dueDateTextField = _dueDateTextField;
@synthesize durationTextField = _durationTextField;
@synthesize datePicker = _datePicker;
@synthesize datePickerTool = _datePickerTool;
@synthesize durationPicker = _durationPicker;
@synthesize durationPickerData = _durationPickerData;
@synthesize mailDelegate = _mailDelegate;



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

#pragma mark - Alert methods
#pragma mark Mail controller delegates

- (void)mailSent:(MFMailComposeResult)result {
    //manage mail result
    NSLog(@"Mail %@ sent", (result == MFMailComposeResultSent)? @"" : @"NOT");
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (self.mailDelegate && [self.mailDelegate respondsToSelector:@selector(shareWithEmail:)]) {
        [self mailSent:result];
    }
    [controller dismissModalViewControllerAnimated:YES];
}



- (void)shareWithSMS {
    ;
}

- (void)shareWithEmail {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:[NSString stringWithString:self.detailItem.title]];
    [mc setMessageBody:[NSString stringWithFormat:@"%@  \nThis Email was sent by focus.", self.detailItem.note] isHTML:NO];
    
    [mc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    if (mc) {
        [self presentModalViewController:mc animated:YES];
    }
}

- (void)copyToClipboard {
    ;
}


#pragma mark - Managing the detail item

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)deleteItem
{
    // Delete the managed object for the given index path
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:self.detailItem];
    
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

- (IBAction)pressDeleteButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Item" message:@"Are You Sure?" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Delete", nil];
    [alert setTag:2000];
    [alert show];
}

- (IBAction)pressSendButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send" message:@"msg" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"SMS", @"Facebook", nil];
    [alert setTag:2001];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int tag = alertView.tag;
    if (tag == 2000) {
        switch (buttonIndex) {
            case 0:
                //cancle
                break;
            case 1:
                //delete item
                [self deleteItem];
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
                
            default:
                break;
        }
    }
    if (tag == 2001) {
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
                [self shareWithEmail];
                break;
            case 2:
                // other
                NSLog(@"Test alertview selection.");
                break;
                
            default:
                break;
        }
    }
}




#pragma mark - View lifecycleß

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.datePicker);
	
    NSArray *array = [[NSArray alloc] initWithObjects:@"less than one day", @"1 day", @"2 days", @"3 days", @"5 days", @"1 week", @"1 month", @"3 month", nil];
    self.durationPickerData = array;
}

- (void)viewDidUnload
{

    [self setTitleTextField:nil];
    [self setNoteTextField:nil];
    [self setPrioritySegment:nil];
    [self setStartDateTextField:nil];
    [self setDueDateTextField:nil];
    [self setDurationTextField:nil];
    [self setDatePicker:nil];
    [self setDatePickerTool:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureItem];
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


#pragma mark Picker Data Source Methods
/* returns the number of 'columns' to display.*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.durationPickerData count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 52.0f;
}

#pragma mark Picker Delegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.durationPickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.durationTextField setText:[self.durationPickerData objectAtIndex:row]];
}


#pragma mark - configure item
- (void)updateDate
{
    [self.startDateTextField setText:[self dateStringFromNSDate:[self.detailItem startDate]]];
    [self.dueDateTextField setText:[self dateStringFromNSDate:[self.detailItem dueDate]]];
    if ([self.detailItem duration] != nil) {
        if ([self.detailItem.duration intValue] == 0)
            [self.durationTextField setText:@"less than one day"];
        else if ([self.detailItem.duration intValue] == 1)
            [self.durationTextField setText:[NSString stringWithFormat:@"1 day", [self.detailItem.duration intValue]]];
        else
            [self.durationTextField setText:[NSString stringWithFormat:@"%d days", [self.detailItem.duration intValue]]];

    } else 
    {
        [self.durationTextField setText:nil];
    }
    
}

- (void)configureItem
{
    [self.titleTextField setText:[self.detailItem title]];
    [self.noteTextField setText:[self.detailItem note]];
    [self.prioritySegment setSelectedSegmentIndex:[self.detailItem.priority integerValue]];
    //[self.detailItem setStartDate:[NSDate date]];  // set startdate to today once loaded
    [self updateDate];
}


#pragma mark - change item

- (IBAction)changePriority:(id)sender {
    [self.detailItem setPriority:[NSNumber numberWithInteger:[self.prioritySegment selectedSegmentIndex]]];
    NSLog(@"%@", self.detailItem.priority);
}

- (IBAction)changeTitle:(id)sender {
    [self.detailItem setTitle:[self.titleTextField text]];
    NSLog(@"%@", self.detailItem.title);
}

- (IBAction)changeNote:(id)sender {
    [self.detailItem setNote:[self.noteTextField text]];
    NSLog(@"%@", self.detailItem.note);
}

- (IBAction)changeDate:(id)sender {
    if ([self.dueDateTextField isFirstResponder]) {
        [self.detailItem setDueDate:[sender date]];
        self.dueDateTextField.text = [self dateStringFromNSDate:[sender date]];
    }
    else if([self.startDateTextField isFirstResponder]) {
        [self.detailItem setStartDate:[sender date]];
        self.startDateTextField.text = [self dateStringFromNSDate:[sender date]];
    }
    [self updateDate];
}

- (IBAction)pressPickerDoneButton:(id)sender {
    if ([self.dueDateTextField isFirstResponder]) {
        [self.detailItem setDueDate:[self.datePicker date]];
        self.dueDateTextField.text = [self dateStringFromNSDate:[self.datePicker date]];
        [self.dueDateTextField resignFirstResponder];
    }
    else if([self.startDateTextField isFirstResponder])
    {
        [self.detailItem setStartDate:[self.datePicker date]];
        self.startDateTextField.text = [self dateStringFromNSDate:[self.datePicker date]];
        [self.startDateTextField resignFirstResponder];
    }
    else if ([self.durationTextField isFirstResponder]) {
        //@"1 day", @"2 days", @"3 days", @"5 days", @"1 week", @"1 month", @"3 month"
        NSString *duration = [[NSString alloc] initWithString:[self.durationTextField text]];
        if ([duration isEqualToString:@"less than one day"]) {
            [self.detailItem setDuration:[NSNumber numberWithInt:0]];
        }
        if ([duration isEqualToString:@"1 day"]) {
            [self.detailItem setDuration:[NSNumber numberWithInt:1]];
        }
        if ([duration isEqualToString:@"2 days"]) {
            [self.detailItem setDuration:[NSNumber numberWithInt:2]];
        }
        if ([duration isEqualToString:@"3 days"]) {
            [self.detailItem setDuration:[NSNumber numberWithInt:3]];
        }
        if ([duration isEqualToString:@"5 days"]) {
            [self.detailItem setDuration:[NSNumber numberWithInt:5]];
        }
        if ([duration isEqualToString:@"1 week"]) {
            [self.detailItem setDuration:[NSNumber numberWithInt:7]];
        }
        if ([duration isEqualToString:@"1 month"]) {
            [self.detailItem setDuration:[NSNumber numberWithInt:30]];
        }
        if ([duration isEqualToString:@"3 month"]) {
            [self.detailItem setDuration:[NSNumber numberWithInt:90]];
        }
        [self.durationTextField resignFirstResponder];
    }
    [self updateDate];
}

- (IBAction)didDoneButton:(id)sender {
    [self resignFirstResponder];
}


#pragma mark - textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == [self dueDateTextField]) {
        if (textField.inputView == nil) {
            textField.inputView = self.datePicker;
        }
        if ([self.detailItem dueDate] != nil) {
            [self.datePicker setDate:[self.detailItem dueDate] animated:YES];
        }
        if (textField.inputAccessoryView == nil)
        {
            textField.inputAccessoryView = self.datePickerTool;
        }
    } 
    else if (textField == [self startDateTextField])
    {
        if (textField.inputView == nil) {
            textField.inputView = self.datePicker;
        }
        if ([self.detailItem startDate] != nil) {
            [self.datePicker setDate:[self.detailItem startDate] animated:YES];
        }
        if (textField.inputAccessoryView == nil)
        {
            textField.inputAccessoryView = self.datePickerTool;
        }
    }
    else if (textField == [self durationTextField]){
        if (textField.inputView == nil) {
            [self.durationPicker setFrame:CGRectMake(0, 0, 216, 320)];
            self.durationPicker.delegate = self;
            self.durationPicker.dataSource = self;
            self.durationPicker.showsSelectionIndicator = YES;
            [self.durationPicker selectRow:0 inComponent:0 animated:YES];
            [self.durationTextField setText:@"less than 1 day"];
            textField.inputView = self.durationPicker;
        }
        if (textField.inputAccessoryView == nil) {
            textField.inputAccessoryView = self.datePickerTool;
        }
    }
    return YES;
}

#pragma mark - transform methods
- (NSString *)dateStringFromNSDate:(NSDate *)date
{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [dayFormatter setLocale:[NSLocale currentLocale]];
    [dayFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dayFormatter setDoesRelativeDateFormatting:YES];
    
    return [dayFormatter stringFromDate:date];
}



#pragma mark - back to root
- (IBAction)pressSaveButton:(id)sender {
    if ([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
    } 
    else if ([self.noteTextField isFirstResponder])
    {
        [self.noteTextField resignFirstResponder];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
