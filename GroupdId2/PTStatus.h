//
//  PTStatus.h
//  GroupdId2
//
//  Created by Markus Schmid on 19.01.15.
//  Copyright (c) 2015 Markus Schmid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PT, Status;

@interface PTStatus : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSNumber * hasBeenDeleted;
@property (nonatomic, retain) PT *pt;
@property (nonatomic, retain) Status *status;
@property (nonatomic, retain) PT *targetPT;

@end
