//
//  XMMCDSystem.h
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDResource.h"
#import "XMMSystem.h"
#import "XMMCDSystemSettings.h"
#import "XMMCDStyle.h"
#import "XMMCDMenu.h"

@interface XMMCDSystem : NSManagedObject <XMMCDResource>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) XMMCDSystemSettings *setting;
@property (strong, nonatomic) XMMCDStyle *style;
@property (strong, nonatomic) XMMCDMenu *menu;

@end
