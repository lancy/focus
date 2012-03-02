//
//  FromSimpleToDetailSegue.m
//  focus
//
//  Created by Lancy on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FromSimpleToDetailSegue.h"

#import "SimpleViewController.h"

@interface FromSimpleToDetailSegue()
@end

@implementation FromSimpleToDetailSegue

- (void)perform
{
    UIViewController *dvc = [self destinationViewController];
    UIViewController *svc = (SimpleViewController *)[self sourceViewController];
    [dvc viewWillAppear:NO];
    [dvc viewDidAppear:NO];
    
//    [dvc.view setAlpha:0];
    
    [svc.view addSubview:dvc.view];
    dvc.view.frame = CGRectMake(svc.view.frame.origin.x, svc.view.frame.origin.y, dvc.view.frame.size.width, dvc.view.frame.size.height);

    
    [UIView animateWithDuration:0.5 
                     animations:^{

//                         [dvc.view setAlpha:1];
                     }completion:^(BOOL finish){
                         [dvc.navigationController popViewControllerAnimated:NO];
                         [svc.navigationController pushViewController:dvc animated:NO];
                     }];
    
}


@end
