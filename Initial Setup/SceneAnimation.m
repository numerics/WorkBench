//
//  myAnim.m
//  Touches
//
//  Created by John Basile on 1/14/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "SceneAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import "DetailedLayer.h"

@implementation SceneAnimation

@synthesize root = _root;
@synthesize layers = _layers;

#define redColor1	0.960478
#define greenColor1	0.466699
#define blueColor1	0.306221

BOOL scenePause = NO;

+ (NSString *)className 
{
	return @"Scene Animation";
}

CATransform3D Transform2Dto3D( CGFloat trlx, CGFloat trly, CGFloat rot, CGFloat sclx, CGFloat scly)
{
	CGAffineTransform t1, t2, t3;
	t1 = CGAffineTransformMakeTranslation(trlx, trly);
	t2 = CGAffineTransformRotate(t1,  rot);
	t3 = CGAffineTransformScale(t2, sclx, scly);
	return CATransform3DMakeAffineTransform(t3);
}

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	playButton.frame = CGRectMake(10., 10., 145., 44.);
	[playButton setTitle:@"Play" forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:playButton];
	
	//[self addSubview:moveAnchorPointButton];
	
	stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	stopButton.frame = CGRectMake(165., 10., 145., 44.);
	[stopButton setTitle:@"Stop" forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:stopButton];
			
	_root = [CALayer layer];
	
	_layers = [self makeSceneWithRoot:_root];
	_animTracks = [self makeAnimTracks];
	[self.layer addSublayer:_root];

}

