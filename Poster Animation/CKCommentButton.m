//
//  CKCommentButton.m
//  WorkBench
//
//  Created by John Basile on 6/28/14.
//
//

#import "CKCommentButton.h"

@implementation CKCommentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame buttontype:kCBNotchedButton];
    if (self)
	{
		
    }
    return self;
}

-(CGMutablePathRef)createFrame:(CGRect)rect
{
	
	CGFloat x0,y0,xd,yd;
	x0 = rect.origin.x;
	y0 = rect.origin.y;
	xd = rect.size.width / 85.0;
	yd = rect.size.height / 75.0;
    
	
	UIBezierPath* commentBezPath = [UIBezierPath bezierPath];
    [commentBezPath moveToPoint:	 CGPointMake(xd * 56.60 + x0, yd * 75.00 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 57.50 + x0, yd * 73.70 + y0)		controlPoint1: CGPointMake(xd * 57.00 + x0, yd * 74.50 + y0)		controlPoint2: CGPointMake(xd * 57.30 + x0, yd * 74.10 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 66.13 + x0, yd * 60.92 + y0)		controlPoint1: CGPointMake(xd * 60.41 + x0, yd * 69.41 + y0)		controlPoint2: CGPointMake(xd * 63.22 + x0, yd * 65.11 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 69.24 + x0, yd * 56.62 + y0)		controlPoint1: CGPointMake(xd * 67.14 + x0, yd * 59.42 + y0)		controlPoint2: CGPointMake(xd * 67.84 + x0, yd * 57.32 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 74.76 + x0, yd * 56.32 + y0)		controlPoint1: CGPointMake(xd * 70.75 + x0, yd * 55.83 + y0)		controlPoint2: CGPointMake(xd * 72.86 + x0, yd * 56.32 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 85.00 + x0, yd * 46.14 + y0)		controlPoint1: CGPointMake(xd * 80.99 + x0, yd * 56.32 + y0)		controlPoint2: CGPointMake(xd * 84.90 + x0, yd * 52.43 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 85.00 + x0, yd * 10.19 + y0)		controlPoint1: CGPointMake(xd * 85.00 + x0, yd * 34.15 + y0)		controlPoint2: CGPointMake(xd * 85.00 + x0, yd * 22.17 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 74.66 + x0, yd *  0.00 + y0)		controlPoint1: CGPointMake(xd * 85.00 + x0, yd *  3.89 + y0)		controlPoint2: CGPointMake(xd * 81.09 + x0, yd *  0.00 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 10.34 + x0, yd *  0.00 + y0)		controlPoint1: CGPointMake(xd * 53.19 + x0, yd *  0.00 + y0)		controlPoint2: CGPointMake(xd * 31.81 + x0, yd *  0.00 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd *  0.00 + x0, yd * 10.39 + y0)		controlPoint1: CGPointMake(xd *  3.91 + x0, yd *  0.00 + y0)		controlPoint2: CGPointMake(xd *  0.00 + x0, yd *  3.89 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd *  0.00 + x0, yd * 46.04 + y0)		controlPoint1: CGPointMake(xd *  0.00 + x0, yd * 22.27 + y0)		controlPoint2: CGPointMake(xd *  0.00 + x0, yd * 34.15 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 10.44 + x0, yd * 56.42 + y0)		controlPoint1: CGPointMake(xd *  0.00 + x0, yd * 52.53 + y0)		controlPoint2: CGPointMake(xd *  3.91 + x0, yd * 56.42 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 42.75 + x0, yd * 56.42 + y0)		controlPoint1: CGPointMake(xd * 21.17 + x0, yd * 56.42 + y0)		controlPoint2: CGPointMake(xd * 32.01 + x0, yd * 56.42 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 44.76 + x0, yd * 57.52 + y0)		controlPoint1: CGPointMake(xd * 43.65 + x0, yd * 56.42 + y0)		controlPoint2: CGPointMake(xd * 44.26 + x0, yd * 56.72 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 55.60 + x0, yd * 73.80 + y0)		controlPoint1: CGPointMake(xd * 48.37 + x0, yd * 62.92 + y0)		controlPoint2: CGPointMake(xd * 51.98 + x0, yd * 68.41 + y0)];
    [commentBezPath addCurveToPoint: CGPointMake(xd * 56.60 + x0, yd * 75.00 + y0)		controlPoint1: CGPointMake(xd * 55.90 + x0, yd * 74.00 + y0)		controlPoint2: CGPointMake(xd * 56.20 + x0, yd * 74.40 + y0)];
	[commentBezPath closePath];
	commentBezPath.miterLimit = 4;
	
	
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddPath(path, nil, commentBezPath.CGPath);
	
	
    return path;
}
@end
