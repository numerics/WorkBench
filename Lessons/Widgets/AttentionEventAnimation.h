//
//  AttentionEventAnimation.m
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StreamView.h"

@class StreamView;

@interface AttentionEventAnimation : UIView
{
	UIButton		*animateButton;
	CATextLayer		*attributedTextLayer;
	CATextLayer		*normalTextLayer;
	StreamView		*stream;
}
@property (nonatomic, strong) StreamView *stream;

- (void)setUpView; 

@end
