//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMOfflineStorageManager.h"
#import "XMMCDContent.h"
#import "XMMCDContentBlock.h"
#import "XMMCDMarker.h"
#import "XMMCDMenu.h"
#import "XMMCDSpot.h"
#import "XMMCDStyle.h"
#import "XMMCDSystem.h"
#import "XMMCDSystem.h"
#import "XMMCDSystemSettings.h"

NSString *const kManagedContextErrorNotification = @"MANAGED_CONTEXT_ERROR_NOTIFICATION";
NSString *const kManagedContextReadyNotification = @"MANAGED_CONTEXT_READY_NOTIFICATION";

@implementation XMMOfflineStorageManager

static XMMOfflineStorageManager *sharedMyManager = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

- (id)init {
  self = [super init];
  
  [self initializeCoreData];
  self.saveDeletionFiles = [[NSMutableArray alloc] init];
  
  return self;
}

- (void)initializeCoreData {
  NSBundle *bundle = [NSBundle bundleForClass:[XMMOfflineStorageManager class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *sdkBundle;
  if (url) {
    sdkBundle = [NSBundle bundleWithURL:url];
  } else {
    sdkBundle = bundle;
  }
  
  NSURL *modelURL = [sdkBundle URLForResource:@"EnduserOfflineDatamodel" withExtension:@"momd"];
  NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  NSAssert(mom != nil, @"Error initializing Managed Object Model");
  
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [moc setPersistentStoreCoordinator:psc];
  self.managedObjectContext = moc;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
  NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
  
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
    NSError *error = nil;
    NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    if (error) {
      NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
      dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kManagedContextErrorNotification
                                                            object:self
                                                          userInfo:@{@"error":error}];
      });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:kManagedContextReadyNotification
                                                          object:self];
    });
  });
}

#pragma mark - CoreData

- (NSError *)save {
  NSError *error = nil;
  [self.managedObjectContext save:&error];
  return error;
}

- (NSArray *)fetchAll:(NSString *)entityType {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityType];
  NSError *error = nil;
  return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (NSArray *)fetch:(NSString *)entityType predicates:(NSArray *)predicates {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityType];
  request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
  NSError *error = nil;
  return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (NSArray *)fetch:(NSString *)entityType predicates:(NSArray *)predicates sortDescriptors:(NSArray *)sortDescriptor {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityType];
  request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
  
  if (sortDescriptor != nil) {
    request.sortDescriptors = sortDescriptor;
  }
  
  NSError *error = nil;
  return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (NSArray *)fetch:(NSString *)entityType jsonID:(NSString *)jsonID {
  return [self fetch:entityType
           predicates:@[[NSPredicate predicateWithFormat:@"jsonID == %@", jsonID]]];
}

- (void)deleteEntity:(Class)entityClass ID:(NSString *)ID {
  NSString *entityName = nil;
  if ([entityClass conformsToProtocol:@protocol(XMMCDResource)]) {
    entityName = [entityClass coreDataEntityName];
  }
  NSArray *results = [self fetch:entityName jsonID:ID];
  if (results.count > 0) {
    [self determineFileDeletionForEntities:results entityClass:entityClass saveDeletion:YES];
    
    for (NSManagedObject *object in results) {
      [self.managedObjectContext deleteObject:object];
    }
  }
  
  NSError *error;
  [self.managedObjectContext save:&error];
  [self deleteLocalFilesWithSafetyCheck];
}

- (void)deleteAllEntities {
  NSArray *entityArray = @[[XMMCDContent class],[XMMCDContentBlock class],[XMMCDMarker class],[XMMCDMenu class],[XMMCDSpot class],[XMMCDStyle class],[XMMCDSystem class],[XMMCDSystemSettings class]];
  
  for (Class entityClass in entityArray) {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:[entityClass coreDataEntityName]];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    if (results) {
      [self determineFileDeletionForEntities:results entityClass:entityClass saveDeletion:NO];
      
      for (NSManagedObject *entity in results) {
        [self.managedObjectContext deleteObject:entity];
      }
    }
  }
  
  [self.managedObjectContext save:nil];
  [self deleteLocalFilesWithSafetyCheck];
}

- (void)determineFileDeletionForEntities:(NSArray *)entities
                             entityClass:(Class)entityClass
                            saveDeletion:(BOOL)saveDeletion {
  for (id entity in entities) {
    if (entityClass == [XMMCDContent class]) {
      [self deleteSavedFilesForEntity:entity urlKeyPath:@"imagePublicUrl" saveDeletion:saveDeletion];
    }
    
    if (entityClass == [XMMCDSpot class]) {
      [self deleteSavedFilesForEntity:entity urlKeyPath:@"image" saveDeletion:saveDeletion];
    }
    
    if (entityClass == [XMMCDContentBlock class]) {
      [self deleteSavedFilesForEntity:entity urlKeyPath:@"fileID" saveDeletion:saveDeletion];
      [self deleteSavedFilesForEntity:entity urlKeyPath:@"videoUrl" saveDeletion:saveDeletion];
    }
  }
}

- (void)deleteSavedFilesForEntity:(NSManagedObject *)entity urlKeyPath:(NSString *)keyPath
                     saveDeletion:(BOOL)saveDeletion {
  NSString *urlString = nil;
  @try {
    urlString = [entity valueForKey:keyPath];
  }
  @catch (NSException *e) {
    return;
  }
  
  if (urlString != nil) {
    if (saveDeletion) {
      [self.saveDeletionFiles addObject:urlString];
    } else {
      [self.fileManager deleteFileWithUrl:urlString error:nil];
    }
  }
}

- (void)deleteLocalFilesWithSafetyCheck {
  for (NSString *urlString in self.saveDeletionFiles) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imagePublicUrl == %@", urlString];
    NSArray *results = [self fetch:[XMMCDContent coreDataEntityName] predicates:@[predicate]];
    if (results.count > 0) {
      continue;
    }
    
    predicate = [NSPredicate predicateWithFormat:@"image == %@", urlString];
    results = [self fetch:[XMMCDSpot coreDataEntityName] predicates:@[predicate]];
    if (results.count > 0) {
      continue;
    }
    
    predicate = [NSPredicate predicateWithFormat:@"fileID == %@ OR videoUrl == %@", urlString, urlString];
    results = [self fetch:[XMMCDContentBlock coreDataEntityName] predicates:@[predicate]];
    if (results.count > 0) {
      continue;
    }
    
    [self.fileManager deleteFileWithUrl:urlString error:nil];
  }
  
  [self.saveDeletionFiles removeAllObjects];
}

- (XMMOfflineFileManager *)fileManager {
  if (_fileManager == nil) {
    _fileManager = [[XMMOfflineFileManager alloc] init];
  }
  return _fileManager;
}

@end
