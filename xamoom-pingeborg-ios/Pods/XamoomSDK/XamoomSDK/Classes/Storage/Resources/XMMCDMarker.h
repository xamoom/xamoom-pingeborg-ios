//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <CoreData/CoreData.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDResource.h"
#import "XMMMarker.h"

@interface XMMCDMarker : NSManagedObject <XMMCDResource>

@property (nonatomic) NSString *qr;
@property (nonatomic) NSString *nfc;
@property (nonatomic) NSString *beaconUUID;
@property (nonatomic) NSString *beaconMajor;
@property (nonatomic) NSString *beaconMinor;
@property (nonatomic) NSString *eddyStoneUrl;

@end
