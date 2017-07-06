//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import "XMMRestResource.h"
#import "XMMSystemSettings.h"
#import "XMMStyle.h"
#import "XMMMenu.h"

/**
 * XMMSystem with linked XMMSystemSettings, XMMStyle and XMMMenu.
 */
@interface XMMSystem : JSONAPIResourceBase <XMMRestResource>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) XMMSystemSettings *setting;
@property (strong, nonatomic) XMMStyle *style;
@property (strong, nonatomic) XMMMenu *menu;

@end
