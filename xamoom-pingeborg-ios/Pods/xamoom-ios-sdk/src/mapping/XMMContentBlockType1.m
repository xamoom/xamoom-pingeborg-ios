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

#import "XMMContentBlockType1.h"

@implementation XMMContentBlockType1

+ (RKObjectMapping *)mapping {
  RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMContentBlockType1 class] ];
  [mapping addAttributeMappingsFromDictionary:@{@"file_id":@"fileId",
                                                @"public":@"publicStatus",
                                                @"content_block_type":@"contentBlockType",
                                                @"title":@"title",
                                                @"artists":@"artist",
                                                }];
  return mapping;
}

+ (RKObjectMappingMatcher*)dynamicMappingMatcher {
  RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                 expectedValue:@"1"
                                                                 objectMapping:[self mapping]];
  return matcher;
}

#pragma mark - XMMTableViewRepresentation

- (UITableViewCell *)tableView:(UITableView *)tableView representationAsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioBlockTableViewCell"];
  if (cell == nil) {
    [tableView registerNib:[UINib nibWithNibName:@"XMMContentBlock1TableViewCell" bundle:nil]
    forCellReuseIdentifier:@"AudioBlockTableViewCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"AudioBlockTableViewCell"];
  }
  
  //set audioPlayerControl delegate and initialize
  cell.audioPlayerControl.delegate = cell;
  [cell.audioPlayerControl initAudioPlayerWithUrlString:self.fileId];
  
  //set title & artist
  if(self.title != nil && ![self.title isEqualToString:@""]) {
    cell.titleLabel.text = self.title;
  }
  
  if(self.artist != nil && ![self.artist isEqualToString:@""]) {
    cell.artistLabel.text = self.artist;
  }
  
  //set songDuration
  float songDurationInSeconds = CMTimeGetSeconds(cell.audioPlayerControl.audioPlayer.currentItem.asset.duration);
  cell.remainingTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)songDurationInSeconds / 60, (int)songDurationInSeconds % 60];
  
  return cell;
}

@end
