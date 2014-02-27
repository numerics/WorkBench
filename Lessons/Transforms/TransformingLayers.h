//
//  TransformingLayers.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedLayer.h"


@interface TransformingLayers : UIView 
{
	DetailedLayer		*simpleLayer;
	BOOL			cumulative;
	
	UIButton		*moveAnchorPointButton;
	UIButton		*rotateButton;
	UIButton		*scaleButton;
	UIButton		*translateButton;
	UIButton		*resetButton;
	UISwitch		*cumulativeSwitch;
}

@property(assign) BOOL cumulative;

- (void)setUpView; 

@end
