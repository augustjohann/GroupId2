//
//  Status.h
//  GroupdId2
//
//  Created by Markus Schmid on 14.01.15.
//  Copyright (c) 2015 Markus Schmid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, PTStatus;

@interface Status : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSSet *ptStatus;
@property (nonatomic, retain) Group *group;
@end

@interface Status (CoreDataGeneratedAccessors)

- (void)addPtStatusObject:(PTStatus *)value;
- (void)removePtStatusObject:(PTStatus *)value;
- (void)addPtStatus:(NSSet *)values;
- (void)removePtStatus:(NSSet *)values;

@end
