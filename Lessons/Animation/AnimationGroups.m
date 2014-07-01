//
//  AnimationGroups.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "AnimationGroups.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation AnimationGroups

+ (NSString *)className 
{
	return @"Animation Groups";
}
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

#pragma mark Setup the View

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
	}
    return self;
}

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];

	self.opacity = 1.0;
	self.redValue = 1.0;
	self.greenValue = 1.0;
	self.blueValue = 1.0;
	
    WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIFont *euroBold = [UIFont fontWithName:@"EurostileBold" size:11];
	
	CGFloat y0 = 30.0;
	CGFloat yd = 40.0;
	
	/////////  Alpha Slider + Label
   CGRect frame = CGRectMake(10.0, y0, 160.0, 7.0);
	Alpha = [[UISlider alloc] initWithFrame:frame];
	[Alpha addTarget:self action:@selector(AlphaAction:) forControlEvents:UIControlEventValueChanged];
	Alpha.backgroundColor = [UIColor clearColor];
	
	Alpha.minimumValue = 0.0;
	Alpha.maximumValue = 1.0;
	Alpha.continuous = YES;
	Alpha.value = 1.00;
	[evDelegate.benchViewController.parametersView addSubview:Alpha];
	
	self.alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, y0, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:self.alphaLabel];
	self.alphaLabel.text = [NSString stringWithFormat:@"Alpha = %f",Alpha.value];
	self.alphaLabel.font = euroBold;
	[evDelegate.benchViewController.parametersView addSubview:self.alphaLabel];
	
	
/////////  Red Color Slider  + Label
	y0 = y0 + yd;
	frame = CGRectMake(10.0, y0, 160.0, 16.0);
	redC = [[UISlider alloc] initWithFrame:frame];
	[redC addTarget:self action:@selector(redAction:) forControlEvents:UIControlEventValueChanged];
	redC.backgroundColor = [UIColor clearColor];
	
	redC.minimumValue = 0;
	redC.maximumValue = 255;
	redC.continuous = YES;
	redC.value = 255;
	[evDelegate.benchViewController.parametersView addSubview:redC];
	
	redLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, y0, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:redLabel];
	redLabel.text = [NSString stringWithFormat:@"Red = %.2f",redC.value];
	redLabel.font = euroBold;
	[evDelegate.benchViewController.parametersView addSubview:redLabel];

	
/////////  Green Color Slider  + Label
	y0 = y0 + yd;
	frame = CGRectMake(10.0, y0, 160.0, 7.0);
	greenC = [[UISlider alloc] initWithFrame:frame];
	[greenC addTarget:self action:@selector(greenAction:) forControlEvents:UIControlEventValueChanged];
	greenC.backgroundColor = [UIColor clearColor];
	
	greenC.minimumValue = 0;
	greenC.maximumValue = 255;
	greenC.continuous = YES;
	greenC.value = 255;
	[evDelegate.benchViewController.parametersView addSubview:greenC];

	greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, y0, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:greenLabel];
	greenLabel.text = [NSString stringWithFormat:@"Green = %.2f",greenC.value];
	greenLabel.font = euroBold;
	[evDelegate.benchViewController.parametersView addSubview:greenLabel];

/////////  Blue Color Slider  + Label
	y0 = y0 + yd;
	frame = CGRectMake(10.0, y0, 160.0, 7.0);
	blueC = [[UISlider alloc] initWithFrame:frame];
	[blueC addTarget:self action:@selector(blueAction:) forControlEvents:UIControlEventValueChanged];
	blueC.backgroundColor = [UIColor clearColor];
	
	blueC.minimumValue = 0;
	blueC.maximumValue = 255;
	blueC.continuous = YES;
	blueC.value = 255;
	[evDelegate.benchViewController.parametersView addSubview:blueC];
	
	blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, y0, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:blueLabel];
	blueLabel.text = [NSString stringWithFormat:@"Blue = %.2f",blueC.value];
	blueLabel.font = euroBold;


}

- (void)AlphaAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
    self.opacity = sz;
//	NSString *val = [NSString stringWithFormat:@"Alpha = %.2f",sz];
//	NSLog(val);
	self.alphaLabel.text = [NSString stringWithFormat:@"Alpha = %.2f",sz];
	[self setNeedsDisplay];
}

- (void)redAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
    self.redValue = sz/255.0;
	redLabel.text = [NSString stringWithFormat:@"Red = %.2f",sz];
	[self setNeedsDisplay];
}

- (void)greenAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
    self.greenValue = sz/255.0;
	greenLabel.text = [NSString stringWithFormat:@"Green = %.2f",sz];
	[self setNeedsDisplay];
}

- (void)blueAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
    self.blueValue = sz/255.0;
	blueLabel.text = [NSString stringWithFormat:@"Blue = %.2f",sz];
	[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
	UIColor* colorStroke = [UIColor colorWithRed: 0.005 green: 0.005 blue: 0.005 alpha: 1];
	UIColor* colorFill = [UIColor colorWithRed: self.redValue green: self.greenValue blue: self.blueValue alpha: self.opacity];
	
	

	/// Heart
	//// heartBez Drawing
/*
	CGFloat x0,y0,xd,yd;
	x0 = rect.origin.x;
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
	
	[colorFill setFill];
	[heartBezPath fill];
	[colorStroke setStroke];
	heartBezPath.lineWidth = 1;
	[heartBezPath stroke];
*/
	
	/// Share
	
	//// shareBez Drawing
	
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
	shareBezPath.usesEvenOddFillRule = YES;
	
	[colorFill setFill];
	[shareBezPath fill];
	[colorStroke setStroke];
	shareBezPath.lineWidth = 1;
	[shareBezPath stroke];
	
/*
	//// commentBez Drawing
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
	
	[colorFill setFill];
	[commentBezPath fill];
	[colorStroke setStroke];
	commentBezPath.lineWidth = 1;
	[commentBezPath stroke];
 
 */
}

- (void)dealloc
{
	pulseLayer = nil;
}

@end
