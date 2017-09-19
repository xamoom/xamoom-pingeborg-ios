//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <CoreData/CoreData.h>
#import "XMMCDResource.h"
#import "XMMStyle.h"

@interface XMMCDStyle : NSManagedObject <XMMCDResource>

@property (nonatomic, copy) NSString* backgroundColor;
@property (nonatomic, copy) NSString* highlightFontColor;
@property (nonatomic, copy) NSString* foregroundFontColor;
@property (nonatomic, copy) NSString* chromeHeaderColor;
@property (nonatomic, copy) NSString* customMarker;
@property (nonatomic, copy) NSString* icon;

@end
