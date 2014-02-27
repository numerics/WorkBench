//
//  AnimationTransactions.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "AnimationTransactions.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation AnimationTransactions

+ (NSString *)className 
{
	return @"Animation Transactions";
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
	self.backgroundColor = [UIColor whiteColor];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	runButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	runButton.frame = CGRectMake(10., 10., 300., 44.);
	[runButton setTitle:@"Run Animation" forState:UIControlStateNormal];
	[runButton addTarget:self action:@selector(toggleRun:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:runButton];
	
	blueLayer = [[DetailedLayer alloc] init];
	redLayer = [[DetailedLayer alloc] init];
	
	[self.layer addSublayer:blueLayer];
	[self.layer addSublayer:redLayer];

	CGRect rect = CGRectMake(0., 0., 100., 100.);
	blueLayer.backgroundColor =  [[UIColor colorWithRed:0.0 green:0.0 blue:1.0  alpha:0.85] CGColor]; 
	blueLayer.bounds = rect;
	blueLayer.position = CGPointMake(50., 50.);
	blueLayer.cornerRadius = 10.;
	[blueLayer setNeedsDisplay];
	
	redLayer.backgroundColor =  [[UIColor colorWithRed:1.0 green:0.0 blue:0.0  alpha:0.75] CGColor]; 
	redLayer.bounds = rect;
	CGSize viewSize = self.bounds.size;
	redLayer.position = CGPointMake(viewSize.width - 50., viewSize.height - 50.);
	redLayer.cornerRadius = 10.;
	[redLayer setNeedsDisplay];
}

#pragma mark Event Handlers

- (void)toggleRun:(id)sender 
{
	[redLayer removeAnimationForKey:@"changePosition"];
	[blueLayer removeAnimationForKey:@"changePosition"];
	[CATransaction begin];
	{
		[CATransaction setAnimationDuration:2.0];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
		
		CABasicAnimation *moveRed = [CABasicAnimation animationWithKeyPath:@"position"];
		moveRed.toValue = [NSValue valueWithCGPoint:CGPointMake(50., 50.)];
		//moveRed.toValue = [NSValue valueWithCGPoint:CGPointMake(75., self.center.y)];
		[redLayer addAnimation:moveRed forKey:@"changePosition"];
		
		[CATransaction begin];
		{
			[CATransaction setAnimationDuration:2.0];
			[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			CABasicAnimation *moveBlue = [CABasicAnimation animationWithKeyPath:@"position"];
			CGSize viewSize = self.bounds.size;
			
			moveBlue.toValue = [NSValue valueWithCGPoint:CGPointMake(viewSize.width - 50., viewSize.height - 50.)];
		//	moveBlue.toValue = [NSValue valueWithCGPoint:CGPointMake(viewSize.width - 75., self.center.y)];
			[blueLayer addAnimation:moveBlue forKey:@"changePosition"];
		}
		[CATransaction commit];
		
	}
	[CATransaction commit];
}


- (void)dealloc
{
	blueLayer = nil;
	redLayer = nil;
	runButton = nil;
}

@end
