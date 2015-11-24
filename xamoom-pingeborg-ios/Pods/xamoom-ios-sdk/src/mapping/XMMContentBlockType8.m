//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
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

#import <Foundation/Foundation.h>
#import "XMMContentBlockType8.h"

@implementation XMMContentBlockType8

+ (RKObjectMapping*)mapping {
  RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMContentBlockType8 class] ];
  [mapping addAttributeMappingsFromDictionary:@{@"download_type":@"downloadType",
                                                @"file_id":@"fileId",
                                                @"public":@"publicStatus",
                                                @"content_block_type":@"contentBlockType",
                                                @"text":@"text",
                                                @"title":@"title",
                                                }];
  return mapping;
}

+ (RKObjectMappingMatcher*)dynamicMappingMatcher {
  RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                 expectedValue:@"8"
                                                                 objectMapping:[self mapping]];
  return matcher;
}

#pragma mark - XMMTableViewRepresentation

- (UITableViewCell *)tableView:(UITableView *)tableView representationAsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock8TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadBlockTableViewCell"];
  if (cell == nil) {
    [tableView registerNib:[UINib nibWithNibName:@"XMMContentBlock8TableViewCell" bundle:nil]
    forCellReuseIdentifier:@"DownloadBlockTableViewCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadBlockTableViewCell"];
  }
  
  //set title, text, fileId and downloadType
  cell.titleLabel.text = self.title;
  cell.contentTextLabel.text = self.text;
  cell.fileId = self.fileId;
  cell.downloadType = self.downloadType;
  
  [cell initCellData];
  
  return cell;
}

@end
