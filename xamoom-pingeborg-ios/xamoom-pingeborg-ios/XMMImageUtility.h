//
//  XMMImageUtility.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 21.05.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
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
