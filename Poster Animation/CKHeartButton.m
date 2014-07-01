//
//  CKHeartButton.m
//  WorkBench
//
//  Created by John Basile on 6/28/14.
//
//

#import "CKHeartButton.h"

@implementation CKHeartButton

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
	x0 = rect.origin.x + 1;
	y0 = rect.origin.y;
	xd = rect.size.width / 80.0;
	yd = rect.size.height / 60.0;
    
	
	UIBezierPath* heartBezPath = [UIBezierPath bezierPath];
	[heartBezPath moveToPoint:     CGPointMake(xd * 40.05 + x0, yd * 60.00 + y0)];
	[heartBezPath addCurveToPoint: CGPointMake(xd * 17.64 + x0, yd * 46.52 + y0) controlPoint1: CGPointMake(xd * 40.05 + x0, yd * 60.00 + y0) controlPoint2: CGPointMake(xd * 27.58 + x0, yd * 54.35 + y0)];
	[heartBezPath addCurveToPoint: CGPointMake(xd *  9.74 + x0, yd *  3.10 + y0) controlPoint1: CGPointMake(xd *  2.84 + x0, yd * 34.82 + y0) controlPoint2: CGPointMake(xd * -9.22 + x0, yd * 13.51 + y0)];
	[heartBezPath addCurveToPoint: CGPointMake(xd * 39.95 + x0, yd * 10.83 + y0) controlPoint1: CGPointMake(xd * 27.99 + x0, yd * -7.01 + y0) controlPoint2: CGPointMake(xd * 39.95 + x0, yd * 10.83 + y0)];
	[heartBezPath addCurveToPoint: CGPointMake(xd * 70.16 + x0, yd *  3.10 + y0) controlPoint1: CGPointMake(xd * 39.95 + x0, yd * 10.83 + y0) controlPoint2: CGPointMake(xd * 51.81 + x0, yd * -7.01 + y0)];
	[heartBezPath addCurveToPoint: CGPointMake(xd * 64.58 + x0, yd * 44.73 + y0) controlPoint1: CGPointMake(xd * 88.21 + x0, yd * 13.01 + y0) controlPoint2: CGPointMake(xd * 78.47 + x0, yd * 33.24 + y0)];
	[heartBezPath addCurveToPoint: CGPointMake(xd * 40.05 + x0, yd * 60.00 + y0) controlPoint1: CGPointMake(xd * 54.04 + x0, yd * 53.56 + y0) controlPoint2: CGPointMake(xd * 40.05 + x0, yd * 60.00 + y0)];
	[heartBezPath closePath];
	heartBezPath.usesEvenOddFillRule = YES;
	
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddPath(path, nil, heartBezPath.CGPath);
	
	
    return path;
}
@end
