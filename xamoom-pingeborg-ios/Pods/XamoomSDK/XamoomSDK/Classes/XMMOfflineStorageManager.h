//
//  XMMOfflineStorageManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "XMMOfflineFileManager.h"

@interface XMMOfflineStorageManager : NSObject

extern NSString *const kManagedContextReadyNotification;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) XMMOfflineFileManager *fileManager;
@property (strong, nonatomic) NSMutableArray *saveDeletionFiles;

+ (instancetype)sharedInstance;

#pragma mark - CoreData

/**
 * Saves context.
 *
 * @return NSError if something goes wrong.
 */
- (NSError *)save;

/**
 * Fetches all entities of an entityType.
 *
 * @param entityType Type of the entity.
 * @return array of entities.
 */
- (NSArray *)fetchAll:(NSString *)entityType;

/**
 * Fetches all entities of an entityType with a predicate.
 *
 * @param entityType Type of the entity.
 * @param predicate NSPredicate to filter results.
 */
- (NSArray *)fetch:(NSString *)entityType predicate:(NSPredicate *)predicate;

/**
 * Fetches all entities with a given jsonID.
 *
 * @param entityType Type of the entity.
 * @param jsonID ID from the xamoom cloud to identify object.
 */
- (NSArray *)fetch:(NSString *)entityType jsonID:(NSString *)jsonID;

/**
 * Delets entity by ID.
 * This will automatically delete files that are save to delete by calling 
 * deleteLocalFilesWithSafetyCheck.
 *
 * @param entityClass Class of the entity.
 * @param ID JsonID of the entity to delete.
 */
- (void)deleteEntity:(Class)entityClass ID:(NSString *)ID;

/**
 * Deletes all entities and all of their files.
 */
- (void)deleteAllEntities;

/**
 * Deletes 
 */
- (void)deleteLocalFilesWithSafetyCheck;

@end
