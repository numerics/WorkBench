//
//  KeyframeAnimation.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DetailedLayer.h"


@interface KeyframeAnimation : UIView
{
	DetailedLayer		*platformLayer;
	DetailedLayer		*marioLayer;
	
	UIButton		*jumpButton;
}

- (void)setUpView; 

@end
