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

#import "XMMContentBlockType0.h"

@implementation XMMContentBlockType0

+ (RKObjectMapping*)mapping {
  RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMContentBlockType0 class] ];
  [mapping addAttributeMappingsFromDictionary:@{@"text":@"text",
                                                @"public":@"publicStatus",
                                                @"content_block_type":@"contentBlockType",
                                                @"title":@"title",
                                                }];
  return mapping;
}

+ (RKObjectMappingMatcher*)dynamicMappingMatcher {
  RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                 expectedValue:@"0"
                                                                 objectMapping:[self mapping]];
  return matcher;
}

#pragma mark - XMMTableViewRepresentation

- (UITableViewCell *)tableView:(UITableView *)tableView representationAsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextBlockTableViewCell"];
  if (cell == nil) {
    [tableView registerNib:[UINib nibWithNibName:@"XMMContentBlock0TableViewCell" bundle:nil]
    forCellReuseIdentifier:@"TextBlockTableViewCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"TextBlockTableViewCell"];
  }
  
  cell.titleLabel.text = nil;
  cell.contentTextView.text = nil;
  
  //set title
  if(self.title != nil && ![self.title isEqualToString:@""]) {
    cell.titleLabel.text = self.title;
    [cell.titleLabel setFont:[UIFont systemFontOfSize:[XMMContentBlock0TableViewCell fontSize]+5 weight:UIFontWeightMedium]];
  }
  
  //set content
  if (self.text != nil && ![self.text isEqualToString:@""]) {
    cell.contentTextView.attributedText = [self attributedStringFromHTML:self.text fontSize:[XMMContentBlock0TableViewCell fontSize]];
    [cell.contentTextView sizeToFit];
  } else {
    //make uitextview "disappear"
    [cell.contentTextView setFont:[UIFont systemFontOfSize:0.0f]];
    cell.contentTextView.textContainerInset = UIEdgeInsetsZero;
    cell.contentTextView.textContainer.lineFragmentPadding = 0;
  }
  
  //set the linkcolor to a specific color
  [cell.contentTextView setLinkTextAttributes:@{NSForegroundColorAttributeName : [XMMContentBlock0TableViewCell linkColor], }];
  
  return cell;
}

- (NSMutableAttributedString*)attributedStringFromHTML:(NSString*)html fontSize:(int)fontSize {
  NSError *err = nil;
  
  NSString *style = [NSString stringWithFormat:@"<style>body{font-family: -apple-system, \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif; font-size:%d; margin:0 !important;} p:last-child, p:last-of-type{margin:1px !important;} </style>", fontSize];
  
  html = [html stringByReplacingOccurrencesOfString:@"<br></p>" withString:@"</p>"];
  html = [NSString stringWithFormat:@"%@%@", style, html];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                             documentAttributes: nil
                                                                                          error: &err];
  if(err)
    NSLog(@"Unable to parse label text: %@", err);
  
  return attributedString;
}

@end
