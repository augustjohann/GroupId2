//
//  AppDelegate.m
//  GroupdId2
//
//  Created by Markus Schmid on 14.01.15.
//  Copyright (c) 2015 Markus Schmid. All rights reserved.
//

#import "AppDelegate.h"
#import "PT.h"
#import "PTStatus.h"
#import "Group.h"
#import "Status.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _managedObjectModel=nil;
    _managedObjectContext=nil;
    _persistentStoreCoordinator=nil;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ic.GroupdId2" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GroupdId2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    NSFetchRequest *tmpTemplate;
    NSEntityDescription *tmpEntity;
    NSPredicate *tmpPredicate;

    // 1. GROUP_BY_GROUP_ID
    tmpEntity = [[_managedObjectModel entitiesByName] objectForKey:@"Group"];
    tmpTemplate = [[NSFetchRequest alloc] init];
    [tmpTemplate setEntity:tmpEntity];
    tmpPredicate = [NSPredicate predicateWithFormat:@"(groupId == $groupdid)"];
    [tmpTemplate setPredicate:tmpPredicate];
    [_managedObjectModel setFetchRequestTemplate:tmpTemplate forName:@"GROUP_BY_GROUP_ID"];
    
    // 2. PT_STATUS_BY_GROUP_ID
    tmpEntity = [[_managedObjectModel entitiesByName] objectForKey:@"PTStatus"];
    tmpTemplate = [[NSFetchRequest alloc] init];
    [tmpTemplate setEntity:tmpEntity];
    tmpPredicate = [NSPredicate predicateWithFormat:@"((ANY hasBeenDeleted == $deleted) AND (ANY status.group.groupId == $groupdid))"];
    [tmpTemplate setPredicate:tmpPredicate];
    [_managedObjectModel setFetchRequestTemplate:tmpTemplate forName:@"PT_STATUS_BY_GROUP_ID"];
    
    // 3. PT_BY_GROUP_ID
    tmpEntity = [[_managedObjectModel entitiesByName] objectForKey:@"PT"];
    tmpTemplate = [[NSFetchRequest alloc] init];
    [tmpTemplate setEntity:tmpEntity];
    tmpPredicate = [NSPredicate predicateWithFormat:@"((ANY hasStatus.status.group.groupId == $groupdid) AND (ANY hasStatus.hasBeenDeleted == $deleted))"];
    [tmpTemplate setPredicate:tmpPredicate];
    [tmpTemplate setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"requestDate" ascending:NO],[[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]]];
    [_managedObjectModel setFetchRequestTemplate:tmpTemplate forName:@"PT_BY_GROUP_ID"];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GroupdId2.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma marks - Auxiliary

