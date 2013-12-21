//
//  ProgressBar.m
//  WorkBench
//
//  Created by John Basile on 5/5/11.
//  Copyright 2011 DirecTV. All rights reserved.
//

#import "ProgressBar.h"
#import "BarberPole.h"
#import "UIFont+AppDefault.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation ProgressBar
@synthesize messageLabel,statusLabel,progressLayer,barLayer,barberPole;
@synthesize progress = _progress,velocity = _velocity, time = _time;
@synthesize countOfSpheresToGenerate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self drawBar];
        self.progress = .70;
		
        [self drawProgress];
    }
    return self;
}

-(void)setProgress:(CGFloat)p
{
	_progress = p;
    [self setNeedsDisplay];
}

-(CGFloat)progress
{
	return _progress;
}

-(void)drawBar
{
    if( !barLayer )
    {
        self.barLayer = [CAGradientLayer layer];
        [self.layer addSublayer:barLayer];
    }
    CGFloat w = self.bounds.size.width;
    barLayer.bounds = CGRectMake(0., 0., w, 20);
    UIColor *gray1 =  [UIColor colorWithRed:0.6 green:0.6 blue:0.6  alpha:1.0];
    UIColor *gray2 =  [UIColor colorWithRed:1.0 green:1.0 blue:1.0  alpha:1.0];
    
	barLayer.cornerRadius = 6.0;
	barLayer.borderWidth = 1.;
    barLayer.anchorPoint = CGPointZero;
    
	barLayer.startPoint = CGPointZero;
	barLayer.endPoint = CGPointMake(0.0, 1.0);
	barLayer.colors = [NSArray arrayWithObjects:(id)[gray1 CGColor], (id)[gray2 CGColor], nil];
	
	CTLabel *label = [[CTLabel alloc] initWithFrame:CGRectMake(10., 0., w-10, 20)];
	label.backgroundColor = [UIColor clearColor];
    [label CTLabelFont:[UIFont appBookFontName] CTFontSize:16 CTTextColor:[UIColor blackColor] ];
	label.text = @"Testing";
    label.numberOfLines = 1;
	label.adjustsFontSizeToFitWidth = YES;
    label.VerticalAlignment = CTVerticalAlignmentTop;
    label.createLinkButtons = NO;
    
    [self addSubview:label];
	
}

- (CAAnimation*)PoleAnimation
{
	// Create a path for the animation to follow
    CGPoint allPoints[2];
    allPoints[0] = CGPointMake(0.0, 0.0);
	allPoints[1] = CGPointMake(0.0, 50.0);
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathAddLines ( thePath, NULL, allPoints, 2 );
	
    CAKeyframeAnimation* animation;
    animation                   = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path              = thePath;
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration          = 3.0;
    animation.autoreverses      = NO;
    animation.repeatCount       = 1e100;
    animation.delegate          = self;
    CGPathRelease ( thePath );
    return animation;
}

- (void)AnimateBarberPole
{
	[barberPole removeAnimationForKey:@"changePosition"];
	[CATransaction begin];
	{
		[CATransaction setAnimationDuration:5.0];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		CABasicAnimation *movePole = [CABasicAnimation animationWithKeyPath:@"position"];
		movePole.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 200.)];
		[barberPole addAnimation:movePole forKey:@"changePosition"];
	}
	[CATransaction commit];
}


-(void)drawProgress
{
    if( !progressLayer )
    {
        self.progressLayer = [CAGradientLayer layer];
        [self.barLayer addSublayer:progressLayer];
        UIColor *blue2 =  [UIColor colorWithRed:0.077 green:0.335 blue:1.0  alpha:1.0];
        UIColor *blue1 =  [UIColor colorWithRed:0.65 green:1.0 blue:1.0  alpha:1.0];
        progressLayer.cornerRadius = 6.0;
        progressLayer.borderWidth = 0.;
        progressLayer.anchorPoint = CGPointZero;
        progressLayer.startPoint = CGPointZero;
        progressLayer.endPoint = CGPointMake(0.0, 1.0);
        progressLayer.colors = [NSArray arrayWithObjects:(id)[blue1 CGColor], (id)[blue2 CGColor], nil];
        progressLayer.masksToBounds = YES;
        self.time = 5.0;
		
		barberPole =  [BarberPole layer];
		[progressLayer addSublayer:barberPole];
		barberPole.backgroundColor = [[UIColor colorWithRed:0.281f green:0.623f blue:1.0f alpha:0.2] CGColor];
		barberPole.bounds = CGRectMake(0., 0., 300., 200.);
		//barberPole.position = self.center;
    }
	
    CGRect bounds = self.barLayer.bounds;
    bounds.size.width = self.progress * bounds.size.width;
    progressLayer.bounds = bounds;
	//	bounds.size.height = 200.0;
	//	barberPole.bounds = bounds;
	[barberPole setNeedsDisplay];
	[barberPole addAnimation:[self PoleAnimation] forKey:@"movementPath"];
}

- (void)setNeedsDisplay
{
    [self drawBar];
	if( self.progress > 0.0)
		[self drawProgress];
}


@end
