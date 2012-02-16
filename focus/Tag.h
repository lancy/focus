//
//  Tag.h
//  focus
//
//  Created by Lancy on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *itemList;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addItemListObject:(Item *)value;
- (void)removeItemListObject:(Item *)value;
- (void)addItemList:(NSSet *)values;
- (void)removeItemList:(NSSet *)values;

@end
