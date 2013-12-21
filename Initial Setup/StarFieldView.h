//
//  StarFieldView.h
//  WorkBench
//
//  Created by John Basile on 1/17/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "DetailedLayer.h"


@interface StarFieldView : UIView <UIGestureRecognizerDelegate>
{
	DetailedLayer	*starfieldLayer;
	CALayer			*rootLayer;
	BOOL			draggedDuringThisClick;
	CGPoint			dragStart;
	
	CGFloat			angleX, angleY;
	CGFloat			deltaX, deltaY;	

	UIButton		*resetOreintationButton;
	UIButton		*resetClickedLayersButton;
	UIButton		*playButton;
	UIButton		*stopButton;
	UISlider		*starCount;		// Slider
	UIButton		*guideToEye;
	CGFloat			numberOfStars;
}

- (void)setUpView; 
- (void)buildStars;
- (void)orientWithX:(float)x andY:(float)y;
- (void)spinLayer:(CATextLayer*)textLayer;
- (void)viewDidEndLiveResize;


- (void)resetOrientation:(id)sender;
- (void)resetClickedLayers:(id)sender;

@end
