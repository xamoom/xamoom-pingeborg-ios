//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMStyle.h"

@implementation XMMStyle

static JSONAPIResourceDescriptor *__descriptor = nil;

- (instancetype)init {
  return [self initWithBackgroundColor:@"#FFFFFF"
                highlightTextColor:@"#0000FF"
                textColor:@"#000000"];
}

- (instancetype)initWithBackgroundColor:(NSString *)backgroundHexColor highlightTextColor:(NSString *)highlightFontHexColor textColor:(NSString *)foregroundFontHexColor {
  self = [super init];
  if (self) {
    self.backgroundColor = backgroundHexColor;
    self.highlightFontColor = highlightFontHexColor;
    self.foregroundFontColor = foregroundFontHexColor;
  }
  return self;
}

+ (NSString *)resourceName {
  return @"styles";
}

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"styles"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"backgroundColor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"background-color"]];
    [__descriptor addProperty:@"highlightFontColor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"highlight-color"]];
    [__descriptor addProperty:@"foregroundFontColor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"foreground-color"]];
    [__descriptor addProperty:@"chromeHeaderColor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"chrome-header-color"]];
    [__descriptor addProperty:@"customMarker" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"map-pin"]];
    [__descriptor addProperty:@"icon"];
  });
  
  return __descriptor;
}

@end
