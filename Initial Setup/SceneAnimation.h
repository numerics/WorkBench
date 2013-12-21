//
//  myAnim.h
//  Touches
//
//  Created by John Basile on 1/14/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface SceneAnimation : UIView 
{
	CALayer			*_root;
	
	NSDictionary	*_layers;
	NSDictionary	*_animTracks;
	
	UIButton		*playButton;
	UIButton		*stopButton;
}

@property(nonatomic, readonly) CALayer *root;
@property(nonatomic, readonly) NSDictionary *layers;

- (void)setUpView; 

- (void)play:(id)sender;
- (void)stop:(id)sender;
- (void)resumeAnimation; 
- (void)pauseAnimation; 

- (NSDictionary*)makeSceneWithRoot:(CALayer*)animRoot;
- (NSDictionary*)makeAnimTracks;

@end
