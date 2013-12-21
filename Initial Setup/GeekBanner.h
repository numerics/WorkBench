//
//  GeekBanner.h
//  WorkBench
//
//  Created by John Basile on 11/15/12.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "DetailedLayer.h"
#import "GeekBannerBkg.h"

@interface GeekBanner : UIView <UIGestureRecognizerDelegate>
{
	CALayer			*starfieldLayer;
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
	BannerLayer		*gkBannerBkg;
}
@property(nonatomic,strong) BannerLayer *gkBannerBkg;

- (void)setUpView; 
- (void)buildBannerItem:(NSString *)color;

@end
