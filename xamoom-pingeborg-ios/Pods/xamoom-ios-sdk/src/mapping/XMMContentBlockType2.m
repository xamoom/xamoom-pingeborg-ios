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

#import "XMMContentBlockType2.h"

@implementation XMMContentBlockType2

+ (RKObjectMapping*)mapping {
  RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMContentBlockType2 class] ];
  [mapping addAttributeMappingsFromDictionary:@{@"video_url":@"videoUrl",
                                                @"public":@"publicStatus",
                                                @"content_block_type":@"contentBlockType",
                                                @"title":@"title",
                                                }];
  return mapping;
}

+ (RKObjectMappingMatcher*)dynamicMappingMatcher {
  RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                 expectedValue:@"2"
                                                                 objectMapping:[self mapping]];
  return matcher;
}

#pragma mark - XMMTableViewRepresentation

- (UITableViewCell *)tableView:(UITableView *)tableView representationAsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YoutubeBlockTableView"];
  if (cell == nil) {
    [tableView registerNib:[UINib nibWithNibName:@"XMMContentBlock2TableViewCell" bundle:nil]
    forCellReuseIdentifier:@"YoutubeBlockTableView"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"YoutubeBlockTableView"];
  }
  
  //set title and youtubeUrl
  if(self.title != nil && ![self.title isEqualToString:@""])
    cell.titleLabel.text = self.title;
  
  [cell initVideoWithUrl:self.videoUrl andWidth:tableView.bounds.size.width];
  
  return cell;
}

@end
