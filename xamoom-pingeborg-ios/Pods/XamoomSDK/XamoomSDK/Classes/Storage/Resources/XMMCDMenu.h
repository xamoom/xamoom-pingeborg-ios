//
//  XMMCDMenu.h
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "XMMCDResource.h"
#import "XMMMenu.h"

@interface XMMCDMenu : NSManagedObject <XMMCDResource>

@property (nonatomic, copy) NSOrderedSet *items;

@end
