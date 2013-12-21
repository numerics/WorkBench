//
//  StripeLayer.m
//  WorkBench
//
//  Created by John Basile on 5/11/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "StripeLayer.h"


@implementation StripeLayer

- (id)init
{
	if((self = [super init]))
	{
		parentBoundWith = 300.0;
		parentBoundHeight = 200.0;
		[self setOpaque:NO];
	}
	return self;
}
- (void)drawInContext:(CGContextRef)context 
{
	UIColor *color;
	NSMutableArray *colors;
	CGMutablePathRef path;
	CGFloat locations[2];
	CGGradientRef gradient;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGRect pathBounds;
	CGAffineTransform transform;

	CGContextSaveGState(context);
	
	CGRect drawRect;
	path = CGPathCreateMutable();
	drawRect = self.bounds;
	CGPathAddRect(path, NULL, drawRect);
	CGPathCloseSubpath(path);
	
	colors = [NSMutableArray arrayWithCapacity:2];
	color = [UIColor colorWithRed:0.31f green:0.596f blue:1.0f alpha:0.5f];
	[colors addObject:(id)[color CGColor]];
	locations[0] = 0.0f;
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
	[colors addObject:(id)[color CGColor]];
	locations[1] = 1.0f;
	gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, locations);
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	pathBounds = CGPathGetPathBoundingBox(path);
	transform = CGAffineTransformMakeTranslation(CGRectGetMidX(pathBounds), CGRectGetMidY(pathBounds));
	transform = CGAffineTransformScale(transform, 0.5f * pathBounds.size.width, 0.5f * pathBounds.size.height);
	CGContextConcatCTM(context, transform);
	CGContextDrawRadialGradient(context, gradient, CGPointZero, 1.0f, CGPointMake(0.0f, 0.0f), 0.0f, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	CGGradientRelease(gradient);
	CGPathRelease(path);

	CGContextRestoreGState(context);
}

@end
