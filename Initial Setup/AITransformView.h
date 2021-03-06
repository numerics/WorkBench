//
//  AITransformView.h
//  Layers
//
//  Created by test on 3/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Trackball.h"

@interface AITransformView : UIView<UIGestureRecognizerDelegate> 
{
	CALayer						*rootLayer;
	CATransformLayer			*transformLayer;
	Trackball					*trackball;
}

@property(nonatomic, strong) Trackball *trackball;

- (void)setUpView;

@end
