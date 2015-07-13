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

#import <Foundation/Foundation.h>

/**
 `XMMRSSEntry` is used for mapping the XML sended by the rss feed.
 */
@interface XMMRSSEntry : NSObject

@property (copy) NSString *title;
@property (copy) NSString *link;
@property (copy) NSString *comments;
@property (copy) NSDate *pubDate;
@property (copy) NSString *category;
@property (copy) NSString *guid;
@property (copy) NSString *descriptionOfContent;
@property (copy) NSString *content;
@property (copy) NSString *wfw;
@property (copy) NSString *slash;

/**
 Returns a description of the `XMMRSSEntry` object.
 
 @return NSString*
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *description;

@end
