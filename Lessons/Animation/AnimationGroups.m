//
//  AnimationGroups.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "AnimationGroups.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation AnimationGroups

+ (NSString *)className 
{
	return @"Animation Groups";
}
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

#pragma mark Setup the View

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
	}
    return self;
}

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
    CGRect tFrame = CGRectMake(161, 54, 290, 44);
    tName = [[CTextField alloc] initWithFrame:tFrame ];
    tName.backgroundColor = [UIColor clearColor];
    [self addSubview:tName];
	/*
	pulseLayer =  [[DetailedLayer alloc] init];		// Sub-classed Layer
	[self.layer addSublayer:pulseLayer];
	
	pulseLayer.backgroundColor =  [[UIColor colorWithRed:0.0 green:0.0 blue:0.0  alpha:0.85] CGColor];
	pulseLayer.bounds = CGRectMake(0., 0., 200., 200.);
	pulseLayer.cornerRadius = 12.;
	pulseLayer.position = self.center;
	[pulseLayer setNeedsDisplay];

	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	pulseAnimation.duration = 2.;
	pulseAnimation.toValue = [NSNumber numberWithFloat:1.15];
	
	CABasicAnimation *pulseColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
	pulseColorAnimation.duration = 1.;
	pulseColorAnimation.fillMode = kCAFillModeForwards;
	pulseColorAnimation.toValue = (id)[[UIColor colorWithRed:1.0 green:1.0 blue:0.0  alpha:0.85] CGColor];
	
	CABasicAnimation *rotateLayerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotateLayerAnimation.duration = .5;
	rotateLayerAnimation.beginTime = .5;
	rotateLayerAnimation.fillMode = kCAFillModeBoth;
	rotateLayerAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(45.)];
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:pulseAnimation, pulseColorAnimation, rotateLayerAnimation, nil];
	group.duration = 2.;
	group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	group.autoreverses = YES;
	group.repeatCount = FLT_MAX;
	
	[pulseLayer addAnimation:group forKey:nil];
     */
}
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* rectangle12 = [UIColor colorWithRed: 0.494 green: 0.494 blue: 0.494 alpha: 1];
    UIColor* color = [UIColor colorWithRed: 0.067 green: 0.067 blue: 0.067 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.052 green: 0.052 blue: 0.052 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 0.029 green: 0.029 blue: 0.029 alpha: 0];
    UIColor* color4 = [UIColor colorWithRed: 0.008 green: 0.008 blue: 0.008 alpha: 0];
    
    //// Gradient Declarations
    NSArray* customColors = [NSArray arrayWithObjects:
                             (id)color.CGColor,
                             (id)color2.CGColor,
                             (id)color3.CGColor,
                             (id)color4.CGColor, nil];
    CGFloat customLocations[] = {0, 0.25, 0.63, 1};
    CGGradientRef custom = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)customColors, customLocations);
    
    //// Image Declarations
    UIImage* image = [UIImage imageNamed: @"image"];
    UIColor* imagePattern = [UIColor colorWithPatternImage: image];
    
    //// image 2 Drawing
    UIBezierPath* image2Path = [UIBezierPath bezierPathWithRect: CGRectMake(-50, -48, 446, 278)];
    CGContextSaveGState(context);
    CGContextSetPatternPhase(context, CGSizeMake(-50, -48));
    [imagePattern setFill];
    [image2Path fill];
    CGContextRestoreGState(context);
    
    
    //// Group 3
    {
        //// Rectangle 12 Drawing
        UIBezierPath* rectangle12Path = [UIBezierPath bezierPath];
        [rectangle12Path moveToPoint: CGPointMake(394, 29.99)];
        [rectangle12Path addLineToPoint: CGPointMake(394, 230)];
        [rectangle12Path addLineToPoint: CGPointMake(19, 230)];
        [rectangle12Path addLineToPoint: CGPointMake(19, 19)];
        [rectangle12Path addLineToPoint: CGPointMake(383.01, 19)];
        [rectangle12Path addLineToPoint: CGPointMake(394, 29.99)];
        [rectangle12Path closePath];
        [rectangle12 setFill];
        [rectangle12Path fill];
        //[rectangle12StrokeColor setStroke];
        rectangle12Path.lineWidth = 1;
        [rectangle12Path stroke];
        
        
        //// Group
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.9);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 12 GradientOverlay Drawing
            UIBezierPath* rectangle12GradientOverlayPath = [UIBezierPath bezierPath];
            [rectangle12GradientOverlayPath moveToPoint: CGPointMake(394, 29.99)];
            [rectangle12GradientOverlayPath addLineToPoint: CGPointMake(394, 230)];
            [rectangle12GradientOverlayPath addLineToPoint: CGPointMake(19, 230)];
            [rectangle12GradientOverlayPath addLineToPoint: CGPointMake(19, 19)];
            [rectangle12GradientOverlayPath addLineToPoint: CGPointMake(383.01, 19)];
            [rectangle12GradientOverlayPath addLineToPoint: CGPointMake(394, 29.99)];
            [rectangle12GradientOverlayPath closePath];
            CGContextSaveGState(context);
            [rectangle12GradientOverlayPath addClip];
            CGContextDrawLinearGradient(context, custom,
                                        CGPointMake(206.5, 230),
                                        CGPointMake(206.5, 19),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Cleanup
    CGGradientRelease(custom);
    CGColorSpaceRelease(colorSpace);
}

- (void)dealloc
{
	pulseLayer = nil;
}

@end
