//
//  LayerTransitions.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
// 


#import "LayerTransitions.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation LayerTransitions

+ (NSString *)className 
{
	return @"Layer Transitions";
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
	}
    return self;
}

#pragma mark Load and unload the view

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSArray *typeItems = [NSArray arrayWithObjects:@"Push", @"Move In", @"Reveal", @"Fade", nil];
	typeSelectControl = [[UISegmentedControl alloc] initWithItems:typeItems];
	typeSelectControl.frame = CGRectMake(10., 10., 300., 44.);
	typeSelectControl.selectedSegmentIndex = 0;
	[evDelegate.benchViewController.parametersView addSubview:typeSelectControl];
	
	NSArray *subtypeItems = [NSArray arrayWithObjects:@"Right", @"Left", @"Top", @"Bottom", nil];
	subtypeSelectControl = [[UISegmentedControl alloc] initWithItems:subtypeItems];
	subtypeSelectControl.frame = CGRectMake(10., 60., 300., 44.);
	subtypeSelectControl.selectedSegmentIndex = 0;
	[evDelegate.benchViewController.parametersView addSubview:subtypeSelectControl];
	
	transitionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	transitionButton.frame = CGRectMake(10., 110., 300., 44.);
	[transitionButton setTitle:@"Start Transition" forState:UIControlStateNormal];
	[transitionButton addTarget:self action:@selector(toggleTransition:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:transitionButton];
	
	blueLayer = [[DetailedLayer alloc] init];
	redLayer = [[DetailedLayer alloc] init];
	containerLayer = [[DetailedLayer alloc] init];
	
	[self.layer addSublayer:containerLayer];
	[containerLayer addSublayer:blueLayer];
	[containerLayer addSublayer:redLayer];
	
	CGRect rect = CGRectMake(0., 0., 240., 240.);
				
	containerLayer.backgroundColor = [[UIColor clearColor] CGColor];
	containerLayer.bounds = rect;
	containerLayer.position = self.center;//CGPointMake(160., 280.);
	[containerLayer setNeedsDisplay];
	
	redLayer.backgroundColor =  [[UIColor colorWithRed:1.0 green:0.0 blue:0.0  alpha:0.75] CGColor];
	redLayer.bounds = rect;
	redLayer.position = CGPointMake(120., 120.);
	redLayer.hidden = YES;
	[redLayer setNeedsDisplay];
	
	blueLayer.backgroundColor =  [[UIColor colorWithRed:0.0 green:0.0 blue:1.0  alpha:0.75] CGColor];
	blueLayer.bounds = rect;
	blueLayer.position = CGPointMake(120., 120.);
	[blueLayer setNeedsDisplay];
	
}

#pragma mark View drawing

#pragma mark Button Event Handlers

- (void)toggleTransition:(id)sender 
{
	CATransition *transition = [CATransition animation];
	transition.duration = .5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	NSString *transitionTypes[4] = { kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade };
	transition.type = transitionTypes[typeSelectControl.selectedSegmentIndex];
	
	NSString *transitionSubtypes[4] = { kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom };
	transition.subtype = transitionSubtypes[subtypeSelectControl.selectedSegmentIndex];
	
	[containerLayer addAnimation:transition forKey:nil];
	blueLayer.hidden = !blueLayer.hidden;
	redLayer.hidden = !redLayer.hidden;
}


- (void)dealloc 
{
	containerLayer = nil;
	blueLayer = nil;
	redLayer = nil;
	transitionButton = nil;
	typeSelectControl = nil;
	subtypeSelectControl = nil;
}

@end
