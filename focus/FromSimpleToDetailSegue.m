//
//  FromSimpleToDetailSegue.m
//  focus
//
//  Created by Lancy on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FromSimpleToDetailSegue.h"

#import "SimpleViewController.h"
#import "DetailViewController.h"

@interface FromSimpleToDetailSegue()
@end

@implementation FromSimpleToDetailSegue

- (void)perform
{
    DetailViewController *dvc = (DetailViewController *)[self destinationViewController];
    SimpleViewController *svc = (SimpleViewController *)[self sourceViewController];
    NSLog(@"%@", dvc);
    [dvc viewWillAppear:NO];
    
    UITableViewCell *cell = [dvc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y + 34, cell.frame.size.width, cell.frame.size.height)];

    [dvc viewDidAppear:NO];    

    [svc.navigationController pushViewController:dvc animated:NO];    

    

    
    
 
    [UIView animateWithDuration:0.5 
                     animations:^{



                     } completion:^(BOOL finish){

                     }];
                         



//    dvc.view.frame = CGRectMake(svc.view.frame.origin.x, svc.view.frame.origin.y, dvc.view.frame.size.width, dvc.view.frame.size.height);
//
//    
//    [UIView animateWithDuration:0.5 
//                     animations:^{
//                         [dvc.view setAlpha:1];
//                     }completion:^(BOOL finish){
//                         [dvc.navigationController popViewControllerAnimated:NO];
//                         [svc.navigationController pushViewController:dvc animated:NO];
//                     }];
    
}


@end
