//
//  XMMCDStyle.h
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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
