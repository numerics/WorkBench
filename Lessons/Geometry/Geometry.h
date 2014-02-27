//
//  Geometry.h
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedLayer.h"


@interface Geometry : UIView 
{
	DetailedLayer		*simpleLayer;
	UIButton		*moveAnchorPointButton;
	UIButton		*movePositionButton;
}

- (void)setUpView; 

@end
