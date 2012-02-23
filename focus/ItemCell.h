//
//  ItemCell.h
//  focus
//
//  Created by Lancy on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ItemCell : UITableViewCell
{
    BOOL _checkboxSelected;
}


@property (strong, nonatomic) Item* detailItem;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UIImageView *priorityImageView;
@property (nonatomic, strong) IBOutlet UILabel *duedateLabel;
@property (nonatomic, strong) IBOutlet UIButton *finishCheckbox; 

- (IBAction)changeCheckbox: (id)sender;

- (void)configureDuedateLabelFromDate:(NSDate *)aDate;
- (void)configurePriority:(NSNumber *)priorityNumber;

@end
