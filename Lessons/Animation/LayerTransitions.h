//
//  LayerTransitions.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedLayer.h"


@interface LayerTransitions : UIView
{
	DetailedLayer			*containerLayer;
	DetailedLayer			*blueLayer;
	DetailedLayer			*redLayer;
	
	UIButton			*transitionButton;
	UISegmentedControl	*typeSelectControl;
	UISegmentedControl	*subtypeSelectControl;
}

- (void)setUpView; 


@end
