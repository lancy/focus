//
//  ItemCell.m
//  focus
//
//  Created by Lancy on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()
- (void)configureFinishCheckbox;
- (NSString *)dateStringFromNSDate:(NSDate *)date;
@end


@implementation ItemCell

@synthesize detailItem;

@synthesize titleLabel;
@synthesize infoLabel;
@synthesize priorityImageView;
@synthesize duedateLabel;
@synthesize finishCheckbox;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureFinishCheckbox];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self configureFinishCheckbox];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - finishCheckbox

- (void)configureFinishCheckbox
{
    UIButton *checkbox = [[UIButton alloc] init];
    [checkbox setBackgroundImage:[UIImage imageNamed:@"notSelectedCheckbox.png"] forState:UIControlStateNormal];
    [checkbox setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateSelected];
    [checkbox setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateHighlighted];
    checkbox.adjustsImageWhenHighlighted = YES;
    
    [checkbox addTarget:self action:@selector(changeCheckbox:) forControlEvents:UIControlEventTouchUpInside];
    self.finishCheckbox = checkbox;
    _checkboxSelected = NO;
}

- (IBAction)changeCheckbox:(id)sender
{
    [self.detailItem setFinished:[NSNumber numberWithBool:_checkboxSelected]];
    _checkboxSelected = !_checkboxSelected;
    [self.finishCheckbox setSelected:_checkboxSelected];
}

#pragma mark - duedate string

- (NSString *)dateStringFromNSDate:(NSDate *)date
{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [dayFormatter setLocale:[NSLocale currentLocale]];
    [dayFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dayFormatter setDoesRelativeDateFormatting:YES];
    
    return [dayFormatter stringFromDate:date];
}

- (void)configureDuedateLabelFromDate:(NSDate *)aDate
{
    [self.duedateLabel setText:[self dateStringFromNSDate:aDate]];
    NSLog(@"%@", aDate);
    NSLog(@"%@", self.duedateLabel.text);
}

#pragma mark - set priority

- (void)configurePriority:(NSNumber *)priorityNumber    
{
    switch ([priorityNumber intValue]) {
        case 0:
            [self.priorityImageView setImage:[UIImage imageNamed:@"priority0"]];
            break;
        case 1:
            [self.priorityImageView setImage:[UIImage imageNamed:@"priority1"]];
            break;
        case 2:
            [self.priorityImageView setImage:[UIImage imageNamed:@"priority2"]];
            break;
        case 3:
            [self.priorityImageView setImage:[UIImage imageNamed:@"priority3"]];
            break;

            
        default:
            break;
    }
}





@end
