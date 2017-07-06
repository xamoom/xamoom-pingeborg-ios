//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "UIImage+Scaling.h"

@implementation UIImage (Scaling)

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

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
  CGFloat oldWidth = image.size.width;
  CGFloat oldHeight = image.size.height;
  
  CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
  
  CGFloat newHeight = oldHeight * scaleFactor;
  CGFloat newWidth = oldWidth * scaleFactor;
  CGSize newSize = CGSizeMake(newWidth, newHeight);
  
  return [self imageWithImage:image scaledToSize:newSize];
}

@end
