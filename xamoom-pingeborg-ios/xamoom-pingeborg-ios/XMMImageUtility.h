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
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIImage+animatedGIF.h>
#import <SVGKit.h>
#import <SVGKSourceString.h>

@interface XMMImageUtility : NSObject

/**
 */
+ (void)imageWithUrl:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image, SVGKImage *svgImage))completionBlock;

/**
 */
+ (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

/**
 */
+ (void)downloadAnimatedImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

/**
 */
+ (void)downloadSVGImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, SVGKImage *image))completionBlock;

/**
 */
+ (UIImage *)convertImageToGrayScale:(UIImage *)image;

/**
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;

@end
