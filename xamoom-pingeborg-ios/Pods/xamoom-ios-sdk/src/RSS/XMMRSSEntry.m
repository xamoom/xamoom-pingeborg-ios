//
// Copyright 2015 by Raphael Seher <raphael@xamoom.com>
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

#import "XMMRSSEntry.h"

@implementation XMMRSSEntry

- (NSString*)description {
  NSMutableString *output = [NSMutableString new];
  [output appendString:[NSString stringWithFormat: @"title: %@ \n", self.title]];
  [output appendString:[NSString stringWithFormat: @"link: %@ \n", self.link]];
  [output appendString:[NSString stringWithFormat: @"comment: %@ \n", self.comments]];
  [output appendString:[NSString stringWithFormat: @"pubDate: %@ \n", self.pubDate]];
  [output appendString:[NSString stringWithFormat: @"guid: %@ \n", self.guid]];
  [output appendString:[NSString stringWithFormat: @"descriptionOfRSS: %@ \n", self.descriptionOfContent]];
  [output appendString:[NSString stringWithFormat: @"content: %@ \n", self.content]];
  [output appendString:[NSString stringWithFormat: @"wfw: %@ \n", self.wfw]];
  [output appendString:[NSString stringWithFormat: @"slash: %@ \n", self.slash]];
  return output;
}

@end
