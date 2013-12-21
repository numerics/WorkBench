/*
     File: AppController.h
 Abstract: Animate a group of rectangles using replicators
  Version: 1.0
 
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ReplicatorView : UIView 
{
	CALayer					*rootLayer;
	CAReplicatorLayer		*replicatorX;
	CAReplicatorLayer		*replicatorY;
	CAReplicatorLayer		*replicatorZ;
	
	CALayer					*subLayer;
}
- (void)setUpView; 

//Animates the layers by having them rotate and fly past the camera.
-(void)animate:(id)sender;

//Animate the layers back into the original cube formation
-(void)reset:(id)sender;

//Activtes each replicator one by one using timers to control when each starts
// (Used for the intro sequnce where a single layer expands into the 3D cube)
-(void)addOffests:(id)sender;

//Activtes the X replicator by settign its instance count and instance transform
// (Used for the intro sequnce where a single layer expands into the 3D cube)
-(void)addXReplicator:(id)sender;

//Activtes the Y replicator by settign its instance count and instance transform
// (Used for the intro sequnce where a single layer expands into the 3D cube)
-(void)addYReplicator:(id)sender;

//Activtes the Z replicator by settign its instance count and instance transform
// (Used for the intro sequnce where a single layer expands into the 3D cube)
-(void)addZReplicator:(id)sender;

@end
