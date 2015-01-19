//
//  Group.h
//  GroupdId2
//
//  Created by Markus Schmid on 19.01.15.
//  Copyright (c) 2015 Markus Schmid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Status;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * groupId;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSSet *hasStatus;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addHasStatusObject:(Status *)value;
- (void)removeHasStatusObject:(Status *)value;
- (void)addHasStatus:(NSSet *)values;
- (void)removeHasStatus:(NSSet *)values;

@end
