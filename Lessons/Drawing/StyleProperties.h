//
//  StyleProperties.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedLayer.h"


@interface StyleProperties : UIView 
{
	CALayer		*simpleLayer;
	CAShapeLayer		*maskLayer;
	
	UIButton		*roundCornersButton;
	UIButton		*toggleBorderButton;
	UIButton		*toggleOpacityButton;
	UIButton		*toggleMaskButton;
}
- (void)setUpView; 

@end
