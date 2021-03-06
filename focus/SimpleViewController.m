//
//  SimpleViewController.m
//  focus
//
//  Created by Lancy on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SimpleViewController.h"
#import "DetailViewController.h"
#import "Item.h"

@interface SimpleViewController ()
- (void)configureItem;
- (NSString *)dateStringFromNSDate:(NSDate *)date;
- (NSString *)timeStringFromNSDate:(NSDate *)date;
- (void)creatNewItem;
- (void)deleteItem;
- (void)updateDate;
- (void)configurePriority;
- (NSString *)messageToSend;
- (void) scheduleAlarm:(NSDate *) aDate;

@end

@implementation SimpleViewController

@synthesize isAdd = _isAdd;
@synthesize managedObjectContext;
@synthesize detailItem = _detailItem;
@synthesize titleImageView = _titleImageView;
@synthesize titleTextField = _titleTextField;
@synthesize prioritySegment = _prioritySegment;
@synthesize dueDateTextField = _dueDateTextField;
@synthesize notificationTextField = _notificationTextField;
@synthesize finishedButton = _finishedButton;
@synthesize SomedayButton = _SomedayButton;
@synthesize datePicker = _datePicker;
@synthesize datePickerTool = _datePickerTool;
@synthesize notificationDatePicker = _notificationDatePicker;
@synthesize priority0Image = _priority0Image;
@synthesize priority1Image = _priority1Image;
@synthesize priority2Image = _priority2Image;
@synthesize priority3Image = _priority3Image;
@synthesize mailDelegate = _mailDelegate;
@synthesize msgDelegate = _msgDelegate;



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

#pragma mark - Mail/SMS controller delegates

- (NSString *) messageToSend{
    
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:@"Please finish the task: %@",[self detailItem].title ];
    if ([self detailItem].dueDate != nil) {
        [message appendFormat:@". The deadline is %@",  [self dateStringFromNSDate:[self detailItem].dueDate]];
    }
    
    if ([self detailItem].note != nil)
        [message appendFormat:@". Note: %@", [self detailItem].note];
    
    [message appendFormat:@"."];
    
    NSLog(@"%@", message);
    return message;
    
}


- (void)mailSent:(MFMailComposeResult)result {
    //manage mail result
    NSLog(@"Mail %@ sent", (result == MFMailComposeResultSent)? @"" : @"NOT");
}

- (void)smsSent:(MessageComposeResult)result {
    //manage mail result
    NSLog(@"Mail %@ sent", (result == MFMailComposeResultSent)? @"" : @"NOT");
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (self.mailDelegate && [self.mailDelegate respondsToSelector:@selector(shareWithEmail:)]) {
        [self mailSent:result];
    }
    // fixed the navagation bar;
    UIImage *navigationbg = [UIImage imageNamed:@"navigation"];
    [[UINavigationBar appearance] setBackgroundImage:navigationbg forBarMetrics:UIBarMetricsDefault];
    
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (self.msgDelegate && [self.msgDelegate respondsToSelector:@selector(shareViaSMS:)]) {
        [self smsSent:result];
    }
    // fixed the navagation bar;
    UIImage *navigationbg = [UIImage imageNamed:@"navigation"];
    [[UINavigationBar appearance] setBackgroundImage:navigationbg forBarMetrics:UIBarMetricsDefault];
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)shareViaSMS {
    MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
    mc.messageComposeDelegate = self;
    [mc setTitle:@"focus"];
    [mc setBody:[self messageToSend]];
    [mc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    if (mc) {
        // fixed the navagation bar;
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        [self presentModalViewController:mc animated:YES];
    }
}

- (void)shareViaEmail {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:[NSString stringWithString:self.detailItem.title]];
    [mc setMessageBody:[NSString stringWithFormat:@"%@  \nThis Email was sent by focus.", [self messageToSend]] isHTML:NO];
    
    [mc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    if (mc) {
        
        // fixed the navagation bar;
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        [self presentModalViewController:mc animated:YES];
    }
}

- (void)copyToClipboard {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[self messageToSend]];
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
    if ([self.detailItem alarm] != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:[self.detailItem alarm]];
    }
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

- (IBAction)pressSendButton:(id)sender {
    
    if ([self detailItem].title != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send" message:@"msg" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Share via Email",@"Send SMS", @"Copy to Clipboard", nil];
        [alert setTag:2001];
        [alert show];
        
    }
}

