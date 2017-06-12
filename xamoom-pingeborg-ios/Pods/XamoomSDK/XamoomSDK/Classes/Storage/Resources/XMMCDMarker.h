//
//  XMMCDMarker.h
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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
