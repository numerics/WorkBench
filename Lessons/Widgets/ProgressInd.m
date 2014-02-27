//
//  ProgressInd.m
//  WorkBench
//
//  Created by John Basile on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgressInd.h"
const CGFloat kProgessLayerWidth = 300.0f;
const CGFloat kProgessLayerHeight = 80.0f;


@implementation ProgressInd
@synthesize progress = _progress;


- (id)init
{
	self = [super init];
	if (self)
    {
		self.needsDisplayOnBoundsChange = YES;
        self.progress = 0.0;
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

-(void)drawBar:(CGContextRef)context
{
    
	self.bounds = CGRectMake(0., 0., 300, 20);
    self.cornerRadius = 6.0;
    self.borderWidth = 1.;
    self.borderColor = [[UIColor blackColor] CGColor];
	
	barLayerl = [CAGradientLayer layer];
	[self addSublayer:barLayerl];
    UIColor *gray1 =  [UIColor colorWithRed:0.6 green:0.6 blue:0.6  alpha:1.0];
    UIColor *gray2 =  [UIColor colorWithRed:1.0 green:1.0 blue:1.0  alpha:1.0];
    
	barLayerl.cornerRadius = 6.0;
	barLayerl.borderWidth = 0.;
    barLayerl.anchorPoint = CGPointZero;
    
	barLayerl.startPoint = CGPointZero;
	barLayerl.endPoint = CGPointMake(0.0, 1.0);
	barLayerl.colors = [NSArray arrayWithObjects:(id)[gray1 CGColor], (id)[gray2 CGColor], nil];
    barLayerl.bounds = self.bounds;
}

-(void)drawProgress:(CGContextRef)context
{
	//	if( progressLayer && self.progress > 0.0 )
	//    {
	//		CATransform3D currentTransform = progressLayer.transform;
	//		CATransform3D scaled = CATransform3DScale(currentTransform, 1.1, 1.0, 1.0);
	//		progressLayer.transform = scaled;
	//        self.progress = 1.1 * self.progress;
	//    }
	//    else
    {
		//        if( !progressLayer )
        {
            progressLayer = [CAGradientLayer layer];
            [self addSublayer:progressLayer];
        }
        UIColor *blue2 =  [UIColor colorWithRed:0.077 green:0.335 blue:1.0  alpha:1.0];
        UIColor *blue1 =  [UIColor colorWithRed:0.65 green:1.0 blue:1.0  alpha:1.0];
        progressLayer.cornerRadius = 6.0;
        progressLayer.borderWidth = 0.;
        progressLayer.anchorPoint = CGPointZero;
        progressLayer.startPoint = CGPointZero;
        progressLayer.endPoint = CGPointMake(0.0, 1.0);
        progressLayer.colors = [NSArray arrayWithObjects:(id)[blue1 CGColor], (id)[blue2 CGColor], nil];
        CGRect bounds = self.bounds;
        bounds.size.width = self.progress * bounds.size.width;
        progressLayer.bounds = bounds;
        
    }
}

- (void)drawInContext:(CGContextRef)context
{
    [self drawBar:context];
    [self drawProgress:context];
}

@end
