//
//  myAnim.m
//  Touches
//
//  Created by John Basile on 1/14/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "myAnim.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"


@implementation myAnim

@synthesize root = _root;
@synthesize layers = _layers;

#define redColor1	0.960478
#define greenColor1	0.466699
#define blueColor1	0.306221


+ (NSString *)className 
{
	return @"Scene Animation";
}

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	playButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	playButton.frame = CGRectMake(10., 10., 145., 44.);
	[playButton setTitle:@"Play" forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.ca_ViewController.parametersView addSubview:playButton];
	
	//[self addSubview:moveAnchorPointButton];
	
	stopButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	stopButton.frame = CGRectMake(165., 10., 145., 44.);
	[stopButton setTitle:@"Stop" forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.ca_ViewController.parametersView addSubview:stopButton];
		
	_root = [[CALayer layer] retain];
	
	_layers = [[self makeSceneWithRoot:_root] retain];
	_animTracks = [[self makeAnimTracks] retain];
	[self.layer addSublayer:_root];

}

- (NSDictionary*)makeSceneWithRoot:(CALayer*)animRoot
{
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGFloat components[4]; 
	components[3] = 1.0;
	CGAffineTransform t1, t2, t3;
	
	
	CALayer *Empty_ = [CALayer layer];
	t1 = CGAffineTransformMakeTranslation(0.00, 0.00);
	t2 = CGAffineTransformRotate(t1,  0.0);
//	t3 = CGAffineTransformScale(t2, 0.40, 0.40);
	t3 = CGAffineTransformScale(t2, 1.00, 1.00);
	Empty_.transform = CATransform3DMakeAffineTransform(t3);
//	Empty_.backgroundColor = [[UIColor colorWithRed:0.0 green:1.0 blue:0.0  alpha:0.85] CGColor];
	[animRoot addSublayer:Empty_];
	
	CALayer *torso = [CALayer layer];
	t1 = CGAffineTransformMakeTranslation(200.00, 400.00);
	t2 = CGAffineTransformRotate(t1,  0.0);
	t3 = CGAffineTransformScale(t2, 1.00, 1.00);
	torso.transform = CATransform3DMakeAffineTransform(t3);
	
	torso.bounds = CGRectMake(0.00, 0.00, 22.00, 144.00);
	torso.anchorPoint = CGPointMake(0.50, 1.694444);
	torso.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(11.00, 244.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	torso.backgroundColor = CGColorCreate(colorspace, components);
	[Empty_ addSublayer:torso];
	
	CALayer *neck = [CALayer layer];
	t1 = CGAffineTransformMakeTranslation(0.259262, -242.625107);
	t2 = CGAffineTransformRotate(t1,  0.261799);
	t3 = CGAffineTransformScale(t2, 1.00, 1.00);

	neck.transform = CATransform3DMakeAffineTransform(t3);
	neck.bounds = CGRectMake(0.00, 0.00, 24.00, 34.00);
	neck.anchorPoint = CGPointMake(0.50, 1.00);
	neck.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(12.00, 34.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	neck.backgroundColor = CGColorCreate(colorspace, components);
	[torso addSublayer:neck];
	
	CALayer *head = [CALayer layer];
	head.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.00, -80.00), 0.00), 1.00, 1.00));
	head.bounds = CGRectMake(0.00, 0.00, 96.00, 96.00);
	head.anchorPoint = CGPointMake(0.50, 0.50);
	head.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(48.00, 48.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	head.backgroundColor = CGColorCreate(colorspace, components);
	[neck addSublayer:head];
	
	CALayer *leftForArm = [CALayer layer];
	leftForArm.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(10.00, -231.975098), 1.221730), 1.00, 1.00));
	leftForArm.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	leftForArm.anchorPoint = CGPointMake(0.00, 0.50);
	leftForArm.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0.00, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	leftForArm.backgroundColor = CGColorCreate(colorspace, components);
	[torso addSublayer:leftForArm];
	
	CALayer *leftArm = [CALayer layer];
	leftArm.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(70.00, 0.35), M_PI), 1.00, 1.00));
	leftArm.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	leftArm.anchorPoint = CGPointMake(1.00, 0.50);
	leftArm.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	leftArm.backgroundColor = CGColorCreate(colorspace, components);
	[leftForArm addSublayer:leftArm];
	
	CALayer *rightForArm = [CALayer layer];
	rightForArm.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-10.00, -231.625092), -1.221730), 1.00, 1.00));
	rightForArm.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	rightForArm.anchorPoint = CGPointMake(1.00, 0.50);
	rightForArm.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	rightForArm.backgroundColor = CGColorCreate(colorspace, components);
	[torso addSublayer:rightForArm];
	
	CALayer *rightArm = [CALayer layer];
	rightArm.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00));
	rightArm.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	rightArm.anchorPoint = CGPointMake(1.00, 0.50);
	rightArm.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	rightArm.backgroundColor = CGColorCreate(colorspace, components);
	[rightForArm addSublayer:rightArm];
	
	CALayer *leftThigh = [CALayer layer];
	leftThigh.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-5.00, -107.00), -M_PI_2), 1.00, 1.00));
	leftThigh.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	leftThigh.anchorPoint = CGPointMake(1.00, 0.50);
	leftThigh.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	leftThigh.backgroundColor =  CGColorCreate(colorspace, components);
	[torso addSublayer:leftThigh];
	
	CALayer *leftLeg = [CALayer layer];
	leftLeg.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00));
	leftLeg.bounds = CGRectMake(0.00, 0.00, 86.50, 24.00);
	leftLeg.anchorPoint = CGPointMake(1.00, 0.50);
	leftLeg.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(86.50, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	leftLeg.backgroundColor = CGColorCreate(colorspace, components);
	[leftThigh addSublayer:leftLeg];
	
	CALayer *leftFoot = [CALayer layer];
	leftFoot.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-74.625122, 0.009674), -M_PI_2), 1.00, 1.00));
	leftFoot.bounds = CGRectMake(0.00, 0.00, 36.50, 24.00);
	leftFoot.anchorPoint = CGPointMake(1.00, 0.50);
	leftFoot.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(36.50, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	leftFoot.backgroundColor = CGColorCreate(colorspace, components);
	[leftLeg addSublayer:leftFoot];
	
	CALayer *rightThigh = [CALayer layer];
	rightThigh.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(5.00, -107.00), -2.617994), 1.00, 1.00));
	rightThigh.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	rightThigh.anchorPoint = CGPointMake(1.00, 0.50);
	rightThigh.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	rightThigh.backgroundColor = CGColorCreate(colorspace, components);
	[torso addSublayer:rightThigh];
	
	CALayer *rightLeg = [CALayer layer];
	rightLeg.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-69.712799, 0.24), M_PI_2), 1.00, 1.00));
	rightLeg.bounds = CGRectMake(0.00, 0.00, 86.50, 24.00);
	rightLeg.anchorPoint = CGPointMake(1.00, 0.50);
	rightLeg.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(86.50, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	rightLeg.backgroundColor = CGColorCreate(colorspace, components);
	[rightThigh addSublayer:rightLeg];
	
	CALayer *rightFoot = [CALayer layer];
	rightFoot.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-75.00, 0.00), -M_PI_2), 1.00, 1.00));
	rightFoot.bounds = CGRectMake(0.00, 0.00, 36.50, 24.00);
	rightFoot.anchorPoint = CGPointMake(1.00, 0.50);
	rightFoot.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(36.50, 12.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	rightFoot.backgroundColor = CGColorCreate(colorspace, components);
	[rightLeg addSublayer:rightFoot];
	
	CALayer *BckScene = [CALayer layer];
	BckScene.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.00, 0.00), 0.00), 2.50, 2.50));
	BckScene.bounds = CGRectMake(0.00, 0.00, 244.00, 22.00);
	BckScene.anchorPoint = CGPointMake(0.00, 0.50);
	BckScene.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0.00, 11.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	BckScene.backgroundColor = [[UIColor colorWithRed:0.0 green:1.0 blue:0.0  alpha:0.85] CGColor];//CGColorCreate(colorspace, components);
	[Empty_ addSublayer:BckScene];
	
	CALayer *sideWalk = [CALayer layer];
	sideWalk.transform = CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.00, 460.00), 0.00), 1.00, 1.00));
	sideWalk.bounds = CGRectMake(0.00, 0.00, 394.00, 22.00);
	sideWalk.anchorPoint = CGPointMake(0.00, 0.50);
	sideWalk.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0.00, 11.00));
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
	sideWalk.backgroundColor = CGColorCreate(colorspace, components);
	[animRoot addSublayer:sideWalk];
	
	//[[UIColor colorWithRed:0.0 green:1.0 blue:0.0  alpha:0.85] CGColor];//
	
	CGColorSpaceRelease(colorspace);
	
	NSDictionary *scene = [NSDictionary dictionaryWithObjectsAndKeys:Empty_,@"Empty",torso,@"Plane",neck,@"Plane__002",head,@"Plane__005",leftForArm,@"Plane__003",leftArm,@"Plane__007",rightForArm,@"Plane__004",rightArm,@"Plane__006",leftThigh,@"Plane__008",leftLeg,@"Plane__011",leftFoot,@"Plane__013",rightThigh,@"Plane__009",rightLeg,@"Plane__010",rightFoot,@"Plane__012",BckScene,@"Plane__001",sideWalk,@"Plane__014",nil];
	return scene;
}

