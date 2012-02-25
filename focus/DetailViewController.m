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
@end

@implementation DetailViewController
@synthesize detailItem = _detailItem;
@synthesize titleTextField = _titleTextField;
@synthesize noteTextField = _noteTextField;
@synthesize prioritySegment = _prioritySegment;
@synthesize startDateTextField = _startDateTextField;
@synthesize dueDateTextField = _dueDateTextField;
@synthesize durationTextField = _durationTextField;
@synthesize datePicker = _datePicker;
@synthesize datePickerTool = _datePickerTool;


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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycleß

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.datePicker);
	// Do any additional setup after loading the view, typically from a nib.
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

#pragma mark - configure item
- (void)updateDate
{
    [self.startDateTextField setText:[self dateStringFromNSDate:[self.detailItem startDate]]];
    [self.dueDateTextField setText:[self dateStringFromNSDate:[self.detailItem dueDate]]];
    if ([self.detailItem duration] != nil) {
        [self.durationTextField setText:[NSString stringWithFormat:@"%d days", [self.detailItem.duration intValue] + 1]];
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
