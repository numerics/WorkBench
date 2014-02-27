//
//  AdvancedShapeLayers.h
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AdvancedShapeLayers : UIView 
{
	CAShapeLayer	*shapeLayer;
	CGFloat			currentArc;
}
- (void)setUpView; 
- (void)drawPathWithArc:(CGFloat)arc;

@end
