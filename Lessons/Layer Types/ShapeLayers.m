//
//  ShapeLayers.m
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "ShapeLayers.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@interface ShapeLayers ()

- (CGMutablePathRef)newRectPathInRect:(CGRect)rect;
- (CGMutablePathRef)newCirclePathInRect:(CGRect)rect;
- (void)animateShape:(id)sender;

@end

@implementation ShapeLayers

+ (NSString *)className 
{
	return @"Shape Layers";
}

#pragma mark init and dealloc

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
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor whiteColor];
	
	animateButtonBox = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	animateButtonBox.frame = CGRectMake(10., 10., 300., 44.);
	[animateButtonBox setTitle:@"Box to Round" forState:UIControlStateNormal];
	[animateButtonBox addTarget:self action:@selector(animateBox:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:animateButtonBox];

	animateButtonStar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	animateButtonStar.frame = CGRectMake(10., 64, 300., 44.);
	[animateButtonStar setTitle:@"Pentagon to Star" forState:UIControlStateNormal];
	[animateButtonStar addTarget:self action:@selector(animateStar:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:animateButtonStar];
	
	//Pentagon Path
	pentagonPath = CGPathCreateMutable();
	CGPoint center = self.center;
	CGPathMoveToPoint(pentagonPath, nil, center.x, center.y - 75.0);
	for(int i = 1; i < 5; ++i)
	{
		CGFloat x = - 75.0 * sinf(i * 2.0 * M_PI / 5.0);
		CGFloat y =  - 75.0 * cosf(i * 2.0 * M_PI / 5.0);
		CGPathAddLineToPoint(pentagonPath, nil,center.x + x, center.y + y);
	}	
	
	//Star Path
	starPath = CGPathCreateMutable();
	center = self.center;
	CGPathMoveToPoint(starPath, NULL, center.x, center.y + 75.0);
	for(int i = 1; i < 5; ++i)
	{
		CGFloat x =  75.0 * sinf(i * 4.0 * M_PI / 5.0);
		CGFloat y =  75.0 * cosf(i * 4.0 * M_PI / 5.0);
		
		CGPathAddLineToPoint(starPath, NULL, center.x + x, center.y + y);
	}
	CGPathCloseSubpath(starPath);
	
	//Square Path
//	squarePath	= CGPathCreateMutable();
//	CGPathMoveToPoint(squarePath, nil, center.x - 75.0, center.y - 75.0);
//	CGPathAddLineToPoint(squarePath, nil, center.x + 75.0, center.y - 75.0);
//	CGPathAddLineToPoint(squarePath, nil, center.x + 75.0, center.y + 75.0);
//	CGPathAddLineToPoint(squarePath, nil, center.x - 75.0, center.y + 75.0);
//	CGPathAddLineToPoint(squarePath, nil, center.x - 75.0, center.y - 75.0);
//	CGPathCloseSubpath(squarePath);
	
	
	//Round Path
	roundPath = CGPathCreateMutable();
	CGPathMoveToPoint(roundPath, nil, center.x , center.y - 75.0);
	CGPathAddArcToPoint(roundPath, nil, center.x + 75.0, center.y - 75.0, center.x + 75.0, center.y + 75.0, 75.0);
	CGPathAddArcToPoint(roundPath, nil, center.x + 75.0, center.y + 75.0, center.x - 75.0, center.y + 75.0, 75.0);
	CGPathAddArcToPoint(roundPath, nil, center.x - 75.0, center.y + 75.0, center.x - 75.0, center.y, 75.0);
	CGPathAddArcToPoint(roundPath, nil, center.x - 75.0, center.y - 75.0, center.x, center.y - 75.0, 75.0);
	CGPathCloseSubpath(roundPath);

	//Box Path
	boxPath = CGPathCreateMutable();
	CGPathMoveToPoint(boxPath, nil, center.x , center.y - 75.0);
	CGPathAddArcToPoint(boxPath, nil, center.x + 75.0, center.y - 75.0, center.x + 75.0, center.y + 75.0, 10.0);
	CGPathAddArcToPoint(boxPath, nil, center.x + 75.0, center.y + 75.0, center.x - 75.0, center.y + 75.0, 10.0);
	CGPathAddArcToPoint(boxPath, nil, center.x - 75.0, center.y + 75.0, center.x - 75.0, center.y, 10.0);
	CGPathAddArcToPoint(boxPath, nil, center.x - 75.0, center.y - 75.0, center.x, center.y - 75.00, 10.0);
	CGPathCloseSubpath(boxPath);
	
//	shapeLayer = [[CAShapeLayer layer] retain];
//	[self.layer addSublayer:shapeLayer];
//
//	shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
//	shapeLayer.frame = CGRectMake(0., 0., 200., 200.);
//	shapeLayer.position = self.center;
//	CGPathRef path = [self newCirclePathInRect:shapeLayer.bounds];
//	shapeLayer.path = path;
//	CGPathRelease(path);
//	
//	[shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
//	shapeLayer.fillColor = [[UIColor blueColor] CGColor];
//	shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
//	shapeLayer.lineWidth = 4.;
//	shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:8], [NSNumber numberWithInt:8], nil];
//	shapeLayer.lineCap = kCALineCapRound;
}

#pragma mark Event Handlers
- (void)animateBox:(id)sender 
{
	if( !shapeLayer )
	{
		shapeLayer = [CAShapeLayer layer];
	}
	shapeLayer.path = boxPath;
	UIColor *fillColor = [UIColor colorWithHue:0.584 saturation:0.8 brightness:0.9 alpha:1.0];
	shapeLayer.fillColor = fillColor.CGColor; 
	UIColor *strokeColor = [UIColor colorWithHue:0.557 saturation:0.55 brightness:0.96 alpha:1.0];
	shapeLayer.strokeColor = strokeColor.CGColor;
	shapeLayer.lineWidth = 3.0;
	shapeLayer.fillRule = kCAFillRuleNonZero;
	[self.layer addSublayer:shapeLayer];
	[self performSelector:@selector(startAnimationBox) withObject:nil afterDelay:1.5];
	
}

- (void)animateStar:(id)sender 
{
	if( !shapeLayer )
	{
		shapeLayer = [CAShapeLayer layer];
	}
	shapeLayer.path = pentagonPath;
	UIColor *fillColor = [UIColor colorWithWhite:0.9 alpha:1.0];
	shapeLayer.fillColor = fillColor.CGColor; 
	shapeLayer.fillRule = kCAFillRuleNonZero;
	[self.layer addSublayer:shapeLayer];
	[self performSelector:@selector(startAnimationStar) withObject:nil afterDelay:0.25];	
}


-(void)startAnimationStar
{	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
	animation.duration = 2.0;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.repeatCount = FLT_MAX;
	animation.autoreverses = YES;
	animation.fromValue = (__bridge id)pentagonPath;
	animation.toValue = (__bridge id)starPath;
	[shapeLayer addAnimation:animation forKey:@"animatePath"];
}

-(void)startAnimationBox
{	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
	animation.duration = 2.0;
	animation.repeatCount = FLT_MAX;
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.fromValue = (__bridge id)boxPath;
	animation.toValue = (__bridge id)roundPath;
	[shapeLayer addAnimation:animation forKey:@"animatePath"];
}


- (void)animateShape:(id)sender 
{
	CGPathRef path;
	BOOL isCircle = [[shapeLayer valueForKey:@"isCircle"] boolValue];
	if(isCircle) 
	{
		path = [self newCirclePathInRect:shapeLayer.bounds];
	} 
	else 
	{
		path = [self newRectPathInRect:shapeLayer.bounds];
	}
	CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
	pathAnim.toValue = (__bridge id)path;
	pathAnim.duration = 1.0;
	pathAnim.delegate = self;
	
	[shapeLayer setValue:[NSNumber numberWithBool:!isCircle] forKey:@"isCircle"];
	[shapeLayer addAnimation:pathAnim forKey:@"animatePath"];
	CGPathRelease(path);
}

#pragma mark Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished 
{
	CGPathRef path;
	BOOL isCircle = [[shapeLayer valueForKey:@"isCircle"] boolValue];
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	if(isCircle) 
	{
		path = [self newRectPathInRect:shapeLayer.bounds];
	} 
	else 
	{
		path = [self newCirclePathInRect:shapeLayer.bounds];
	}
	shapeLayer.path = path;
	CGPathRelease(path);
	[CATransaction commit];
}

#pragma mark Paths

- (CGMutablePathRef)newRectPathInRect:(CGRect)rect 
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, rect);
	return path;
}

- (CGMutablePathRef)newCirclePathInRect:(CGRect)rect 
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect(path, NULL, rect);
	return path;
}


- (void)dealloc 
{
	CGPathRelease(starPath);
	CGPathRelease(pentagonPath);
	shapeLayer = nil;
	animateButtonBox = nil;
	animateButtonStar = nil;
}
@end
