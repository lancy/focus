//
//  DetailViewController.h
//  test
//
//  Created by Lan Chenyu on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "item.h"

@interface DetailViewController : UIViewController {
    UIDatePicker *_datePicker;
    UITextField *_titleTextField;
}


@property (strong, nonatomic) Item* detailItem;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)Save:(id)sender;

@end
