//
//  Geometry.m
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "Geometry.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation Geometry

+ (NSString *)className 
{
	return @"Geometric Properties";
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
- (void)updatePropertiesLabel 
{
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *temp = [NSString stringWithFormat:@"Bounds: %@  Position: %@\nFrame: %@  Anchor Point: %@",
							   NSStringFromCGRect(simpleLayer.bounds), 
							   NSStringFromCGPoint(simpleLayer.position),
							   NSStringFromCGRect(simpleLayer.frame), 
							   NSStringFromCGPoint(simpleLayer.anchorPoint)];
	
	[evDelegate.benchViewController updateStatusLabel:temp];
}

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	moveAnchorPointButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	moveAnchorPointButton.frame = CGRectMake(10., 10., 145., 44.);
	[moveAnchorPointButton setTitle:@"Move Anchor Point" forState:UIControlStateNormal];
	[moveAnchorPointButton addTarget:self action:@selector(moveAnchorPoint:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:moveAnchorPointButton];
	
	//[self addSubview:moveAnchorPointButton];
	
	movePositionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	movePositionButton.frame = CGRectMake(165., 10., 145., 44.);
	[movePositionButton setTitle:@"Move Position" forState:UIControlStateNormal];
	[movePositionButton addTarget:self action:@selector(movePosition:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:movePositionButton];
	//[self addSubview:movePositionButton];
	
	
	simpleLayer =  [[DetailedLayer alloc] init];		// Sub-classed Layer
	[self.layer addSublayer:simpleLayer];

	simpleLayer.backgroundColor = [[UIColor colorWithRed:0.0 green:1.0 blue:0.0  alpha:0.85] CGColor];
	simpleLayer.bounds = CGRectMake(0., 0., 200., 200.);
	simpleLayer.position = self.center;
	simpleLayer.showAnchor = YES;		// displays a red dot to show the anchor point
	//simpleLayer.delegate = self;
	[simpleLayer setNeedsDisplay];
	[self updatePropertiesLabel];
	
}

#pragma mark View drawing

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context 
{
	CGSize layerSize = self.bounds.size;
	CGPoint layerOrigin = self.bounds.origin;
	CGPoint realAnchorPoint = CGPointMake(layerOrigin.x + (layerSize.width * layer.anchorPoint.x),
										  layerOrigin.y + (layerSize.height * layer.anchorPoint.y));
	
	
	CGRect rect = CGRectMake(realAnchorPoint.x - (8.0 / 2), realAnchorPoint.y - (8.0 / 2), 8.0, 8.0);
	CGContextAddEllipseInRect(context, rect);
	CGContextSetFillColorWithColor(context, [[UIColor redColor]CGColor]);
	CGContextDrawPath(context, kCGPathFill);
}

#pragma mark Button Event Handlers

- (void)moveAnchorPoint:(id)sender 
{
	if(CGPointEqualToPoint(simpleLayer.anchorPoint, CGPointZero)) 
	{
		simpleLayer.anchorPoint = CGPointMake(.5, .5);
	} 
	else 
	{
		simpleLayer.anchorPoint = CGPointZero;
	}
	[simpleLayer setNeedsDisplay];
	[self updatePropertiesLabel];
}

- (void)movePosition:(id)sender 
{
	if(CGPointEqualToPoint(simpleLayer.position, self.center)) 
	{
		CGPoint newPos = self.center;
		newPos.y += 100.;
		simpleLayer.position = newPos;
	} 
	else 
	{
		simpleLayer.position = self.center;
	}
	[simpleLayer setNeedsDisplay];
	[self updatePropertiesLabel];
}

- (void)dealloc 
{
	simpleLayer = nil;
	moveAnchorPointButton = nil;
	movePositionButton = nil;
}


@end
