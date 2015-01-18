//
//  PT.h
//  GroupdId2
//
//  Created by Markus Schmid on 14.01.15.
//  Copyright (c) 2015 Markus Schmid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PTStatus;

@interface PT : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSSet *targetedByPTStatus;
@property (nonatomic, retain) NSSet *hasStatus;
@end

@interface PT (CoreDataGeneratedAccessors)

- (void)addTargetedByPTStatusObject:(PTStatus *)value;
- (void)removeTargetedByPTStatusObject:(PTStatus *)value;
- (void)addTargetedByPTStatus:(NSSet *)values;
- (void)removeTargetedByPTStatus:(NSSet *)values;

- (void)addHasStatusObject:(PTStatus *)value;
- (void)removeHasStatusObject:(PTStatus *)value;
- (void)addHasStatus:(NSSet *)values;
- (void)removeHasStatus:(NSSet *)values;

@end
