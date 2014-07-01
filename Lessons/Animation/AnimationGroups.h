//
//  AnimationGroups.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DetailedLayer.h"
#import "CTextField.h"

@interface AnimationGroups : UIView 
{
	DetailedLayer *pulseLayer;
    CTextField      *tName;
	
	UISlider            *Alpha;         // Opacity Slider
	UISlider            *redC;			// Red Color Slider
	UISlider            *greenC;		// green Color Slider
	UISlider            *blueC;			// blue Color Slider
	
    UILabel		*redLabel;
    UILabel		*greenLabel;
    UILabel		*blueLabel;
	
	
}

@property(nonatomic) CGFloat opacity;
@property(nonatomic) CGFloat redValue;
@property(nonatomic) CGFloat greenValue;
@property(nonatomic) CGFloat blueValue;

@property(nonatomic) UILabel *alphaLabel;

- (void)setUpView; 

@end
