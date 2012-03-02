//
//  Item.h
//  focus
//
//  Created by Lancy on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSDate * creatTime;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSNumber * isSomeday;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSManagedObject *belongToProject;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) UILocalNotification *alarm;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
