//
//  XMMOfflineApi.m
//  XamoomSDK
//
//  Created by Raphael Seher on 10/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMOfflineApi.h"
#import "XMMOfflineApiHelper.h"
#import "XMMOfflinePagedResult.h"
#import "XMMCDContent.h"
#import "XMMCDSpot.h"
#import "XMMCDMarker.h"
#import "XMMContent.h"

@interface XMMOfflineApi()

@property (nonatomic, strong) XMMOfflineApiHelper *apiHelper;

@end

@implementation XMMOfflineApi

- (instancetype)init {
  self = [super init];
  if (self) {
    self.apiHelper = [[XMMOfflineApiHelper alloc] init];
  }
  return self;
}

- (void)contentWithID:(NSString *)contentID completion:(void (^)(XMMContent *, NSError *))completion {
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDContent coreDataEntityName]
                                            jsonID:contentID];
  
  if (results.count == 1) {
    completion([[XMMContent alloc] initWithCoreDataObject:results[0]], nil);
    return;
  } else if (results.count > 1) {
    // smt wrong
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  // nothing found
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)contentWithLocationIdentifier:(NSString *)locationIdentifier completion:(void (^)(XMMContent *, NSError *))completion {
  NSString *major = nil;
  NSString *minor = nil;
  
  if ([locationIdentifier containsString:@"|"]) {
    NSArray *components = [locationIdentifier componentsSeparatedByString:@"|"];
    major = components[0];
    minor = components[1];
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY markers.qr == %@) OR (ANY markers.nfc == %@) OR ((ANY markers.beaconMinor == %@) AND (ANY markers.beaconMajor == %@))", locationIdentifier, locationIdentifier, minor, major];
  NSCompoundPredicate *predicateCompound = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]];
  
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDSpot coreDataEntityName]
                                         predicate:predicateCompound];
  
  if (results.count == 1) {
    XMMCDSpot *savedSpot = results[0];
    completion([[XMMContent alloc] initWithCoreDataObject:savedSpot.content], nil);
    return;
  } else if (results.count > 1) {
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)contentsWithLocation:(CLLocation *)location pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *, bool, NSString *, NSError *))completion {
  
  if (location == nil) {
    completion(nil, nil, nil, [NSError errorWithDomain:@"XMMOfflineError"
                                                  code:102
                                              userInfo:@{@"description":@"Location cannot be nil"}]);
    return;
  }
  
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetchAll:[XMMCDSpot coreDataEntityName]];
  
  results = [self.apiHelper spotsInsideGeofence:results
                                       location:location
                                         radius:40];
  
  NSMutableArray *contents = [[NSMutableArray alloc] init];
  for (XMMCDSpot *savedSpot in results) {
    if (savedSpot.content != nil) {
      [contents addObject:[[XMMContent alloc] initWithCoreDataObject:savedSpot.content]];
    }
  }
  results = contents;
  
  if (sortOptions & XMMContentSortOptionsTitle) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"title"
                                            ascending:YES];
  } else if (sortOptions & XMMContentSortOptionsNameDesc) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"title"
                                            ascending:NO];
  }
  
  XMMOfflinePagedResult *pagedResult = [self.apiHelper pageResults:results
                                                          pageSize:pageSize
                                                            cursor:cursor];
  
  completion(pagedResult.items, pagedResult.hasMore, pagedResult.cursor, nil);
}

- (void)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  if (tags == nil) {
    completion(nil, nil, nil, [NSError errorWithDomain:@"XMMOfflineError"
                                                  code:102
                                              userInfo:@{@"description":@"Tags cannot be nil"}]);
    return;
  }
  
  NSArray *results = [[XMMOfflineStorageManager sharedInstance] fetchAll:[XMMCDContent coreDataEntityName]];
  
  results = [self.apiHelper entitiesWithTags:results tags:tags];
  
  if (sortOptions & XMMContentSortOptionsTitle) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"title"
                                            ascending:YES];
  } else if (sortOptions & XMMContentSortOptionsNameDesc) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"title"
                                            ascending:YES];
  }
  
  
  NSMutableArray *contents = [[NSMutableArray alloc] init];
  for (XMMCDContent *savedContent in results) {
    [contents addObject:[[XMMContent alloc] initWithCoreDataObject:savedContent]];
  }
  results = contents;
  
  XMMOfflinePagedResult *pagedResult = [self.apiHelper pageResults:results
                                                          pageSize:pageSize
                                                            cursor:cursor];
  
  completion(pagedResult.items, pagedResult.hasMore, pagedResult.cursor, nil);
}

- (void)contentsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  if (name == nil) {
    completion(nil, nil, nil, [NSError errorWithDomain:@"XMMOfflineError"
                                                  code:102
                                              userInfo:@{@"description":@"Name cannot be nil"}]);
    return;
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", name];
  NSArray *results = [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDContent coreDataEntityName]
                                                            predicate:predicate];
  
  if (sortOptions & XMMContentSortOptionsTitle) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"title"
                                            ascending:YES];
  } else if (sortOptions & XMMContentSortOptionsNameDesc) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"title"
                                            ascending:NO];
  }
  
  NSMutableArray *contents = [[NSMutableArray alloc] init];
  for (XMMCDContent *savedContent in results) {
    [contents addObject:[[XMMContent alloc] initWithCoreDataObject:savedContent]];
  }
  results = contents;
  
  completion(results, NO, nil, nil);
}

