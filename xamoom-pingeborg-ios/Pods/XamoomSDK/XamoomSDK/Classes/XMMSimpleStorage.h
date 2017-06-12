//
// Copyright 2017 by xamoom GmbH <apps@xamoom.com>
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
 * Utility for XMMOfflineStorageTagModul to save and read tags.
 */
@interface XMMSimpleStorage : NSObject

@property (strong, nonatomic) NSUserDefaults *userDefaults;

/**
 * Save tags to NSUserDefaults.
 *
 * @param tags NSArray with tags as NSStrings.
 */
- (void)saveTags:(NSArray *)tags;

/**
 * Read tags from NSUserDefaults.
 *
 * @return Saved tags as NSMuteableArray.
 */
- (NSMutableArray *)readTags;

@end
