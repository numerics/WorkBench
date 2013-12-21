//
//  StyleProperties.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//



#import "StyleProperties.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"


@implementation StyleProperties

+ (NSString *)className 
{
	return @"Style Properties";
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
	}
    return self;
}

#pragma mark Setup the View

- (void)setUpView 
{
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor whiteColor];
	
	roundCornersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	roundCornersButton.frame = CGRectMake(10., 10., 145., 44.);
	[roundCornersButton setTitle:@"Round Corners" forState:UIControlStateNormal];
	[roundCornersButton addTarget:self action:@selector(roundCorners:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:roundCornersButton];
	
	toggleBorderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	toggleBorderButton.frame = CGRectMake(165., 10., 145., 44.);
	[toggleBorderButton setTitle:@"Toggle Border" forState:UIControlStateNormal];
	[toggleBorderButton addTarget:self action:@selector(toggleBorder:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:toggleBorderButton];
	
	toggleOpacityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	toggleOpacityButton.frame = CGRectMake(10., 60., 145., 44.);
	[toggleOpacityButton setTitle:@"Toggle Opacity" forState:UIControlStateNormal];
	[toggleOpacityButton addTarget:self action:@selector(toggleOpacity:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:toggleOpacityButton];
	
	toggleMaskButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	toggleMaskButton.frame = CGRectMake(165., 60., 145., 44.);
	[toggleMaskButton setTitle:@"Toggle Mask Layer" forState:UIControlStateNormal];
	[toggleMaskButton addTarget:self action:@selector(toggleMaskLayer:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:toggleMaskButton];
    
    CGFloat left = 0.0;
    CGFloat right = 290;
    CGFloat top = 0.0;
    CGFloat bottom = 125.0;
	CGFloat topLeftEdgeInset = 10.0;
    CGFloat topRightEdgeInset = 10.0, bottomLeftEdgeInset = 10.0, bottomRightEdgeInset = 10.0;
    
	simpleLayer = [CALayer layer];// [[DetailedLayer alloc] init];
	[self.layer addSublayer:simpleLayer];
    
	maskLayer = [CAShapeLayer layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint   (path, NULL, left  + topLeftEdgeInset,top           );
    CGPathAddLineToPoint(path, NULL, right - topRightEdgeInset,top          );
    CGPathAddLineToPoint(path, NULL, right,  top + topRightEdgeInset        );
    CGPathAddLineToPoint(path, NULL, right,  bottom - bottomRightEdgeInset  );
    CGPathAddLineToPoint(path, NULL, right - bottomRightEdgeInset , bottom  );
    CGPathAddLineToPoint(path, NULL, left  + bottomLeftEdgeInset , bottom   );
    CGPathAddLineToPoint(path, NULL, left ,  bottom - bottomLeftEdgeInset   );
    CGPathAddLineToPoint(path, NULL, left,   top + topLeftEdgeInset         );
    CGPathCloseSubpath(path);
    
    
    maskLayer.path = path;
 
	simpleLayer.backgroundColor = [[UIColor greenColor] CGColor];
	simpleLayer.bounds = CGRectMake(0., 0., 290  , 125);
	simpleLayer.position = self.center;
	[simpleLayer setNeedsDisplay];
	simpleLayer.mask  = maskLayer;
 	simpleLayer.contents = (id)[[UIImage imageNamed:@"Ben"] CGImage];

}

#pragma mark Event Handlers
- (void)toggleMaskLayer:(id)sender
{
    CALayer *mask;
    //	CALayer *mask = (simpleLayer.mask == nil) ? maskLayer : nil;
    if( simpleLayer.mask == nil )
        mask = maskLayer;
    else
        mask = nil;
    
	simpleLayer.mask = mask;
}

- (void)roundCorners:(id)sender 
{
	if(simpleLayer.cornerRadius > 0.) 
	{
		simpleLayer.cornerRadius = 0.;
	} 
	else 
	{
		simpleLayer.cornerRadius = 25.;
	}
}

- (void)toggleBorder:(id)sender 
{
	if(simpleLayer.borderWidth > 0.) 
	{
		simpleLayer.borderWidth = 0.;
	} 
	else 
	{
		simpleLayer.borderWidth = 4.;
		simpleLayer.borderColor = [[UIColor redColor] CGColor];
	}
}

- (void)toggleOpacity:(id)sender 
{
	if(simpleLayer.opacity < 1.) 
	{
		simpleLayer.opacity = 1.;
	} 
	else 
	{
		simpleLayer.opacity = .25;
	}
}



- (void)dealloc 
{
	simpleLayer = nil;
	maskLayer = nil;
	roundCornersButton = nil;
	toggleBorderButton = nil;
	toggleOpacityButton = nil;
	toggleMaskButton = nil;
}
@end