- (void)fillAndQueryDB {
    
    NSMutableArray *group=[[NSMutableArray alloc] init];
    NSMutableArray *pt=[[NSMutableArray alloc] init];
    NSMutableArray *status=[[NSMutableArray alloc] init];
    NSMutableArray *ptstatus=[[NSMutableArray alloc] init];
    
    // 1.) Create the entities (Empty Database for the first Run !):
    
    // 3 x Group
    int i=0;
    for(NSString *value in @[@"Group1",@"Group2",@"Group3"]) {
        group[i]=[self newGroup:value];
        ((Group*)group[i]).groupId=@(i);
        i++;
    }
    
    // 5 x Status
    i=0;
    for(NSString *value in @[@"Status1",@"Status2",@"Status3",@"Status4",@"Status5"]) {
        status[i]=[self newStatus:value];
        i++;
    }
    
    // 8 x PTStatus
    i=0;
    for(NSString *value in @[@"PTStatus1",@"PTStatus2",@"PTStatus3",@"PTStatus4",@"PTStatus5",@"PTStatus6",@"PTStatus7",@"PTStatus8"]) {
        // alternately setting deletedStatus to YES/NO :
        ptstatus[i]=[self newPTStatus:value deletedStatus:((i%2)==1)];
        i++;
    }
    
    // 5 x PT
    i=0;
    for(NSString *value in @[@"PT1",@"PT2",@"PT3",@"PT4",@"PT5"]) {
        pt[i]=[self newPT:value number:@(i)];
        i++;
    }
    
    // 2.) Make the links:
    
    [(Group*)group[0] addHasStatus:[NSSet setWithArray:@[status[0],status[2],status[3]]]];
    [(Group*)group[1] addHasStatus:[NSSet setWithArray:@[status[1],status[4]]]];
    [(Group*)group[2] addHasStatus:[NSSet setWithArray:@[status[2],status[3],status[4]]]];
    
    [(Status*)status[0] addPtStatus:[NSSet setWithArray:@[ptstatus[0],ptstatus[7]]]];
    [(Status*)status[1] addPtStatus:[NSSet setWithArray:@[ptstatus[1],ptstatus[2],ptstatus[4],ptstatus[7]]]];
    [(Status*)status[2] addPtStatus:[NSSet setWithArray:@[ptstatus[1],ptstatus[2],ptstatus[3],ptstatus[5]]]];
    [(Status*)status[3] addPtStatus:[NSSet setWithArray:@[ptstatus[5],ptstatus[6],ptstatus[7]]]];
    [(Status*)status[4] addPtStatus:[NSSet setWithArray:@[ptstatus[0],ptstatus[3],ptstatus[4],ptstatus[5],ptstatus[7]]]];
    
    [(PT*)pt[0] addTargetedByPTStatus:[NSSet setWithArray:@[ptstatus[0],ptstatus[3],ptstatus[4]]]];
    [(PT*)pt[1] addTargetedByPTStatus:[NSSet setWithArray:@[ptstatus[2],ptstatus[6],ptstatus[5]]]];
    [(PT*)pt[2] addTargetedByPTStatus:[NSSet setWithArray:@[ptstatus[1],ptstatus[6],ptstatus[7]]]];
    [(PT*)pt[3] addTargetedByPTStatus:[NSSet setWithArray:@[ptstatus[3],ptstatus[4],ptstatus[5]]]];
    [(PT*)pt[4] addTargetedByPTStatus:[NSSet setWithArray:@[ptstatus[2],ptstatus[5],ptstatus[6]]]];
    
    [(PT*)pt[0] addHasStatus:[NSSet setWithArray:@[ptstatus[0],ptstatus[1],ptstatus[6]]]];
    [(PT*)pt[1] addHasStatus:[NSSet setWithArray:@[ptstatus[3],ptstatus[4],ptstatus[5]]]];
    [(PT*)pt[2] addHasStatus:[NSSet setWithArray:@[ptstatus[4],ptstatus[6],ptstatus[7]]]];
    [(PT*)pt[3] addHasStatus:[NSSet setWithArray:@[ptstatus[2],ptstatus[3],ptstatus[7]]]];
    [(PT*)pt[4] addHasStatus:[NSSet setWithArray:@[ptstatus[0],ptstatus[1],ptstatus[5]]]];
    
    [self saveContext];
    
    // 3.1.) Query via Group :
    
    NSArray *groupA=[self fetchGroupByGroupId:@(2)];
    NSMutableSet *resultPT=[[NSMutableSet alloc] init];
    for (Group *group in groupA) {
        for (Status *status in group.hasStatus) {
            for (PTStatus *ptstatus in status.ptStatus) {
                if (ptstatus.pt!=nil && [ptstatus.hasBeenDeleted boolValue]==NO) {
                    [resultPT addObject:ptstatus.pt];
                }
            }
        }
    }
    
    // 4.1.) Result:

    NSLog(@"Found %ld PT Entities ...",resultPT.count);
    for (PT *pt in resultPT) {
        NSLog(@"PT with value = %@",pt.value);
    }
    
    // 3.2.) Query via PTStatus :
    
    NSArray *ptstatusA=[self fetchPTStatusByGroupId:@(2) deletedStatus:NO];
    resultPT=[[NSMutableSet alloc] init];
    for (PTStatus *ptstatus in ptstatusA) {
        if (ptstatus.pt!=nil) {
            [resultPT addObject:ptstatus.pt];
        }
    }
    
    // 4.2.) Result:
    
    NSLog(@"Found %ld PT Entities ...",resultPT.count);
    for (PT *pt in resultPT) {
        NSLog(@"PT with value = %@",pt.value);
    }

    // 3.3.) Fetch PT directly:
    
    NSArray *ptA=[self fetchPTByGroupId:@(2) deletedStatus:NO];
    resultPT=[[NSMutableSet alloc] init];
    for (PT *pt in ptA) {
        [resultPT addObject:pt];
    }
    
    // 4.3.) Result:
    
    NSLog(@"Found %ld PT Entities ...",resultPT.count);
    for (PT *pt in resultPT) {
        NSLog(@"PT with value = %@",pt.value);
    }

}

- (NSArray *)fetchGroupByGroupId:(NSNumber *)value
{
    NSError *error = nil;
    
    NSManagedObjectModel *model = _managedObjectModel;
    
    NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:value, @"groupdid", nil];
    
    NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"GROUP_BY_GROUP_ID" substitutionVariables:substitutionDictionary];
    
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return results;
}

- (NSArray *)fetchPTStatusByGroupId:(NSNumber *)value deletedStatus:(BOOL)status
{
    NSError *error = nil;
    
    NSManagedObjectModel *model = _managedObjectModel;
    
    NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:value, @"groupdid",@(status), @"deleted", nil];
    
    NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"PT_STATUS_BY_GROUP_ID" substitutionVariables:substitutionDictionary];
    
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return results;
}

- (NSArray *)fetchPTByGroupId:(NSNumber *)value deletedStatus:(BOOL)status
{
    NSError *error = nil;
    
    NSManagedObjectModel *model = _managedObjectModel;
    
    NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:value, @"groupdid",@(status), @"deleted", nil];
    
    NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"PT_BY_GROUP_ID" substitutionVariables:substitutionDictionary];
    
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return results;
}

- (PT*)newPT:(NSString *)value number:(NSNumber *)number
{
    PT *newEntity;
    NSError *error;
    
    newEntity = (PT *)[NSEntityDescription insertNewObjectForEntityForName:@"PT" inManagedObjectContext:self.managedObjectContext];
    newEntity.value=value;
    newEntity.requestDate=[NSDate date];
    newEntity.number=number;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error occurred: %@",[error description]);
    }
    return newEntity;
}

- (PTStatus*)newPTStatus:(NSString *)value deletedStatus:(BOOL)status
{
    PTStatus *newEntity;
    NSError *error;
    
    newEntity = (PTStatus *)[NSEntityDescription insertNewObjectForEntityForName:@"PTStatus" inManagedObjectContext:self.managedObjectContext];
    newEntity.value=value;
    newEntity.hasBeenDeleted=@(status);
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error occurred: %@",[error description]);
    }
    return newEntity;
}

- (Status*)newStatus:(NSString *)value
{
    Status *newEntity;
    NSError *error;
    
    newEntity = (Status *)[NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:self.managedObjectContext];
    newEntity.value=value;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error occurred: %@",[error description]);
    }
    return newEntity;
}

- (Group*)newGroup:(NSString *)value
{
    Group *newEntity;
    NSError *error;
    
    newEntity = (Group *)[NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    newEntity.value=value;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error occurred: %@",[error description]);
    }
    return newEntity;
}


@end
