//
//  ShapeLayers.h
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ShapeLayers : UIView
{
	CAShapeLayer			*shapeLayer;
	UIButton				*animateButtonBox;
	UIButton				*animateButtonStar;
	
	CGMutablePathRef		pentagonPath;
	CGMutablePathRef		starPath;
	CGMutablePathRef		squarePath;
	CGMutablePathRef		roundPath;
	CGMutablePathRef		boxPath;
}
- (void)setUpView;

@end
