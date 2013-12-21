//
//  CustomPropertyAnimation.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "CustomPropertyAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomLayer : CALayer 
{
}

@property (assign) CGFloat margin;

@end

@implementation CustomLayer

@synthesize margin;

+ (BOOL)needsDisplayForKey:(NSString *)key 
{
	if([key isEqualToString:@"margin"]) 
	{
		return YES;
	}
	return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx 
{
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, CGRectInset(self.bounds, self.margin, self.margin));
	CGContextSetStrokeColorWithColor(ctx, [[UIColor yellowColor] CGColor]);
	CGContextSetLineWidth(ctx, 4.f);
	CGContextDrawPath(ctx, kCGPathStroke);
	CGContextRestoreGState(ctx);
}

@end


@implementation CustomPropertyAnimation

+ (NSString *)className 
{
	return @"Custom Properties";
}

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


#pragma mark Load and unload the view

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	
	customLayer = [[CustomLayer alloc] init];
	[self.layer addSublayer:customLayer];
	
	customLayer.backgroundColor = [[UIColor blueColor] CGColor];
	customLayer.frame = CGRectInset(self.bounds, 50.f, 100.f);
	customLayer.position = self.center;
	customLayer.margin = 0.f;
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"margin"];
	
	anim.duration = 1.f;
	anim.fromValue = [NSNumber numberWithFloat:5.f];
	anim.toValue = [NSNumber numberWithFloat:25.f];
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.repeatCount = CGFLOAT_MAX;
	anim.autoreverses = YES;
	
	[customLayer addAnimation:anim forKey:@"margin"];
	
	CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
	anim2.duration = 1.f;
	anim2.fromValue = [NSNumber numberWithFloat:0.f];
	anim2.toValue = [NSNumber numberWithFloat:20.f];
	anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim2.repeatCount = CGFLOAT_MAX;
	anim2.autoreverses = YES;
	
	[customLayer addAnimation:anim2 forKey:@"cornerRadius"];
}



@end