- (NSDictionary*)makeSceneWithRoot:(CALayer*)animRoot
{
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGFloat components[4]; 
	components[3] = 1.0;
	components[0] = redColor1; components[1] = greenColor1; components[2] = blueColor1;
    CGColorRef colorComponent = CGColorCreate(colorspace, components);
	
	CALayer *Empty_ = [CALayer layer];
	Empty_.transform = Transform2Dto3D(0.0, 0.0, 0.0, 1.0, 1.0);
	[animRoot addSublayer:Empty_];
	
	DetailedLayer *torso = [[DetailedLayer alloc] init];//[CALayer layer];
	torso.transform = Transform2Dto3D(200.00, 400.00, 0.0, 1.0, 1.0);
	torso.name = @"torso";
	torso.showAnchor = YES;
	torso.brownAnchor = YES;
	torso.bounds = CGRectMake(0.00, 0.00, 22.00, 144.00);
	torso.anchorPoint = CGPointMake(0.50, 0.50);
	torso.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(11.00, 244.00));
	torso.backgroundColor = colorComponent;
	[Empty_ addSublayer:torso];
	[torso setNeedsDisplay];
	
	DetailedLayer *neck = [[DetailedLayer alloc] init];//[CALayer layer];
	neck.transform = Transform2Dto3D(0.259262, -242.625107, 0.261799, 1.0, 1.0);
	neck.opacity = 0.5;
	neck.name = @"neck";
	neck.showAnchor = YES;
	neck.brownAnchor = YES;
	
	neck.bounds = CGRectMake(0.00, 0.00, 24.00, 34.00);
	neck.anchorPoint = CGPointMake(0.50, 1.00);
	neck.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(12.00, 34.00));
	neck.backgroundColor = colorComponent;
	[torso addSublayer:neck];
	[neck setNeedsDisplay];
	
	DetailedLayer *head = [[DetailedLayer alloc] init];//[CALayer layer];
	head.transform = Transform2Dto3D(0.0, -80.00, 0.0, 1.0, 1.0);
	head.name = @"head";
	head.showAnchor = YES;
	head.brownAnchor = YES;
	
	head.bounds = CGRectMake(0.00, 0.00, 96.00, 96.00);
	head.cornerRadius = 48.0;
	head.anchorPoint = CGPointMake(0.50, 0.50);
	head.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(48.00, 48.00));
	head.backgroundColor = colorComponent;
	[neck addSublayer:head];
	[neck setNeedsDisplay];
	
	DetailedLayer *leftForArm = [[DetailedLayer alloc] init];//[CALayer layer];
	leftForArm.transform = Transform2Dto3D(10.0, -231.975098, 1.221730, 1.0, 1.0);
	leftForArm.name = @"leftForArm";
	leftForArm.showAnchor = YES;
	leftForArm.brownAnchor = YES;
	
	leftForArm.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	leftForArm.anchorPoint = CGPointMake(0.00, 0.50);
	leftForArm.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0.00, 12.00));
	leftForArm.backgroundColor = colorComponent;
	[torso addSublayer:leftForArm];
	[leftForArm setNeedsDisplay];
	
	DetailedLayer *leftArm = [[DetailedLayer alloc] init];//[CALayer layer];
	leftArm.transform = Transform2Dto3D(70.00, 0.35, M_PI, 1.0, 1.0);
	leftArm.name = @"leftArm";
	leftArm.showAnchor = YES;
	leftArm.brownAnchor = YES;
	
	leftArm.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	leftArm.anchorPoint = CGPointMake(1.00, 0.50);
	leftArm.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	leftArm.backgroundColor = colorComponent;
	[leftForArm addSublayer:leftArm];
	[leftArm setNeedsDisplay];
	
	DetailedLayer *rightForArm = [[DetailedLayer alloc] init];//[CALayer layer];
	rightForArm.transform = Transform2Dto3D(-10.00, -231.625092, -1.221730, 1.0, 1.0);
	rightForArm.name = @"rightForArm";
	rightForArm.showAnchor = YES;
	rightForArm.brownAnchor = YES;
	
	rightForArm.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	rightForArm.anchorPoint = CGPointMake(1.00, 0.50);
	rightForArm.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	rightForArm.backgroundColor = colorComponent;
	[torso addSublayer:rightForArm];
	[rightForArm setNeedsDisplay];
	
	DetailedLayer *rightArm = [[DetailedLayer alloc] init];//[CALayer layer];
	rightArm.transform = Transform2Dto3D(-70.00, 0.0, 0.0, 1.0, 1.0);
	rightArm.name = @"rightArm";
	rightArm.showAnchor = YES;
	rightArm.brownAnchor = YES;
	
	rightArm.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	rightArm.anchorPoint = CGPointMake(1.00, 0.50);
	rightArm.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	rightArm.backgroundColor = colorComponent;
	[rightForArm addSublayer:rightArm];
	[rightArm setNeedsDisplay];
	
	DetailedLayer *leftThigh = [[DetailedLayer alloc] init];//[CALayer layer];
	leftThigh.transform = Transform2Dto3D(-5.00, -107.00, -M_PI_2, 1.0, 1.0);
	leftThigh.name = @"leftThigh";
	leftThigh.showAnchor = YES;
	leftThigh.brownAnchor = YES;
	
	leftThigh.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	leftThigh.anchorPoint = CGPointMake(1.00, 0.50);
	leftThigh.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	leftThigh.backgroundColor =  colorComponent;
	[torso addSublayer:leftThigh];
	[leftThigh setNeedsDisplay];
	
	DetailedLayer *leftLeg = [[DetailedLayer alloc] init];//[CALayer layer];
	leftLeg.transform = Transform2Dto3D(-70.00, 0.0, 0.0, 1.0, 1.0);
	leftLeg.name = @"leftLeg";
	leftLeg.showAnchor = YES;
	leftLeg.brownAnchor = YES;
	
	leftLeg.bounds = CGRectMake(0.00, 0.00, 86.50, 24.00);
	leftLeg.anchorPoint = CGPointMake(1.00, 0.50);
	leftLeg.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(86.50, 12.00));
	leftLeg.backgroundColor = colorComponent;
	[leftThigh addSublayer:leftLeg];
	[leftLeg setNeedsDisplay];
	
	DetailedLayer *leftFoot = [[DetailedLayer alloc] init];//[CALayer layer];
	leftFoot.transform = Transform2Dto3D(-74.625122, 0.009674, -M_PI_2, 1.0, 1.0);
	leftFoot.name = @"leftFoot";
	leftFoot.showAnchor = YES;
	leftFoot.brownAnchor = YES;
	
	leftFoot.bounds = CGRectMake(0.00, 0.00, 36.50, 24.00);
	leftFoot.anchorPoint = CGPointMake(1.00, 0.50);
	leftFoot.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(36.50, 12.00));
	leftFoot.backgroundColor = colorComponent;
	[leftLeg addSublayer:leftFoot];
	[leftFoot setNeedsDisplay];
	
	DetailedLayer *rightThigh = [[DetailedLayer alloc] init];//[CALayer layer];
	rightThigh.transform = Transform2Dto3D(5.00, -107.0, -2.617994, 1.0, 1.0);
	rightThigh.name = @"rightThigh";
	rightThigh.showAnchor = YES;
	rightThigh.brownAnchor = YES;
	
	rightThigh.bounds = CGRectMake(0.00, 0.00, 74.00, 24.00);
	rightThigh.anchorPoint = CGPointMake(1.00, 0.50);
	rightThigh.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(74.00, 12.00));
	rightThigh.backgroundColor = colorComponent;
	[torso addSublayer:rightThigh];
	[rightThigh setNeedsDisplay];
	
	DetailedLayer *rightLeg = [[DetailedLayer alloc] init];//[CALayer layer];
	rightLeg.transform = Transform2Dto3D(-69.713, 0.24, M_PI_2, 1.0, 1.0);
	rightLeg.name = @"rightLeg";
	rightLeg.showAnchor = YES;
	rightLeg.brownAnchor = YES;
	
	rightLeg.bounds = CGRectMake(0.00, 0.00, 86.50, 24.00);
	rightLeg.anchorPoint = CGPointMake(1.00, 0.50);
	rightLeg.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(86.50, 12.00));
	rightLeg.backgroundColor = colorComponent;
	[rightThigh addSublayer:rightLeg];
	[rightLeg setNeedsDisplay];
	
	DetailedLayer *rightFoot = [[DetailedLayer alloc] init];//[CALayer layer];
	rightFoot.transform = Transform2Dto3D(-75.00, 0.0, -M_PI_2, 1.0, 1.0);
	rightFoot.name = @"rightFoot";
	rightFoot.showAnchor = YES;
	rightFoot.brownAnchor = YES;
	
	rightFoot.bounds = CGRectMake(0.00, 0.00, 36.50, 24.00);
	rightFoot.anchorPoint = CGPointMake(1.00, 0.50);
	rightFoot.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(36.50, 12.00));
	rightFoot.backgroundColor = colorComponent;
	[rightLeg addSublayer:rightFoot];
	[rightFoot setNeedsDisplay];
	
	DetailedLayer *BckScene = [[DetailedLayer alloc] init];//[CALayer layer];
	BckScene.transform = Transform2Dto3D(0.0, 0.0, 0.0, 2.5, 2.50);
	BckScene.name = @"BckScene";
	BckScene.showAnchor = YES;
	BckScene.brownAnchor = YES;
	
	BckScene.bounds = CGRectMake(0.00, 0.00, 244.00, 22.00);
	BckScene.anchorPoint = CGPointMake(0.00, 0.50);
	BckScene.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0.00, 11.00));
	BckScene.backgroundColor = [[UIColor colorWithRed:0.0 green:1.0 blue:0.0  alpha:0.85] CGColor];//CGColorCreate(colorspace, components);
	[Empty_ addSublayer:BckScene];
	[BckScene setNeedsDisplay];
	
	DetailedLayer *sideWalk = [[DetailedLayer alloc] init];//[CALayer layer];
	sideWalk.transform = Transform2Dto3D(0.0, 630.00, 0.0, 1.0, 1.0);
	sideWalk.name = @"BckScene";
	sideWalk.showAnchor = YES;
	sideWalk.brownAnchor = YES;
	
	sideWalk.bounds = CGRectMake(0.00, 0.00, 394.00, 22.00);
	sideWalk.anchorPoint = CGPointMake(0.00, 0.50);
	sideWalk.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0.00, 11.00));
	sideWalk.backgroundColor = colorComponent;
	[animRoot addSublayer:sideWalk];
	[sideWalk setNeedsDisplay];
	
	//[[UIColor colorWithRed:0.0 green:1.0 blue:0.0  alpha:0.85] CGColor];//
	
	CGColorSpaceRelease(colorspace);
	CGColorRelease(colorComponent);
    
	NSDictionary *scene = [NSDictionary dictionaryWithObjectsAndKeys:  Empty_,		@"Empty",
																	   torso,		@"Plane",
																	   head,		@"head",
																	   neck,		@"neck_anim",
																	   leftForArm,	@"leftForArm_anim",
																	   leftArm,		@"leftArm_anim",
																	   rightForArm,	@"rightForArm_anim",
																	   rightArm,	@"rightArm_anim",
																	   leftThigh,	@"leftThigh_anim",
																	   leftLeg,		@"leftLeg_anim",
																	   leftFoot,	@"leftFoot_anim",
																	   rightThigh,	@"rightThigh_anim",
																	   rightLeg,	@"rightLeg_anim",
																	   rightFoot,	@"rightFoot_anim",
																	   BckScene,	@"BckScene",
																	   sideWalk,	@"sideWalk",nil];
	return scene;
}

