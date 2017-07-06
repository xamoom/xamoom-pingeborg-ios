//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


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
