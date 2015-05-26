//
//  XMMImageUtility.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 21.05.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "XMMImageUtility.h"

@implementation XMMImageUtility

+ (void)imageWithUrl:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image, SVGKImage *svgImage))completionBlock {
  
  if ([url containsString:@".gif"]) {
    [self downloadAnimatedImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
      completionBlock(YES, image, nil);
    }];
    
  } else if ([url containsString:@".svg"]) {
    [self downloadSVGImageWithURL:url completionBlock:^(BOOL succeeded, SVGKImage *image) {
      completionBlock(YES, nil, image);
    }];
  } else if(url != nil) {
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
      completionBlock(YES, image, nil);
    }];
  } else {
    completionBlock(NO, nil, nil);
  }
}

+ (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
  NSURL *realUrl = [[NSURL alloc]initWithString:url];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if ( !error )
                           {
                             UIImage *image = [[UIImage alloc] initWithData:data];
                             completionBlock(YES,image);
                           } else{
                             completionBlock(NO,nil);
                           }
                         }];
}

+ (void)downloadAnimatedImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
  NSURL *realUrl = [[NSURL alloc]initWithString:url];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if ( !error ) {
                             UIImage *image = [UIImage animatedImageWithAnimatedGIFData:data];
                             completionBlock(YES,image);
                           } else {
                             completionBlock(NO,nil);
                           }
                         }];
}

+ (void)downloadSVGImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, SVGKImage *image))completionBlock {
  NSURL *realUrl = [[NSURL alloc]initWithString:url];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if ( !error ) {
                             NSArray *paths = NSSearchPathForDirectoriesInDomains
                             (NSDocumentDirectory, NSUserDomainMask, YES);
                             NSString *documentsDirectory = paths[0];
                             NSString *fileName = [NSString stringWithFormat:@"%@/svgimage.svg", documentsDirectory];
                             [data writeToFile:fileName atomically:YES];
                             
                             //read svg mapmarker
                             NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
                             SVGKImage *svgImage = [SVGKImage imageWithSource:[SVGKSourceString sourceFromContentsOfString:
                                                                               [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
                             completionBlock(YES,svgImage);
                           } else {
                             completionBlock(NO,nil);
                           }
                         }];
}

#pragma mark - Image Methods

+ (UIImage *)convertImageToGrayScale:(UIImage *)image {
  // Create image rectangle with current image width/height
  CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
  
  // Grayscale color space
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
  
  // Create bitmap content with current image size and grayscale colorspace
  CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
  
  // Draw image into current context, with specified rectangle
  // using previously defined context (with grayscale colorspace)
  CGContextDrawImage(context, imageRect, [image CGImage]);
  
  // Create bitmap image info from pixel data in current context
  CGImageRef imageRef = CGBitmapContextCreateImage(context);
  
  // Create a new UIImage object
  UIImage *newImage = [UIImage imageWithCGImage:imageRef];
  
  // Release colorspace, context and bitmap information
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  CFRelease(imageRef);
  
  // Return the new grayscale image
  return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
  CGFloat oldWidth = image.size.width;
  CGFloat oldHeight = image.size.height;
  
  CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
  
  CGFloat newHeight = oldHeight * scaleFactor;
  CGFloat newWidth = oldWidth * scaleFactor;
  CGSize newSize = CGSizeMake(newWidth, newHeight);
  
  return [self imageWithImage:image scaledToSize:newSize];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
  } else {
    UIGraphicsBeginImageContext(size);
  }
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

@end
