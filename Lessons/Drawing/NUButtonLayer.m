//
//  NUButtonLayer.m
//  WorkBench
//
//  Created by John Basile on 7/15/13
//  Copyright 2013 John Basile
//

#include "NUButtonLayer.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

const CGFloat kMyLayerWidth = 80.0f;
const CGFloat kMyLayerHeight = 30.0f;

@implementation NUButtonLayer

- (id)init
{
    self = [super init];
    if (self)
	{
        self.needsDisplayOnBoundsChange = YES;
   }
    return self;
}


#pragma mark Setup the View

- (void)drawInContext:(CGContextRef)context
{
    CGRect imageBounds = CGRectMake(0.0f, 0.0f, kMyLayerWidth, kMyLayerHeight);
    CGRect bounds = [self bounds];
    CGColorRef color;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGFloat resolution;
    CGFloat alignStroke;
    CGFloat stroke;
    CGMutablePathRef path;
    CGPoint point;
    CGPoint controlPoint1;
    CGPoint controlPoint2;
    CGGradientRef gradient;
    CFMutableArrayRef colors;
    CGPoint point2;
    CGAffineTransform transform;
    CGFloat components[4];
    CGFloat locations[6];
    
    transform = CGContextGetUserSpaceToDeviceSpaceTransform(context);
    resolution = sqrtf(fabsf(transform.a * transform.d - transform.b * transform.c)) * 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
    CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
    
    // Setup for Shadow Effect
	components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 0.6f;
	color = CGColorCreate(space, components);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f * resolution, 1.0f * resolution), 0.0f * resolution, color);
    CGColorRelease(color);
    CGContextBeginTransparencyLayer(context, NULL);
    
    // Button Color
    
    stroke = 1.0f;
    stroke *= resolution;
    if (stroke < 1.0f)
	{
        stroke = ceilf(stroke);
    }
	else
	{
        stroke = roundf(stroke);
    }
    stroke /= resolution;
    alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
    path = CGPathCreateMutable();
    point = CGPointMake(71.5f, 28.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(79.5f, 20.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(75.889f, 28.5f);
    controlPoint2 = CGPointMake(79.5f, 24.889f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(79.5f, 8.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(71.5f, 0.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(79.5f, 4.111f);
    controlPoint2 = CGPointMake(75.889f, 0.5f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(8.5f, 0.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(0.5f, 8.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(4.111f, 0.5f);
    controlPoint2 = CGPointMake(0.5f, 4.111f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(0.5f, 20.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(8.5f, 28.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(0.5f, 24.889f);
    controlPoint2 = CGPointMake(4.111f, 28.5f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(71.5f, 28.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathCloseSubpath(path);
    components[0] = 0.588f;
    components[1] = 0.075f;
    components[2] = 0.075f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CGContextSetFillColorWithColor(context, color);
    CGColorRelease(color);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    components[0] = 0.1f;
    components[1] = 0.1f;
    components[2] = 0.1f;
    components[3] = 0.0f;
    color = CGColorCreate(space, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGColorRelease(color);
    CGContextSetLineWidth(context, stroke);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    // Button Shine
    
    stroke = 1.0f;
    stroke *= resolution;
    if (stroke < 1.0f)
	{
        stroke = ceilf(stroke);
    }
	else
	{
        stroke = roundf(stroke);
    }
    stroke /= resolution;
    alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
    path = CGPathCreateMutable();
    point = CGPointMake(71.5f, 28.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(79.5f, 20.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(75.889f, 28.5f);
    controlPoint2 = CGPointMake(79.5f, 24.889f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(79.5f, 8.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(71.5f, 0.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(79.5f, 4.111f);
    controlPoint2 = CGPointMake(75.889f, 0.5f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(8.5f, 0.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(0.5f, 8.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(4.111f, 0.5f);
    controlPoint2 = CGPointMake(0.5f, 4.111f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(0.5f, 20.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(8.5f, 28.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(0.5f, 24.889f);
    controlPoint2 = CGPointMake(4.111f, 28.5f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(71.5f, 28.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathCloseSubpath(path);
    colors = CFArrayCreateMutable(NULL, 4, &kCFTypeArrayCallBacks);
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 0.2f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[0] = 1.0f;
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 0.0f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[1] = 0.75f;
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 0.1f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[2] = 0.5f;
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 0.0f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[3] = 0.5f;
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 0.75f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[4] = 0.02f;
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 0.6f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[5] = 0.02f;
    gradient = CGGradientCreateWithColors(space, colors, locations);
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextEOClip(context);
    point = CGPointMake(40.0f, 0.833f);
    point2 = CGPointMake(40.0f, 28.167f);
    CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
    CGContextRestoreGState(context);
    CFRelease(colors);
    CGGradientRelease(gradient);
    components[0] = 0.1f;
    components[1] = 0.1f;
    components[2] = 0.1f;
    components[3] = 0.6f;
    color = CGColorCreate(space, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGColorRelease(color);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    // Shadow Effect
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    CGContextRestoreGState(context);
    CGColorSpaceRelease(space);
}

@end