- (IBAction)pressDeleteButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Item" message:@"Are You Sure?" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Delete", nil];
    [alert setTag:2000];
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
        [self messageToSend];
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
                [self shareViaEmail];
                break;
            case 2:
                [self shareViaSMS];
            case 3:
                [self copyToClipboard];
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
    [self setNotificationDatePicker:nil];
    [self setNotificationTextField:nil];
    [self setFinishedButton:nil];
    [self setSomedayButton:nil];
    [self setTitleImageView:nil];
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
        // highlighted is add title image
        [self.titleImageView setHighlighted:NO];
        [self configureItem];
    } 
    else
    {
        [self.titleImageView setHighlighted:YES];
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
    [self.notificationTextField setText:[self timeStringFromNSDate:[[self.detailItem alarm] valueForKey:@"fireDate"]]];
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
    [self.finishedButton setSelected:[[self.detailItem finished] boolValue]];
    [self.SomedayButton setSelected:[[self.detailItem isSomeday] boolValue]];
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

- (IBAction)changeFinished:(id)sender {
    BOOL toggle = ![[self.detailItem finished] boolValue];
    [self.detailItem setFinished:[NSNumber numberWithBool:toggle]];
    [self configureItem];
}

- (IBAction)changeSomeday:(id)sender {
    BOOL toggle = ![[self.detailItem isSomeday] boolValue];
    [self.detailItem setIsSomeday:[NSNumber numberWithBool:toggle]];
    [self configureItem];
}

- (IBAction)pressPickerDoneButton:(id)sender {
    if ([self.dueDateTextField isFirstResponder]) {
        [self.detailItem setDueDate:[self.datePicker date]];
        self.dueDateTextField.text = [self dateStringFromNSDate:[self.datePicker date]];
        [self.dueDateTextField resignFirstResponder];
    }
    if ([self.notificationTextField isFirstResponder]) {
        [self scheduleAlarm:[self.notificationDatePicker date]];
        [self.notificationTextField resignFirstResponder];
    }
    [self updateDate];
}

- (IBAction)pressPickerStopButton:(id)sender {
    if ([self.dueDateTextField isFirstResponder]) {
        [self.detailItem setDueDate:nil];
        [self.dueDateTextField resignFirstResponder];
    }
    else if ([self.notificationTextField isFirstResponder]) {
        if ([self.detailItem alarm] != nil) {
            [[UIApplication sharedApplication] cancelLocalNotification:[self.detailItem alarm]];
        }
        [self.detailItem setAlarm:nil];
        
        [self.notificationTextField resignFirstResponder];
    }
    [self updateDate];
}


- (IBAction)didDoneButton:(id)sender {
    [self resignFirstResponder];
}

#pragma mark - notification
- (void) scheduleAlarm:(NSDate *) aDate
{
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	
	// Break the date up into components
	NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) 
												   fromDate:aDate];
	NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) 
												   fromDate:aDate];
	
	// Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
	// Notification will fire in one minute
    [dateComps setMinute:[timeComponents minute]];
	[dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
	
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
	
	// Notification details
    localNotif.alertBody = [NSString stringWithFormat:@"%@\n%@", [self.detailItem title], [self.detailItem note]];
	// Set the action button
    localNotif.alertAction = @"Focus";
	
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    //    localNotif.applicationIconBadgeNumber = 1;
	
	// Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
	
	// Schedule the notification
    if ([self.detailItem alarm] != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:[self.detailItem alarm]];
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [self.detailItem setAlarm:localNotif];
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
    else if (textField == [self notificationTextField])
    {
        if (textField.inputView == nil) {
            textField.inputView = self.notificationDatePicker;
            if ([self.detailItem dueDate] != nil) {
                [self.notificationDatePicker setDate:[self.detailItem dueDate] animated:YES];
            }
        }
        if (textField.inputAccessoryView == nil)
        {
            textField.inputAccessoryView = self.datePickerTool;
        }
    }

    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //limit the size :
    if ([textField.text length] >= 25)
    {
        [textField setText:[textField.text substringToIndex:25]];
    }
    return YES;
    //    if (textField.text.length >= 4 && range.length == 0)
    //    {
    //        return NO; // return NO to not change text
    //    }
    //    else
    //    {
    //        return YES;
    //    }
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


- (NSString *)timeStringFromNSDate:(NSDate *)date
{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [dayFormatter setLocale:[NSLocale currentLocale]];
    [dayFormatter setDateStyle:NSDateFormatterShortStyle];
    [dayFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dayFormatter setDoesRelativeDateFormatting:YES];
    return [dayFormatter stringFromDate:date];
}




#pragma mark - view transition


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"moreOptions"])
    {
        DetailViewController *svc = segue.destinationViewController;
        svc.isAdd = self.isAdd;
        [segue.destinationViewController setValue:self.detailItem forKey:@"detailItem"];
    }
}


@end