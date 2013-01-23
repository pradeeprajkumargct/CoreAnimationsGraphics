//
//  BezierInterpView.m
//  SampleDrawing
//
//  Created by Pradeep Rajkumar on 23/01/13.
//  Copyright (c) 2013 Pradeep Rajkumar. All rights reserved.
//

#import "BezierInterpView.h"

@implementation BezierInterpView
{
	UIBezierPath *path;
	UIImage *incrementalImage;
	CGPoint pts[4]; //Keeps track of four bezierpath points
	uint ctr; //Keeps track of the point index
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super initWithCoder:aDecoder])
	{
		[self setMultipleTouchEnabled:NO];
		[self setBackgroundColor:[UIColor whiteColor]];
		path = [UIBezierPath bezierPath];
		[path setLineWidth:3.0];
	}
	return self;
}

- (void) drawRect:(CGRect)rect
{
	[incrementalImage drawInRect:rect];
	[path stroke];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	ctr = 0;
	UITouch *touch =[touches anyObject];
	pts[0] = [touch locationInView:self];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	ctr++;
	pts[ctr] = p;
	if(ctr == 3)
	{
		[path moveToPoint:pts[0]];
		[path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
		[self setNeedsDisplay];
		pts[0] = [path currentPoint];
		ctr = 0;
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self drawBitmap];
	[self setNeedsDisplay];
	pts[0] = [path currentPoint];
	ctr = 0;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void) drawBitmap
{
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
	[[UIColor blackColor] setStroke];
	if(!incrementalImage)
	{
		UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
		[[UIColor whiteColor] setFill];
		[rectpath fill];
	}
	[incrementalImage drawAtPoint:CGPointZero];
	[path stroke];
	incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

@end
