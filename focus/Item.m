//
//  Item.m
//  focus
//
//  Created by Lancy on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

const NSTimeInterval secondsPerDay = 24 * 60 * 60;


@implementation Item

@dynamic creatTime;
@dynamic dueDate;
@dynamic duration;
@dynamic finished;
@dynamic isSomeday;
@dynamic note;
@dynamic priority;
@dynamic startDate;
@dynamic score;
@dynamic title;
@dynamic belongToProject;
@dynamic tags;



- (NSDate *)priorDate
// return the item's prior date, startDate -> dueDate
{
    if (self.startDate != nil)
        return self.startDate;
    else if (self.dueDate != nil)
        return self.dueDate;
    else 
        return nil;
}

- (void)setDueDate:(NSDate *)dueDate
// set dueDate and auto-set duration or startDate
{
    // change the primitive value of dueDate
    [self willChangeValueForKey:@"dueDate"];
    [self setPrimitiveValue:dueDate forKey:@"dueDate"];
    [self didChangeValueForKey:@"dueDate"];
    if (self.startDate != nil) 
        // if startDate existed then change the primitive value of duration
    {
        NSNumber *duration = [[NSNumber alloc]initWithDouble:([self.dueDate timeIntervalSinceDate:self.startDate] / secondsPerDay)];
        [self willChangeValueForKey:@"duration"];
        [self setPrimitiveValue:duration forKey:@"duration"];
        [self didChangeValueForKey:@"duration"];
    } 
    else if (self.duration != nil)
        // if startDate inexisted and duration existed then change the primitive value of startDate
    {
        NSTimeInterval durationTimeInterval = [self.duration doubleValue] * secondsPerDay;
        NSDate *startDate = [NSDate dateWithTimeInterval:-durationTimeInterval sinceDate:self.dueDate];
        [self willChangeValueForKey:@"startDate"];
        [self setPrimitiveValue:startDate forKey:@"startDate"];
        [self didChangeValueForKey:@"startDate"];
    }
}

- (void)setStartDate:(NSDate *)startDate
// set startDate and auto-set dration or dueDate
{
    [self willChangeValueForKey:@"startDate"];
    [self setPrimitiveValue:startDate forKey:@"startDate"];
    [self didChangeValueForKey:@"startDate"];
    if (self.dueDate != nil)
    {
        NSNumber *duration = [[NSNumber alloc]initWithDouble:([self.dueDate timeIntervalSinceDate:self.startDate] / secondsPerDay)];
        [self willChangeValueForKey:@"duration"];
        [self setPrimitiveValue:duration forKey:@"duration"];
        [self didChangeValueForKey:@"duration"];
    }
    else if (self.duration != nil)
    {
        NSTimeInterval durationTimeInterval = [self.duration doubleValue] * secondsPerDay;
        NSDate *dueDate = [NSDate dateWithTimeInterval:durationTimeInterval sinceDate:self.startDate];
        [self willChangeValueForKey:@"dueDate"];
        [self setPrimitiveValue:dueDate forKey:@"dueDate"];
        [self didChangeValueForKey:@"dueDate"];   
    }
}

- (void)setDuration:(NSNumber *)duration
// set duration and auto-set startDate or dueDate
{
    [self willChangeValueForKey:@"duration"];
    [self setPrimitiveValue:duration forKey:@"duration"];
    [self didChangeValueForKey:@"duration"];
    if (self.dueDate != nil)
    {
        NSTimeInterval durationTimeInterval = [self.duration doubleValue] * secondsPerDay;
        NSDate *startDate = [NSDate dateWithTimeInterval:-durationTimeInterval sinceDate:self.dueDate];
        [self willChangeValueForKey:@"startDate"];
        [self setPrimitiveValue:startDate forKey:@"startDate"];
        [self didChangeValueForKey:@"startDate"];
    }
    else if (self.startDate != nil)
    {
        NSTimeInterval durationTimeInterval = [self.duration doubleValue] * secondsPerDay;
        NSDate *dueDate = [NSDate dateWithTimeInterval:durationTimeInterval sinceDate:self.startDate];
        [self willChangeValueForKey:@"dueDate"];
        [self setPrimitiveValue:dueDate forKey:@"dueDate"];
        [self didChangeValueForKey:@"dueDate"];  
    }
}


- (void)moveToInbox
// move item to inbox and reset the date
{
    self.startDate = nil;
    self.dueDate = nil;
    [self setIsSomeday:[[NSNumber alloc] initWithBool:NO]];
}

- (void)moveToToday
// move item to today and set the dueDate
{
    self.dueDate = [NSDate date];
    [self setIsSomeday:[[NSNumber alloc] initWithBool:NO]];
}

- (void)moveToTomorrow
// set dureDate of item to tomorrow
{
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];
    self.dueDate = tomorrow;
    [self setIsSomeday:[[NSNumber alloc] initWithBool:NO]];
}

- (void)moveToAfter
// move item to after and set the dueDate
{
    [self moveToTomorrow];
}

- (void)moveToSomeday
{
    self.startDate = nil;
    self.dueDate = nil;
    [self setIsSomeday:[[NSNumber alloc] initWithBool:YES]];
}

- (NSString *)dueDateStr
// dueDateStr use to divide items into sections.
{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [dayFormatter setLocale:[NSLocale currentLocale]];
    [dayFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dayFormatter setDoesRelativeDateFormatting:YES];
    
    return [dayFormatter stringFromDate:self.dueDate];
}

- (NSString *)isOverdue;
// judge a item is expreied.
{
    // Get the date of begin of today
    NSDate *today = [NSDate date];
    
    //    NSDateComponents *aDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit| NSDayCalendarUnit fromDate:today];
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDate *beginOfToday = [gregorian dateFromComponents:aDay];
    // notice: there is a bug with time zone.
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [dayFormatter setLocale:[NSLocale currentLocale]];
    [dayFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dayFormatter setDoesRelativeDateFormatting:YES];
    
    NSString *todayStr = [dayFormatter stringFromDate:today];
    
    //    NSLog(@"%@%@", [self dueDateStr], todayStr);
    
    if ([[self dueDateStr] isEqualToString:todayStr]) {
        return @"Today";
    }
    else
        return @"Overdue";
}






@end
