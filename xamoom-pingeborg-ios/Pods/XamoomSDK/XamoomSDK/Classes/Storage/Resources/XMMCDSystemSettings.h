//
//  XMMCDSystemSettings.h
//  XamoomSDK
//
//  Created by Raphael Seher on 03/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "XMMCDResource.h"
#import "XMMSystemSettings.h"
#import "XMMOfflineStorageManager.h"

@interface XMMCDSystemSettings : NSManagedObject <XMMCDResource>

@property (strong, nonatomic) NSString *itunesAppId;
@property (strong, nonatomic) NSString *googlePlayId;

@end
