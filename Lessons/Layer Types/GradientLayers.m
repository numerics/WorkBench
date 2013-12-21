//
//  GradientLayers.m
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "GradientLayers.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"


@interface GradientLayers ()

- (void)animateGradient:(id)sender;

@end


@implementation GradientLayers

+ (NSString *)className 
{
	return @"Gradient Layers";
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

- (void)animateGradient:(id)sender 
{
	if([gradientLayer animationForKey:@"gradientAnimation"] == nil) 
	{
		CABasicAnimation *endPointAnim = [CABasicAnimation animationWithKeyPath:@"endPoint"];
		endPointAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.05, 0.0)];
		endPointAnim.duration = 1.;
		endPointAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		endPointAnim.repeatCount = FLT_MAX;
		endPointAnim.autoreverses = YES;
		
		[gradientLayer addAnimation:endPointAnim forKey:@"gradientAnimation"];
	} 
	else 
	{
		[gradientLayer removeAnimationForKey:@"gradientAnimation"];
	}
}

#pragma mark Setup the View

- (void)setUpView 
{
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor whiteColor];  
	
	animateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	animateButton.frame = CGRectMake(10., 10., 300., 44.);
	[animateButton setTitle:@"Animate!" forState:UIControlStateNormal];
	[animateButton addTarget:self action:@selector(animateGradient:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:animateButton];
	
	gradientLayer = [CAGradientLayer layer];
	[self.layer addSublayer:gradientLayer];
	
	//gradientLayer.backgroundColor = [[UIColor blueColor] CGColor];
	gradientLayer.bounds = CGRectMake(0., 0., 200., 40.);
	gradientLayer.position = self.center;
	gradientLayer.cornerRadius = 12.;
	gradientLayer.borderWidth = 1.;
	gradientLayer.borderColor = [[UIColor blueColor] CGColor];
	gradientLayer.startPoint = CGPointZero;
	gradientLayer.endPoint = CGPointMake(1.0, 0.0);
	gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor blueColor] CGColor], nil];
}


- (void)dealloc 
{
	gradientLayer = nil;
	animateButton = nil;
}

@end
