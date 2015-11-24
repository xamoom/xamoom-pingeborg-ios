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

#import "XMMContentBlockType3.h"

@implementation XMMContentBlockType3

+ (RKObjectMapping *)mapping {
  RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMContentBlockType3 class] ];
  [mapping addAttributeMappingsFromDictionary:@{@"file_id":@"fileId",
                                                @"scale_x":@"scaleX",
                                                @"link_url":@"linkUrl",
                                                @"public":@"publicStatus",
                                                @"content_block_type":@"contentBlockType",
                                                @"title":@"title",
                                                @"alt_text":@"altText",
                                                }];
  return mapping;
}

+ (RKObjectMappingMatcher*)dynamicMappingMatcher {
  RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                 expectedValue:@"3"
                                                                 objectMapping:[self mapping]];
  return matcher;
}

#pragma mark - XMMTableViewRepresentation

- (UITableViewCell *)tableView:(UITableView *)tableView representationAsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageBlockTableViewCell"];
  if (cell == nil) {
    [tableView registerNib:[UINib nibWithNibName:@"XMMContentBlock3TableViewCell" bundle:nil]
    forCellReuseIdentifier:@"ImageBlockTableViewCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"ImageBlockTableViewCell"];
  }
  
  cell.titleLabel.text = nil;
  [cell.image setIsAccessibilityElement:YES];
  cell.linkUrl = self.linkUrl;
  cell.imageLeftHorizontalSpaceConstraint.constant = 0;
  cell.imageRightHorizontalSpaceConstraint.constant = 0;
  
  //set title
  if (self.title != nil && ![self.title isEqualToString:@""]) {
    cell.titleLabel.text = self.title;
    cell.image.accessibilityHint = self.title;
  }
  
  if (self.altText != nil || [self.altText isEqualToString:@""]){
    cell.image.accessibilityHint = self.altText;
  }
  
  //scale the imageView
  float scalingFactor = 1;
  if (self.scaleX != nil) {
    scalingFactor = self.scaleX.floatValue / 100;
    float newImageWidth = tableView.bounds.size.width * scalingFactor;
    float sizeDiff = tableView.bounds.size.width - newImageWidth;
    
    cell.imageLeftHorizontalSpaceConstraint.constant = sizeDiff/2;
    cell.imageRightHorizontalSpaceConstraint.constant = (sizeDiff/2)*(-1);
  }
  
  if (self.fileId != nil) {
    [cell.imageLoadingIndicator startAnimating];
    
    if ([self.fileId containsString:@".svg"]) {
      SVGKImage* newImage;
      newImage = [SVGKImage imageWithContentsOfURL:[NSURL URLWithString:self.fileId]];
      cell.image.image = newImage.UIImage;
      
      [cell.image removeConstraint:cell.imageRatioConstraint];
      cell.imageRatioConstraint =[NSLayoutConstraint
                                       constraintWithItem:cell.image
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:cell.image
                                       attribute:NSLayoutAttributeHeight
                                       multiplier:(newImage.size.width/newImage.size.height)
                                       constant:0.0f];
      
      [cell.image addConstraint:cell.imageRatioConstraint];
      [cell needsUpdateConstraints];
      if (cell.image.frame.size.height == 0 && cell.image.frame.size.width > 0) {
        [tableView reloadData];
      }
      
      [cell.imageLoadingIndicator stopAnimating];
    } else {
      [cell.image sd_setImageWithURL:[NSURL URLWithString:self.fileId]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             [cell.image removeConstraint:cell.imageRatioConstraint];
                             cell.imageRatioConstraint =[NSLayoutConstraint
                                                              constraintWithItem:cell.image
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                              toItem:cell.image
                                                              attribute:NSLayoutAttributeHeight
                                                              multiplier:(image.size.width/image.size.height)
                                                              constant:0.0f];
                             
                             [cell.image addConstraint:cell.imageRatioConstraint];
                             [cell needsUpdateConstraints];
                             if (cell.image.frame.size.height == 0 && cell.image.frame.size.width > 0) {
                               [tableView reloadData];
                             }
                             
                             [cell.imageLoadingIndicator stopAnimating];
                           }];
    }
  }
  
  return cell;
}

@end
