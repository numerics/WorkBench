//
//  GradientLayers.h
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GradientLayers : UIView
{
	CAGradientLayer		*gradientLayer;
	UIButton			*animateButton;
}
- (void)setUpView; 

@end
