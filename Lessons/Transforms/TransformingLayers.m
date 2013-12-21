//
//  TransformingLayers.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "TransformingLayers.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"


@implementation TransformingLayers

@synthesize cumulative;

+ (NSString *)className 
{
	return @"Transforming Layers";
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
	self.cumulative = YES;
	self.backgroundColor = [UIColor whiteColor];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	moveAnchorPointButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	moveAnchorPointButton.frame = CGRectMake(10., 10., 145., 44.);
	[moveAnchorPointButton setTitle:@"Move Anchor Point" forState:UIControlStateNormal];
	[moveAnchorPointButton addTarget:self action:@selector(moveAnchorPoint:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:moveAnchorPointButton];
	
	rotateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	rotateButton.frame = CGRectMake(165., 10., 145., 44.);
	[rotateButton setTitle:@"Rotate" forState:UIControlStateNormal];
	[rotateButton addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:rotateButton];
	
	scaleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	scaleButton.frame = CGRectMake(10., 60., 145., 44.);
	[scaleButton setTitle:@"Scale" forState:UIControlStateNormal];
	[scaleButton addTarget:self action:@selector(scale:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:scaleButton];
	
	translateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	translateButton.frame = CGRectMake(165., 60., 145., 44.);
	[translateButton setTitle:@"Tanslate" forState:UIControlStateNormal];
	[translateButton addTarget:self action:@selector(translate:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:translateButton];
	
	resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	resetButton.frame = CGRectMake(10., 110., 145., 44.);
	[resetButton setTitle:@"Reset" forState:UIControlStateNormal];
	[resetButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:resetButton];
	
	cumulativeSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	CGRect rect = CGRectMake(165., 110., 145., 44.);
	CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	cumulativeSwitch.center = center;
	cumulativeSwitch.on = self.cumulative;
	[cumulativeSwitch addTarget:self action:@selector(toggleCumulative:) forControlEvents:UIControlEventValueChanged];
	[evDelegate.benchViewController.parametersView addSubview:cumulativeSwitch];
	
	simpleLayer =  [[DetailedLayer alloc] init];		// Sub-classed Layer
	[self.layer addSublayer:simpleLayer];
	simpleLayer.backgroundColor = [[UIColor colorWithRed:0.0 green:1.0 blue:0.0  alpha:0.85] CGColor];
	simpleLayer.bounds = CGRectMake(0., 0., 200., 200.);
	simpleLayer.position = CGPointMake(384.0, 350.0);
	simpleLayer.transform = CATransform3DIdentity;
	simpleLayer.showAnchor = YES;		// displays a red dot to show the anchor point
	[simpleLayer setNeedsDisplay];
	[self updatePropertiesLabel];
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

- (void)rotate:(id)sender 
{
	if(self.cumulative) 
	{
		CATransform3D currentTransform = simpleLayer.transform;
		CATransform3D rotated = CATransform3DRotate(currentTransform, 45., 0., 0., 1.);
		simpleLayer.transform = rotated;
	} 
	else 
	{
		self.layer.sublayerTransform = CATransform3DIdentity;
		simpleLayer.transform = CATransform3DIdentity;
		[simpleLayer setValue:[NSNumber numberWithFloat:45.] forKeyPath:@"transform.rotation.z"];
	}
	[simpleLayer setNeedsDisplay];
	[self updatePropertiesLabel];
}

- (void)scale:(id)sender 
{
	if(self.cumulative) 
	{
		CATransform3D currentTransform = simpleLayer.transform;
		CATransform3D scaled = CATransform3DScale(currentTransform, 1.5, 1.5, 1.5);
		simpleLayer.transform = scaled;
	} 
	else 
	{
		simpleLayer.transform = CATransform3DIdentity;
		[simpleLayer setValue:[NSNumber numberWithFloat:1.5] forKeyPath:@"transform.scale"];
	}
	[simpleLayer setNeedsDisplay];
	[self updatePropertiesLabel];
}

- (void)translate:(id)sender 
{
	CATransform3D translated;
	if(self.cumulative) 
	{
		CATransform3D currentTransform = simpleLayer.transform;
		translated = CATransform3DTranslate(currentTransform, 50., 50., 0.);
	} 
	else 
	{
		// The following is equvalent to:
		// translated = CATransform3DMakeTranslation(50., 50., 0.);
		translated = CATransform3DIdentity;
		translated.m41 = 50.;
		translated.m42 = 50.;
	}
	simpleLayer.transform = translated;
	[simpleLayer setNeedsDisplay];
	[self updatePropertiesLabel];
}

- (void)reset:(id)sender 
{
	simpleLayer.transform = CATransform3DIdentity;
	simpleLayer.anchorPoint = CGPointMake(.5, .5);
	self.layer.sublayerTransform = CATransform3DIdentity;
	[simpleLayer setNeedsDisplay];
	[self updatePropertiesLabel];
}

- (void)toggleCumulative:(id)sender 
{
	self.cumulative = [(UISwitch *)sender isOn];
}



- (void)dealloc 
{
	simpleLayer = nil;
	moveAnchorPointButton = nil;
	rotateButton = nil;
	scaleButton = nil;
	translateButton = nil;
	resetButton = nil;
	cumulativeSwitch = nil;
}


@end