- (void)spotWithID:(NSString *)spotID completion:(void(^)(XMMSpot *spot, NSError *error))completion {
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDSpot coreDataEntityName]
                                            jsonID:spotID];
  
  if (results.count == 1) {
    completion([[XMMSpot alloc] initWithCoreDataObject:results[0]], nil);
    return;
  } else if (results.count > 1) {
    // smt wrong
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  // nothing found
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)spotsWithLocation:(CLLocation *)location radius:(int)radius pageSize:(int)pageSize cursor:(NSString *)cursor completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  if (location == nil) {
    completion(nil, nil, nil, [NSError errorWithDomain:@"XMMOfflineError"
                                                  code:102
                                              userInfo:@{@"description":@"Location cannot be nil"}]);
    return;
  }
  
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetchAll:[XMMCDSpot coreDataEntityName]];
  
  results = [self.apiHelper spotsInsideGeofence:results
                                       location:location
                                         radius:radius];
  
  XMMOfflinePagedResult *pagedResult = [self.apiHelper pageResults:results
                                                          pageSize:pageSize
                                                            cursor:cursor];
  
  NSMutableArray *spots = [[NSMutableArray alloc] init];
  for (XMMCDSpot *savedSpot in pagedResult.items) {
      [spots addObject:[[XMMSpot alloc] initWithCoreDataObject:savedSpot]];
  }
  pagedResult.items = spots;
  
  completion(pagedResult.items, pagedResult.hasMore, pagedResult.cursor, nil);
}

- (void)spotsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *, bool, NSString *, NSError *))completion {
  if (tags == nil) {
    completion(nil, nil, nil, [NSError errorWithDomain:@"XMMOfflineError"
                                                  code:102
                                              userInfo:@{@"description":@"Tags cannot be nil"}]);
    return;
  }
  
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetchAll:[XMMCDSpot coreDataEntityName]];
  
  results = [self.apiHelper entitiesWithTags:results tags:tags];
  
  if (sortOptions & XMMContentSortOptionsTitle) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"name"
                                            ascending:YES];
  } else if (sortOptions & XMMContentSortOptionsNameDesc) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"name"
                                            ascending:NO];
  }
  
  XMMOfflinePagedResult *pagedResult = [self.apiHelper pageResults:results
                                                          pageSize:pageSize
                                                            cursor:cursor];
  
  NSMutableArray *spots = [[NSMutableArray alloc] init];
  for (XMMCDSpot *savedSpot in pagedResult.items) {
    [spots addObject:[[XMMSpot alloc] initWithCoreDataObject:savedSpot]];
  }
  pagedResult.items = spots;
  
  completion(pagedResult.items, pagedResult.hasMore, pagedResult.cursor, nil);
}

- (void)spotsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *, bool, NSString *, NSError *))completion {
  if (name == nil) {
    completion(nil, nil, nil, [NSError errorWithDomain:@"XMMOfflineError"
                                                  code:102
                                              userInfo:@{@"description":@"Name cannot be nil"}]);
    return;
  }

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", name];
  NSArray *results = [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDSpot coreDataEntityName]
                                                            predicate:predicate];
  
  if (sortOptions & XMMContentSortOptionsTitle) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"name"
                                            ascending:YES];
  } else if (sortOptions & XMMContentSortOptionsNameDesc) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"name"
                                            ascending:NO];
  }
  
  XMMOfflinePagedResult *pagedResult = [self.apiHelper pageResults:results
                                                          pageSize:pageSize
                                                            cursor:cursor];
  
  NSMutableArray *spots = [[NSMutableArray alloc] init];
  for (XMMCDSpot *savedSpot in pagedResult.items) {
    [spots addObject:[[XMMSpot alloc] initWithCoreDataObject:savedSpot]];
  }
  pagedResult.items = spots;
  
  completion(pagedResult.items, pagedResult.hasMore, pagedResult.cursor, nil);
}

- (void)systemWithCompletion:(void (^)(XMMSystem *, NSError *))completion {
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetchAll:[XMMCDSystem coreDataEntityName]];
  
  if (results.count == 1) {
    completion([[XMMSystem alloc] initWithCoreDataObject:results[0]], nil);
    return;
  } else if (results.count > 1) {
    // smt wrong
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  // nothing found
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)systemWithID:(NSString *)systemID completion:(void (^)(XMMSystem *, NSError *))completion {
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDSystem coreDataEntityName]
                                            jsonID:systemID];
  
  if (results.count == 1) {
    completion([[XMMSystem alloc] initWithCoreDataObject:results[0]], nil);
    return;
  } else if (results.count > 1) {
    // smt wrong
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  // nothing found
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)systemSettingsWithID:(NSString *)settingsID completion:(void (^)(XMMSystemSettings *, NSError *))completion {
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDSystemSettings coreDataEntityName]
                                            jsonID:settingsID];
  
  if (results.count == 1) {
    completion([[XMMSystemSettings alloc] initWithCoreDataObject:results[0]], nil);
    return;
  } else if (results.count > 1) {
    // smt wrong
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  // nothing found
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)styleWithID:(NSString *)styleID completion:(void (^)(XMMStyle *, NSError *))completion {
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDStyle coreDataEntityName]
                                            jsonID:styleID];
  
  if (results.count == 1) {
    completion([[XMMStyle alloc] initWithCoreDataObject:results[0]], nil);
    return;
  } else if (results.count > 1) {
    // smt wrong
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  // nothing found
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)menuWithID:(NSString *)menuID completion:(void (^)(XMMMenu *, NSError *))completion {
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDMenu coreDataEntityName]
                                            jsonID:menuID];
  
  if (results.count == 1) {
    completion([[XMMMenu alloc] initWithCoreDataObject:results[0]], nil);
    return;
  } else if (results.count > 1) {
    // smt wrong
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  // nothing found
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

@end
