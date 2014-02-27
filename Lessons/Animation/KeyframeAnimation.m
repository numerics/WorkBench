//
//  KeyframeAnimation.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import "KeyframeAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

static const CGRect kMarioStandingSpriteCoords = { .5, 0., .5, 1. };
static const CGRect kMarioJumpingSpriteCoords = { 0., 0., .5, 1. };

@implementation KeyframeAnimation

+ (NSString *)className 
{
	return @"Keyframe Animation";
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
	//NSString *rName;
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor whiteColor];
	
	jumpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	jumpButton.frame = CGRectMake(10., 10., 300., 44.);
	[jumpButton setTitle:@"Jump!" forState:UIControlStateNormal];
	[jumpButton addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:jumpButton];
	
	platformLayer = [[DetailedLayer alloc] init];	
	//rName = @"Platform";
	platformLayer.name = @"Platform";//[rName copy];
	marioLayer = [[DetailedLayer alloc] init];	
	//rName = @"Mario";
	marioLayer.name = @"Mario";//[rName copy];
	
	[self.layer addSublayer:platformLayer];
	[self.layer addSublayer:marioLayer];

	CGSize viewSize = self.bounds.size;
	
	marioLayer.backgroundColor = [[UIColor clearColor] CGColor];
	marioLayer.anchorPoint = CGPointMake(0., 1.);
	marioLayer.bounds = CGRectMake(0., 0., 32., 64.);
	marioLayer.position = CGPointMake(0., viewSize.height);
	marioLayer.contents = (id)[[UIImage imageNamed:@"Mario.png"] CGImage];
	marioLayer.contentsGravity = kCAGravityResizeAspect;
	marioLayer.contentsRect = kMarioStandingSpriteCoords;
	
	platformLayer.backgroundColor = [[UIColor brownColor] CGColor];
	platformLayer.anchorPoint = CGPointZero;
	platformLayer.frame = CGRectMake(160., 200., 160., 20.);
	platformLayer.cornerRadius = 4.;
	[platformLayer setNeedsDisplay];
}

#pragma mark Event Handlers

- (void)jump:(id)sender 
{
	CGSize viewSize = self.bounds.size;
	[marioLayer removeAnimationForKey:@"marioJump"];
	
	CGMutablePathRef jumpPath = CGPathCreateMutable();
	CGPathMoveToPoint(jumpPath, NULL, 0., viewSize.height);
	CGPathAddCurveToPoint(jumpPath, NULL, 30., 140., 170., 140., 170., 200.);
	
	CAKeyframeAnimation *jumpAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	jumpAnimation.path = jumpPath;
	jumpAnimation.duration = 1.;
	jumpAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	jumpAnimation.delegate = self;
	
	CGPathRelease(jumpPath);
	
	[marioLayer addAnimation:jumpAnimation forKey:@"marioJump"];
}

#pragma mark Animation delegate methods

- (void)animationDidStart:(CAAnimation *)theAnimation 
{
	[CATransaction begin];
	{
		[CATransaction setDisableActions:YES];
		marioLayer.contentsRect = kMarioJumpingSpriteCoords;
	}
	[CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished 
{
	[CATransaction begin];
	{
		[CATransaction setDisableActions:YES];
		marioLayer.contentsRect = kMarioStandingSpriteCoords;
		if(finished) 
		{
			marioLayer.position = CGPointMake(170., 200.);
		}
	}
	[CATransaction commit];
}

- (void)dealloc 
{
	platformLayer = nil;
	marioLayer = nil;
	jumpButton = nil;
}
@end
