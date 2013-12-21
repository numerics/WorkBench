//
//  BasicAnimation.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
// 


#import <UIKit/UIKit.h>
#import "DetailedLayer.h"
#import "GHCustomContainerView.h"
#import "GHCustomImageContainerView.h"
#import "GHCustomContainerLayer.h"
#import "GHCustomButtonLayer.h"
#import "GHClanManageCustomContainerLayer.h"
#import "GHTextInputView.h"

#import "GHTextInputField.h"
#import "SSRatingPicker.h"


@interface BasicAnimation : UIView
{
	DetailedLayer		*pulseLayer;
	UISlider            *shadowAlpha;             // Slider
	UISlider            *offSetH;             // Slider
	UISlider            *fradius;             // Slider

    UILabel		*radius;
    UILabel		*offSetY;
    UILabel		*shadApha;
	
	GHClanManageCustomContainerLayer    *clView;
	SSRatingPicker		*picker;
}
@property (nonatomic, strong) GHCustomContainerView *customView;
@property (nonatomic, strong) GHCustomImageContainerView *customImageView;
@property (nonatomic, strong) GHCustomButtonLayer *customBtn;

@property (nonatomic, strong) GHCustomContainerLayer *gsView;
@property (nonatomic, strong) GHCustomContainerLayer *statsView;
@property (nonatomic, strong) GHClanManageCustomContainerLayer *clView;
@property (nonatomic, strong) GHTextInputView *textView;
@property (nonatomic, strong) GHTextInputField *textFld;
@property (nonatomic, strong) SSRatingPicker *picker;

- (void)setUpView; 

@end
