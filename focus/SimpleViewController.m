//
//  SimpleViewController.m
//  focus
//
//  Created by Lancy on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SimpleViewController.h"
#import "Item.h"

@interface SimpleViewController ()
- (void)configureItem;
- (NSString *)dateStringFromNSDate:(NSDate *)date;
- (void)creatNewItem;
- (void)deleteItem;
- (void)updateDate;
- (void)configurePriority;
@end

@implementation SimpleViewController

@synthesize isAdd = _isAdd;
@synthesize managedObjectContext;
@synthesize detailItem = _detailItem;
@synthesize titleTextField = _titleTextField;
@synthesize prioritySegment = _prioritySegment;
@synthesize dueDateTextField = _dueDateTextField;
@synthesize datePicker = _datePicker;
@synthesize datePickerTool = _datePickerTool;
@synthesize priority0Image = _priority0Image;
@synthesize priority1Image = _priority1Image;
@synthesize priority2Image = _priority2Image;
@synthesize priority3Image = _priority3Image;



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

#pragma mark - Managing the detail item

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)creatNewItem
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    
    [newManagedObject setValue:[NSDate date] forKey:@"creatTime"];
    
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
    
    self.detailItem =(Item* )newManagedObject;
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
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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


#pragma mark - View lifecycleß

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidUnload
{
    
    [self setTitleTextField:nil];
    [self setPrioritySegment:nil];
    [self setDueDateTextField:nil];
    [self setDatePicker:nil];
    [self setDatePickerTool:nil];
    [self setPriority0Image:nil];
    [self setPriority1Image:nil];
    [self setPriority2Image:nil];
    [self setPriority3Image:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    NSLog(@"%d", self.isAdd);
    if (self.isAdd == NO)
    {
        [self configureItem];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isAdd == YES) {
        [self creatNewItem];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)updateDate
{
    [self.dueDateTextField setText:[self dateStringFromNSDate:[self.detailItem dueDate]]];
}

- (void)configurePriority
{
    [self.priority0Image setHighlighted:NO];
    [self.priority1Image setHighlighted:NO];
    [self.priority2Image setHighlighted:NO];
    [self.priority3Image setHighlighted:NO];
    switch ([[self.detailItem priority] intValue]) {
        case 0:
            [self.priority0Image setHighlighted:YES];
            [self.priority1Image setHighlighted:NO];
            [self.priority2Image setHighlighted:NO];
            [self.priority3Image setHighlighted:NO];
            break;
        case 1:
            [self.priority0Image setHighlighted:NO];
            [self.priority1Image setHighlighted:YES];
            [self.priority2Image setHighlighted:NO];
            [self.priority3Image setHighlighted:NO];
            break;
        case 2:
            [self.priority0Image setHighlighted:NO];
            [self.priority1Image setHighlighted:NO];
            [self.priority2Image setHighlighted:YES];
            [self.priority3Image setHighlighted:NO];
            break;
        case 3:
            [self.priority0Image setHighlighted:NO];
            [self.priority1Image setHighlighted:NO];
            [self.priority2Image setHighlighted:NO];
            [self.priority3Image setHighlighted:YES];
            break;
        default:
            break;
    }
}

- (void)configureItem
{
    [self.titleTextField setText:[self.detailItem title]];
//    [self.noteTextField setText:[self.detailItem note]];
//    [self.prioritySegment setSelectedSegmentIndex:[self.detailItem.priority integerValue]];
    [self configurePriority];
    [self updateDate];
}


#pragma mark - change item

- (IBAction)changePriority:(id)sender {
    [self.detailItem setPriority:[NSNumber numberWithInteger:[self.prioritySegment selectedSegmentIndex]]];
    [self configurePriority];
    NSLog(@"%@", self.detailItem.priority);
}

- (IBAction)changeTitle:(id)sender {
    [self.detailItem setTitle:[self.titleTextField text]];
    NSLog(@"%@", self.detailItem.title);
}


- (IBAction)changeDate:(id)sender {
    if ([self.dueDateTextField isFirstResponder]) {
        [self.detailItem setDueDate:[sender date]];
        self.dueDateTextField.text = [self dateStringFromNSDate:[sender date]];
    }
}

- (IBAction)pressPickerDoneButton:(id)sender {
    if ([self.dueDateTextField isFirstResponder]) {
        [self.detailItem setDueDate:[self.datePicker date]];
        self.dueDateTextField.text = [self dateStringFromNSDate:[self.datePicker date]];
        [self.dueDateTextField resignFirstResponder];
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



#pragma mark - view transition
- (IBAction)pressSaveButton:(id)sender {
    if ([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
    } 
    if ([self.detailItem title] == nil
        || [[self.detailItem title] isEqualToString:@""])
    {
        [self deleteItem];
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%@", self.detailItem);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"moreOptions"])
    {
        [segue.destinationViewController setValue:self.detailItem forKey:@"detailItem"];
    }
}


@end