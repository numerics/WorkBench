//
//  BasicAnimation.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "BasicAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"


@implementation BasicAnimation

+ (NSString *)className
{
	return @"Basic Animation";
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
	
	pulseLayer = [[DetailedLayer alloc] init];		// Sub-classed Layer
	[self.layer addSublayer:pulseLayer];
	
	pulseLayer.backgroundColor =  [[UIColor colorWithRed:0.0 green:0.0 blue:0.0  alpha:0.75] CGColor];
	pulseLayer.bounds = CGRectMake(0., 0., 260., 260.);
	pulseLayer.cornerRadius = 12.;
	pulseLayer.position = self.center;
	[pulseLayer setNeedsDisplay];
    
	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	pulseAnimation.duration = .5;
	pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	pulseAnimation.autoreverses = YES;
	pulseAnimation.repeatCount = FLT_MAX;
	
	[pulseLayer addAnimation:pulseAnimation forKey:nil];
	
}

- (void)dealloc
{
	pulseLayer = nil;
}


@end



