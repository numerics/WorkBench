//
//  CKShareButton.m
//  WorkBench
//
//  Created by John Basile on 6/28/14.
//
//

#import "CKShareButton.h"

@implementation CKShareButton

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
	xd = rect.size.width / 86.0;
	yd = rect.size.height / 70.0;
    
	
	UIBezierPath* shareBezPath = [UIBezierPath bezierPath];
	[shareBezPath moveToPoint:		CGPointMake(xd * 85.00 + x0, yd * 27.51 + y0)];
	[shareBezPath addLineToPoint:	CGPointMake(xd * 55.87 + x0, yd * 55.01 + y0)];
	[shareBezPath addLineToPoint:	CGPointMake(xd * 55.87 + x0, yd * 42.49 + y0)];
	[shareBezPath addLineToPoint:	CGPointMake(xd * 26.74 + x0, yd * 42.49 + y0)];
	[shareBezPath addCurveToPoint:	CGPointMake(xd *  0.00 + x0, yd * 70.00 + y0) controlPoint1: CGPointMake(xd * 11.97 + x0, yd * 42.49 + y0) controlPoint2: CGPointMake(xd *  0.00 + x0, yd * 54.81 + y0)];
	[shareBezPath addLineToPoint:	CGPointMake(xd *  0.00 + x0, yd * 37.46 + y0)];
	[shareBezPath addCurveToPoint:	CGPointMake(xd * 26.74 + x0, yd *  9.96 + y0) controlPoint1: CGPointMake(xd *  0.00 + x0, yd * 22.27 + y0) controlPoint2: CGPointMake(xd * 11.97 + x0, yd * 9.96 + y0)];
	[shareBezPath addLineToPoint:	CGPointMake(xd * 55.87 + x0, yd *  9.96 + y0)];
	[shareBezPath addLineToPoint:	CGPointMake(xd * 55.87 + x0, yd *  0.00 + y0)];
	[shareBezPath addLineToPoint:	CGPointMake(xd * 85.00 + x0, yd * 27.51 + y0)];
	[shareBezPath closePath];
	
	
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddPath(path, nil, shareBezPath.CGPath);

	
    return path;
}


@end
