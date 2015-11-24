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

#import "XMMContentBlockType7.h"

@implementation XMMContentBlockType7

+ (RKObjectMapping*)mapping {
  RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMContentBlockType7 class] ];
  [mapping addAttributeMappingsFromDictionary:@{@"soundcloud_url":@"soundcloudUrl",
                                                @"public":@"publicStatus",
                                                @"content_block_type":@"contentBlockType",
                                                @"title":@"title",
                                                }];
  return mapping;
}

+ (RKObjectMappingMatcher*)dynamicMappingMatcher {
  RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                 expectedValue:@"7"
                                                                 objectMapping:[self mapping]];
  return matcher;
}

#pragma mark - XMMTableViewRepresentation

- (UITableViewCell *)tableView:(UITableView *)tableView representationAsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock7TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundcloudBlockTableViewCell"];
  if (cell == nil) {
    [tableView registerNib:[UINib nibWithNibName:@"XMMContentBlock7TableViewCell" bundle:nil]
    forCellReuseIdentifier:@"SoundcloudBlockTableViewCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"SoundcloudBlockTableViewCell"];
  }
  
  //disable scrolling and bouncing
  [cell.webView.scrollView setScrollEnabled:NO];
  [cell.webView.scrollView setBounces:NO];
  
  //set title
  cell.titleLabel.text = self.title;
  
  NSString *soundcloudHTML = [NSString stringWithFormat:@"<iframe width='100%%' height='%f' scrolling='no' frameborder='no' src='https://w.soundcloud.com/player/?url=%@&auto_play=false&hide_related=true&show_comments=false&show_comments=false&show_user=false&show_reposts=false&sharing=false&download=false&buying=false&visual=true'></iframe> <script src=\"https://w.soundcloud.com/player/api.js\" type=\"text/javascript\"></script>",cell.webView.frame.size.height, self.soundcloudUrl];
  
  //display soundcloud in webview
  [cell.webView loadHTMLString:soundcloudHTML baseURL:nil];
  
  return cell;
}

@end