- (NSDictionary*)makeAnimTracks
{
	CATransform3D tf1, tf2, tf3;

	CAKeyframeAnimation *Plane_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	Plane_anim.keyTimes = [NSArray arrayWithObjects:   [NSNumber numberWithFloat:0.00],
													   [NSNumber numberWithFloat:0.237288],
													   [NSNumber numberWithFloat:0.491525],
													   [NSNumber numberWithFloat:0.745763],
													   [NSNumber numberWithFloat:0.983051],
													   [NSNumber numberWithFloat:1.00],nil];
	
	Plane_anim.values = [NSArray arrayWithObjects:
													 [NSValue valueWithCATransform3D:Transform2Dto3D(200.00, 400.00, 0.00, 1.00, 1.00)],
													 [NSValue valueWithCATransform3D:Transform2Dto3D(200.00, 412.50, 0.00, 1.00, 1.00)],
													 [NSValue valueWithCATransform3D:Transform2Dto3D(200.00, 400.00, 0.00, 1.00, 1.00)],
													 [NSValue valueWithCATransform3D:Transform2Dto3D(200.00, 412.50, 0.00, 1.00, 1.00)],
													 [NSValue valueWithCATransform3D:Transform2Dto3D(200.00, 400.00, 0.00, 1.00, 1.00)],
													 [NSValue valueWithCATransform3D:Transform2Dto3D(200.00, 400.00, 0.00, 1.00, 1.00)],nil];
	Plane_anim.beginTime = 0.00;
	Plane_anim.duration = 4.00;
	Plane_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *neck_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	neck_anim.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.00],
													[NSNumber numberWithFloat:0.237288],
													[NSNumber numberWithFloat:0.491525],
													[NSNumber numberWithFloat:0.745763],
													[NSNumber numberWithFloat:0.983051],
													[NSNumber numberWithFloat:1.00],nil];
	
	neck_anim.values = [NSArray arrayWithObjects:
													  [NSValue valueWithCATransform3D:Transform2Dto3D(0.259262, -242.625107, 0.261799, 1.00, 1.00)],
													  [NSValue valueWithCATransform3D:Transform2Dto3D(0.259262, -242.625092, 0.087266, 1.00, 1.00)],
													  [NSValue valueWithCATransform3D:Transform2Dto3D(0.259262, -242.625107, 0.261799, 1.00, 1.00)],
													  [NSValue valueWithCATransform3D:Transform2Dto3D(0.259262, -242.625092, 0.087266, 1.00, 1.00)],
													  [NSValue valueWithCATransform3D:Transform2Dto3D(0.259262, -242.625107, 0.261799, 1.00, 1.00)],
													  [NSValue valueWithCATransform3D:Transform2Dto3D(0.259262, -242.625107, 0.261799, 1.00, 1.00)],nil];
	neck_anim.beginTime = 0.00;
	neck_anim.duration = 4.00;
	neck_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *leftForArm_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	leftForArm_anim.keyTimes = [NSArray arrayWithObjects:   [NSNumber numberWithFloat:0.00],
															[NSNumber numberWithFloat:0.237288],
															[NSNumber numberWithFloat:0.491525],
															[NSNumber numberWithFloat:0.745763],
															[NSNumber numberWithFloat:0.983051],
															[NSNumber numberWithFloat:1.00],nil];
	
	leftForArm_anim.values = [NSArray arrayWithObjects:
														  [NSValue valueWithCATransform3D:Transform2Dto3D(10.00, -231.975098, 1.221730, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(10.00, -231.975082, 0.872665, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(10.00, -231.975098, 2.181662, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(10.00, -231.975082, 2.094395, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(10.00, -231.975098, 1.308997, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(10.00, -231.975098, 1.221730, 1.00, 1.00)],nil];
	leftForArm_anim.beginTime = 0.00;
	leftForArm_anim.duration = 4.00;
	leftForArm_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *leftArm_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	leftArm_anim.keyTimes = [NSArray arrayWithObjects:  [NSNumber numberWithFloat:0.00],
														[NSNumber numberWithFloat:0.237288],
														[NSNumber numberWithFloat:0.491525],
														[NSNumber numberWithFloat:0.745763],
														[NSNumber numberWithFloat:0.983051],
														[NSNumber numberWithFloat:1.00],nil];
	
	leftArm_anim.values = [NSArray arrayWithObjects:
														  [NSValue valueWithCATransform3D:Transform2Dto3D(70.00, 0.35, M_PI, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(70.00, 0.35, 2.792527, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(70.00, 0.35, M_PI, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(70.00, 0.35, 2.617994, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(70.00, 0.35, 3.054326, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(70.00, 0.35, M_PI, 1.00, 1.00)],nil];
	leftArm_anim.beginTime = 0.00;
	leftArm_anim.duration = 4.00;
	leftArm_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *rightForArm_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	rightForArm_anim.keyTimes = [NSArray arrayWithObjects:  [NSNumber numberWithFloat:0.00],
															[NSNumber numberWithFloat:0.237288],
															[NSNumber numberWithFloat:0.491525],
															[NSNumber numberWithFloat:0.745763],
															[NSNumber numberWithFloat:0.983051],
															[NSNumber numberWithFloat:1.00],nil];
	
	rightForArm_anim.values = [NSArray arrayWithObjects:
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-10.00, -231.625092, -1.221730, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-10.00, -231.625076, -0.872665, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-10.00, -231.625092, -2.094395, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-10.00, -231.625076, -2.268928, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-10.00, -231.625092, -1.396263, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-10.00, -231.625092, -1.221730, 1.00, 1.00)],nil];
	rightForArm_anim.beginTime = 0.00;
	rightForArm_anim.duration = 4.00;
	rightForArm_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *rightArm_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	rightArm_anim.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.00],
														[NSNumber numberWithFloat:0.237288],
														[NSNumber numberWithFloat:0.491525],
														[NSNumber numberWithFloat:0.745763],
														[NSNumber numberWithFloat:0.983051],
														[NSNumber numberWithFloat:1.00],nil];
	
	rightArm_anim.values = [NSArray arrayWithObjects:
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,  0.00,  1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00, -0.698, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,  0.00,  1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00, -0.524, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,  0.00,  1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,  0.00,  1.00, 1.00)],nil];
	rightArm_anim.beginTime = 0.00;
	rightArm_anim.duration = 4.00;
	rightArm_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *leftThigh_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	leftThigh_anim.keyTimes = [NSArray arrayWithObjects:    [NSNumber numberWithFloat:0.00],
															[NSNumber numberWithFloat:0.237288],
															[NSNumber numberWithFloat:0.491525],
															[NSNumber numberWithFloat:0.745763],
															[NSNumber numberWithFloat:0.983051],
															[NSNumber numberWithFloat:1.00],nil];
	
	leftThigh_anim.values = [NSArray arrayWithObjects:
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-5.00, -107.00, -M_PI_2, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-5.00, -107.00, -0.9600, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-5.00, -107.00, -2.7930, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-5.00, -107.00, -2.0070, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-5.00, -107.00, -M_PI_2, 1.00, 1.00)],
														  [NSValue valueWithCATransform3D:Transform2Dto3D(-5.00, -107.00, -M_PI_2, 1.00, 1.00)],nil];
	leftThigh_anim.beginTime = 0.00;
	leftThigh_anim.duration = 4.00;
	leftThigh_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *leftLeg_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	leftLeg_anim.keyTimes = [NSArray arrayWithObjects:  [NSNumber numberWithFloat:0.00],
														[NSNumber numberWithFloat:0.237288],
														[NSNumber numberWithFloat:0.491525],
														[NSNumber numberWithFloat:0.745763],
														[NSNumber numberWithFloat:0.983051],
														[NSNumber numberWithFloat:1.00],nil];
	
	leftLeg_anim.values =     [NSArray arrayWithObjects:
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,   0.00, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,   0.00, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00, M_PI_2, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,   0.00, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,   0.00, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-70.00, 0.00,   0.00, 1.00, 1.00)],nil];
	leftLeg_anim.beginTime = 0.00;
	leftLeg_anim.duration = 4.00;
	leftLeg_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *leftFoot_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	leftFoot_anim.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.00],
														[NSNumber numberWithFloat:0.237288],
														[NSNumber numberWithFloat:0.491525],
														[NSNumber numberWithFloat:0.745763],
														[NSNumber numberWithFloat:0.983051],
														[NSNumber numberWithFloat:1.00],nil];
	
	leftFoot_anim.values =	  [NSArray arrayWithObjects:
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-74.625122, 0.009674, -M_PI_2, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-74.625137, 0.009674, -1.6581, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-74.625153, 0.009674, -M_PI_2, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-74.625122, 0.009720, -M_PI_2, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-74.625122, 0.009689, -M_PI_2, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(-74.625122, 0.009674, -M_PI_2, 1.00, 1.00)],nil];
	leftFoot_anim.beginTime = 0.00;
	leftFoot_anim.duration = 4.00;
	leftFoot_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *rightThigh_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	rightThigh_anim.keyTimes = [NSArray arrayWithObjects:   [NSNumber numberWithFloat:0.00],
															[NSNumber numberWithFloat:0.237288],
															[NSNumber numberWithFloat:0.491525],
															[NSNumber numberWithFloat:0.745763],
															[NSNumber numberWithFloat:0.983051],
															[NSNumber numberWithFloat:1.00],nil];
	
	rightThigh_anim.values =  [NSArray arrayWithObjects:
							  [NSValue valueWithCATransform3D:Transform2Dto3D(5.00, -107.00, -2.617994, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(5.00, -107.00, -2.007129, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(5.00, -107.00,   -M_PI_2, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(5.00, -107.00, -1.047198, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(5.00, -107.00, -2.705260, 1.00, 1.00)],
							  [NSValue valueWithCATransform3D:Transform2Dto3D(5.00, -107.00, -2.617994, 1.00, 1.00)],nil];
	rightThigh_anim.beginTime = 0.00;
	rightThigh_anim.duration = 4.00;
	rightThigh_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *rightLeg_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	rightLeg_anim.keyTimes = [NSArray arrayWithObjects:	  [NSNumber numberWithFloat:0.00],
														  [NSNumber numberWithFloat:0.237288],
														  [NSNumber numberWithFloat:0.491525],
														  [NSNumber numberWithFloat:0.745763],
														  [NSNumber numberWithFloat:0.983051],
														  [NSNumber numberWithFloat:1.00],nil];
	
	tf1 = Transform2Dto3D(-69.7128, 0.241, M_PI_2, 1.0, 1.0);
	tf2 = Transform2Dto3D(-69.7128, 0.241, -0.087266, 1.0, 1.0);
	tf3 = Transform2Dto3D(-69.7128, 0.241, 0.00, 1.0, 1.0);
	
	rightLeg_anim.values = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:tf1],
							[NSValue valueWithCATransform3D:tf2],
							[NSValue valueWithCATransform3D:tf3],
							[NSValue valueWithCATransform3D:tf3],
							[NSValue valueWithCATransform3D:tf1],
							[NSValue valueWithCATransform3D:tf1],nil];
	rightLeg_anim.beginTime = 0.00;
	rightLeg_anim.duration = 4.00;
	rightLeg_anim.repeatCount = FLT_MAX;
	
	CAKeyframeAnimation *rightFoot_anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	rightFoot_anim.keyTimes = [NSArray arrayWithObjects:	[NSNumber numberWithFloat:0.00],
															[NSNumber numberWithFloat:0.237288],
															[NSNumber numberWithFloat:0.491525],
															[NSNumber numberWithFloat:0.745763],
															[NSNumber numberWithFloat:0.983051],
															[NSNumber numberWithFloat:1.00],nil];
	
	tf1 = Transform2Dto3D(-75.0, 0.00, -M_PI_2, 1.0, 1.0);
	tf2 = Transform2Dto3D(-75.0, 0.00, -1.832596, 1.0, 1.0);
	rightFoot_anim.values = [NSArray arrayWithObjects:
															[NSValue valueWithCATransform3D:tf1],
															[NSValue valueWithCATransform3D:tf1],
															[NSValue valueWithCATransform3D:tf1],
															[NSValue valueWithCATransform3D:tf2],
															[NSValue valueWithCATransform3D:tf1],
															[NSValue valueWithCATransform3D:tf1],nil];
	rightFoot_anim.beginTime = 0.00;
	rightFoot_anim.duration = 4.00;
	rightFoot_anim.repeatCount = FLT_MAX;
	
	
	NSDictionary *anims = [NSDictionary dictionaryWithObjectsAndKeys:	Plane_anim,		@"Plane",   
																		neck_anim,		@"neck_anim",
																	   leftForArm_anim,	@"leftForArm_anim",
																	   leftArm_anim,	@"leftArm_anim",
																	   rightForArm_anim,@"rightForArm_anim",
																	   rightArm_anim,	@"rightArm_anim",
																	   leftThigh_anim,	@"leftThigh_anim",
																	   leftLeg_anim,	@"leftLeg_anim",
																	   leftFoot_anim,	@"leftFoot_anim",
																	   rightThigh_anim,	@"rightThigh_anim",
																	   rightLeg_anim,	@"rightLeg_anim",
																	   rightFoot_anim,	@"rightFoot_anim",nil];
	return anims;
}

- (void)play:(id)sender 
{
	if( [playButton.titleLabel.text isEqualToString:@"Play"] )
	{
		if( scenePause )				// I was paused, so now lets resume
		{
			[self resumeAnimation];
			[playButton setTitle:@"Pause" forState:UIControlStateNormal];// set the button label back to Pause...
			scenePause = NO;								// Pause state is over
			return;
		}
		else					// Play (initial or after a Stop )
		{
			for (NSString *key in _layers) 
			{
				CALayer *layer = (CALayer*)[_layers objectForKey:key];
				CAAnimation *anim = (CAAnimation*)[_animTracks objectForKey:key];
				
				[layer addAnimation:anim forKey:@"MyAnim"];
			}
			[playButton setTitle:@"Pause" forState:UIControlStateNormal];// set the button label to Pause...
		}
	}
	else if( [playButton.titleLabel.text isEqualToString:@"Pause"] )
	{
		[self pauseAnimation];					// Pause Animation
		scenePause = YES;								// Pause state is on
		[playButton setTitle:@"Play" forState:UIControlStateNormal];// Set the title, so the next selection will resume Animation.
	}
}

- (void)pauseAnimation 
{
	for (CALayer *layer in [_layers allValues]) 
	{
		CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
		layer.speed = 0.0;
		layer.timeOffset = pausedTime;
	}
}

- (void)stop:(id)sender 
{
	for (CALayer *layer in [_layers allValues]) 
	{
		[layer removeAllAnimations];
	}
	[playButton setTitle:@"Play" forState:UIControlStateNormal];// Set the title, so the next selection will Play Animation.
}

- (void)resumeAnimation 
{
	for (CALayer *layer in [_layers allValues]) 
	{
		CFTimeInterval pausedTime = [layer timeOffset];
		layer.speed = 1.0;
		layer.timeOffset = 0.0;
		layer.beginTime = 0.0;
		CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
		layer.beginTime = timeSincePause;
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
	
}

@end
