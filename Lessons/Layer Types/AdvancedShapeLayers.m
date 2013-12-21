//
//  AdvancedShapeLayers.m
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import "AdvancedShapeLayers.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation AdvancedShapeLayers

+ (NSString *)className 
{
	return @"Advanced Shape Layers";
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

#pragma mark Setup the View
#pragma mark Load and unload the view

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	
	shapeLayer = [[CAShapeLayer alloc] init];
	[self.layer addSublayer:shapeLayer];
	
	shapeLayer.bounds = CGRectMake(0.f, 0.f, 200.f, 200.f);
	shapeLayer.position = self.center;
	shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
	shapeLayer.lineWidth = 4.f;
	shapeLayer.fillColor = [[UIColor yellowColor] CGColor];
	currentArc = M_PI_2;
	[self drawPathWithArc:currentArc];

	CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePath:)];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

}


#pragma mark View drawing

- (void)drawPathWithArc:(CGFloat)arc 
{
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, 100.f, 100.f);
	CGPathAddLineToPoint(thePath, NULL, 200.f, 100.f);
	CGPathAddArc(thePath, NULL, 100.f, 100.f, 100.f, 0.f, arc, NO);
	CGPathCloseSubpath(thePath);
	shapeLayer.path = thePath;
	CGPathRelease(thePath);
}

- (void)updatePath:(CADisplayLink *)displayLink 
{
	currentArc = fminf(currentArc * 1.1f, M_PI * 1.5f);
	[self drawPathWithArc:currentArc];
	if(currentArc >= M_PI * 1.5f) 
	{
		[displayLink invalidate];
	}
}

- (void)dealloc 
{
	shapeLayer = nil;
}


@end