- (NSDictionary*)makeAnimTracks
{
	CAKeyframeAnimation *Plane_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(200.00, 400.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(200.00, 412.500), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(200.00, 400.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(200.00, 412.50), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(200.00, 400.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(200.00, 400.00), 0.00), 1.00, 1.00))],nil];
	Plane_anim.beginTime = 0.00;
	Plane_anim.duration = 4.00;
	Plane_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__002_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__002_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__002_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.259262, -242.625107), 0.261799), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.259262, -242.625092), 0.087266), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.259262, -242.625107), 0.261799), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.259262, -242.625092), 0.087266), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.259262, -242.625107), 0.261799), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(0.259262, -242.625107), 0.261799), 1.00, 1.00))],nil];
	Plane__002_anim.beginTime = 0.00;
	Plane__002_anim.duration = 4.00;
	Plane__002_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__003_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__003_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__003_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(10.00, -231.975098), 1.221730), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(10.00, -231.975082), 0.872665), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(10.00, -231.975098), 2.181662), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(10.00, -231.975082), 2.094395), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(10.00, -231.975098), 1.308997), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(10.00, -231.975098), 1.221730), 1.00, 1.00))],nil];
	Plane__003_anim.beginTime = 0.00;
	Plane__003_anim.duration = 4.00;
	Plane__003_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__007_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__007_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__007_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(70.00, 0.35), M_PI), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(70.00, 0.349991), 2.792527), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(70.00, 0.349976), M_PI), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(70.00, 0.349976), 2.617994), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(70.00, 0.35), 3.054326), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(70.00, 0.35), M_PI), 1.00, 1.00))],nil];
	Plane__007_anim.beginTime = 0.00;
	Plane__007_anim.duration = 4.00;
	Plane__007_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__004_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__004_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__004_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-10.00, -231.625092), -1.221730), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-10.00, -231.625076), -0.872665), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-10.00, -231.625092), -2.094395), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-10.00, -231.625076), -2.268928), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-10.00, -231.625092), -1.396263), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-10.00, -231.625092), -1.221730), 1.00, 1.00))],nil];
	Plane__004_anim.beginTime = 0.00;
	Plane__004_anim.duration = 4.00;
	Plane__004_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__006_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__006_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__006_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), -0.698132), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), -0.523599), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],nil];
	Plane__006_anim.beginTime = 0.00;
	Plane__006_anim.duration = 4.00;
	Plane__006_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__008_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__008_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__008_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-5.00, -107.00), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-5.00, -107.00), -0.959931), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-5.00, -107.00), -2.792527), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-5.00, -107.00), -2.007129), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-5.00, -107.00),-M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-5.00, -107.00), -M_PI_2), 1.00, 1.00))],nil];
	Plane__008_anim.beginTime = 0.00;
	Plane__008_anim.duration = 4.00;
	Plane__008_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__011_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__011_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__011_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-70.00, 0.00), 0.00), 1.00, 1.00))],nil];
	Plane__011_anim.beginTime = 0.00;
	Plane__011_anim.duration = 4.00;
	Plane__011_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__013_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__013_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__013_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-74.625122, 0.009674), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-74.625137, 0.009674), -1.658063), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-74.625153, 0.009674), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-74.625122, 0.009720), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-74.625122, 0.009689), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-74.625122, 0.009674), -M_PI_2), 1.00, 1.00))],nil];
	Plane__013_anim.beginTime = 0.00;
	Plane__013_anim.duration = 4.00;
	Plane__013_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__009_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__009_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__009_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(5.00, -107.00), -2.617994), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(5.00, -107.00), -2.007129), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(5.00, -107.00), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(5.00, -107.00), -1.047198), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(5.00, -107.00), -2.705260), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(5.00, -107.00), -2.617994), 1.00, 1.00))],nil];
	Plane__009_anim.beginTime = 0.00;
	Plane__009_anim.duration = 4.00;
	Plane__009_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__010_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__010_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__010_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-69.712799, 0.241), M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-69.712830, 0.240963), -0.087266), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-69.712738, 0.240921), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-69.712799, 0.240967), 0.00), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-69.712830, 0.240921), M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-69.712799, 0.240997), M_PI_2), 1.00, 1.00))],nil];
	Plane__010_anim.beginTime = 0.00;
	Plane__010_anim.duration = 4.00;
	Plane__010_anim.repeatCount = FLT_MAX;
	CAKeyframeAnimation *Plane__012_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane__012_anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:0.237288],[NSNumber numberWithFloat:0.491525],[NSNumber numberWithFloat:0.745763],[NSNumber numberWithFloat:0.983051],[NSNumber numberWithFloat:1.00],nil];
	Plane__012_anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-75.00, 0.00), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-75.00, 0.00), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-75.00, 0.00), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-75.00, 0.00), -1.832596), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-75.00, 0.00), -M_PI_2), 1.00, 1.00))],[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-75.00, 0.00), -M_PI_2), 1.00, 1.00))],nil];
	Plane__012_anim.beginTime = 0.00;
	Plane__012_anim.duration = 4.00;
	Plane__012_anim.repeatCount = FLT_MAX;
	
	
	NSDictionary *anims = [NSDictionary dictionaryWithObjectsAndKeys:Plane_anim,@"Plane",Plane__002_anim,@"Plane__002",Plane__003_anim,@"Plane__003",Plane__007_anim,@"Plane__007",Plane__004_anim,@"Plane__004",Plane__006_anim,@"Plane__006",Plane__008_anim,@"Plane__008",Plane__011_anim,@"Plane__011",Plane__013_anim,@"Plane__013",Plane__009_anim,@"Plane__009",Plane__010_anim,@"Plane__010",Plane__012_anim,@"Plane__012",nil];
	return anims;
}

- (void)play:(id)sender 
{
	for (NSString *key in _layers) 
	{
		CALayer *layer = (CALayer*)[_layers objectForKey:key];
		CAAnimation *anim = (CAAnimation*)[_animTracks objectForKey:key];
		
		[layer addAnimation:anim forKey:@"MyAnim"];
	}
}

- (void)stop:(id)sender 
{
	for (CALayer *layer in [_layers allValues]) 
	{
		[layer removeAllAnimations];
	}
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


- (void)dealloc
{
	// Clean up
	if (_animTracks != nil)
		[self stop:nil];
	for (CALayer *layer in [_layers allValues]) 
	{
		[layer removeFromSuperlayer];
	}
	
	// Release
	[_animTracks release];
	[_layers release];
	[_root release];
	
	[super dealloc];
}

@end
