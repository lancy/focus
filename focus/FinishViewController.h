//
//  FinishViewController.h
//  focus
//
//  Created by Lancy on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainviewController.h"

@interface FinishViewController : MainViewController

@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)pressEditButton:(id)sender;

- (IBAction)backToMainView:(id)sender;
@end

