//
//  XMMMusicPlayer.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/05/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "XMMMusicPlayer.h"

#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface XMMMusicPlayer ()

@end

IB_DESIGNABLE
@implementation XMMMusicPlayer

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

  CGSize drawingFrameSize = self.bounds.size;
  
  // Create an oval shape to draw.
  UIBezierPath *backgroundRing = [UIBezierPath bezierPathWithArcCenter:CGPointMake((rect.size.width/2), (rect.size.height/2))
                                                                radius:((rect.size.width/2)-(self.ringLineWidth/2))
                                                            startAngle:0
                                                              endAngle:2*M_PI
                                                             clockwise:YES];;
  
  // Set the render colors.
  [self.backgroundRingColor setStroke];
  
  CGContextRef aRef = UIGraphicsGetCurrentContext();
  
  // If you have content to draw after the shape,
  // save the current state before changing the transform.
  //CGContextSaveGState(aRef);
  
  // Adjust the view's origin temporarily. The oval is
  // now drawn relative to the new origin point.
  CGContextTranslateCTM(aRef, 0, 0);
  
  // Adjust the drawing options as needed.
  backgroundRing.lineWidth = self.ringLineWidth;
  
  // Fill the path before stroking it so that the fill
  // color does not obscure the stroked line.
  [backgroundRing stroke];
  
  // Restore the graphics state before drawing any other content.
  //CGContextRestoreGState(aRef);
 
  // Create an oval shape to draw.
  UIBezierPath *foregroundRing = [UIBezierPath bezierPathWithArcCenter:CGPointMake((rect.size.width/2), (rect.size.height/2))
                                                                radius:((rect.size.width/2)-(self.ringLineWidth/2))
                                                            startAngle:0
                                                              endAngle:(2*M_PI)*self.ringProgress
                                                             clockwise:YES];
  
  // Set the render colors.
  [self.foregroundRingColor setStroke];
  
  // If you have content to draw after the shape,
  // save the current state before changing the transform.
  //CGContextSaveGState(aRef);
  
  // Adjust the view's origin temporarily. The oval is
  // now drawn relative to the new origin point.
  CGContextTranslateCTM(aRef, 0, 0);
  
  // Adjust the drawing options as needed.
  foregroundRing.lineWidth = self.ringLineWidth;
  
  // Fill the path before stroking it so that the fill
  // color does not obscure the stroked line.
  [foregroundRing stroke];
  
  // Restore the graphics state before drawing any other content.
  //CGContextRestoreGState(aRef);
}

- (void)layoutSubviews {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  [button setTitle:@"Button title" forState:UIControlStateNormal]; //Set the title for regular state
  [button addTarget:self
             action:@selector(yourMethod:)
   forControlEvents:UIControlEventTouchDown];
  button.frame = CGRectMake(40, 100, 160, 240); //make the frame
  [self.view addSubview:button]; //add to current view
}

@end
