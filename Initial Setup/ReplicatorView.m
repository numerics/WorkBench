/*
     File: AppController.m
 Abstract: Animate a group of rectangles using replicators
  Version: 1.0
 
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.X
 
 */

#import "ReplicatorView.h"

#define Z_TIME_DELAY (0.15) 
#define X_TIME_DELAY (Z_TIME_DELAY * 5)
#define Y_TIME_DELAY (X_TIME_DELAY * 6)


@implementation ReplicatorView

+ (NSString *)className 
{
	return @"ReplicatorView";
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
	}
    return self;
}

- (void)setUpView 
{
	//Create the root layer
	rootLayer = [CALayer layer];
	
	//Set the root layer's attributes
	rootLayer.backgroundColor = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0  alpha:1.0] CGColor];
	
	//Create a 3D perspective transform
	CATransform3D t = CATransform3DIdentity;
	t.m34 = 1.0 / -900.0;
	
	//Rotate and reposition the camera
	t = CATransform3DTranslate(t, 0, 40, -210);
	t = CATransform3DRotate(t, 0.3, 1.0, -1.0, 0);
	rootLayer.sublayerTransform = t;
	
	//Create the replicator layer
	replicatorX = [CAReplicatorLayer layer];
	
	//Set the replicator's attributes
	replicatorX.frame = CGRectMake(0, 0, 400, 300);
	replicatorX.position = CGPointMake(320, 240);
	replicatorX.instanceDelay = X_TIME_DELAY;
	replicatorX.preservesDepth = YES;
	replicatorX.zPosition = 200;
	replicatorX.anchorPointZ = -160;
	
	//Create the second level of replicators
	replicatorY = [CAReplicatorLayer layer];
	
	//Set the second replicator's attributes
	replicatorY.instanceDelay = Y_TIME_DELAY;
	replicatorY.preservesDepth = YES;
	
	//Create the third level of replicators
	replicatorZ = [CAReplicatorLayer layer];
	
	//Set the third replicator's attributes
	replicatorZ.instanceColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8  alpha:1.0] CGColor];;
	replicatorZ.instanceDelay = Z_TIME_DELAY;
	replicatorZ.preservesDepth = YES;
	
	//Create a sublayer
	subLayer = [CALayer layer];
	subLayer.frame = CGRectMake(0, 0, 40, 30);
	subLayer.position = CGPointMake(90, 265);
	subLayer.borderColor = [[UIColor colorWithRed:0.3 green:0.3 blue:0.3  alpha:1.0] CGColor];;
	subLayer.borderWidth = 2.0;
	subLayer.backgroundColor = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0  alpha:1.0] CGColor];;
	
	//Set up the sublayer/replicator hierarchy
	[replicatorZ addSublayer:subLayer];
	[replicatorY addSublayer:replicatorZ];
	[replicatorX addSublayer:replicatorY];
	
	//Add the replicator to the root layer
	[rootLayer addSublayer:replicatorX];
	
	//Set the view's layer to the base layer
	[self.layer addSublayer:rootLayer];
	self.layer.masksToBounds = YES;
	
	//Transform matrix to be used for camera animation
	t = CATransform3DMakeRotation(1, 0, 1, 0);
	
	//Animate the camera panning left and right continuously
	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.fromValue = [NSValue valueWithCATransform3D: CATransform3DIdentity];
	animation.toValue = [NSValue valueWithCATransform3D: t];
	animation.duration = 5;
	animation.removedOnCompletion = NO;
	animation.autoreverses = YES;
	animation.repeatCount = 1e38f;
	animation.fillMode = kCAFillModeForwards;
	[replicatorX addAnimation:animation forKey:@"transform"];
	
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(addOffests:) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:9.5 target:self selector:@selector(animate:) userInfo:nil repeats:NO];
}

//Animates the layers by having them rotate and fly past the camera.
-(void)animate:(id)sender 
{

	//Dont implicitly animate the delay change 
	[CATransaction setDisableActions:YES];
	
	//Reset the replicator delays to their origonal values
	replicatorX.instanceDelay = X_TIME_DELAY;
	replicatorY.instanceDelay = Y_TIME_DELAY;
	replicatorZ.instanceDelay = Z_TIME_DELAY;
	
	//Re-enable the implicit animations
	[CATransaction setDisableActions:NO];

	//Create the transform matrix for the animation
	
	//Move forward 1000 units along z-axis
	CATransform3D t = CATransform3DMakeTranslation( 0, 0, 1000);
	
	//Rotate Pi radians about the axis (0.7, 0.3, 0.0)
	t = CATransform3DRotate(t, M_PI, 0.7, 0.3, 0.0);
	
	//Scale the X and Y dimmensions by a factor of 3
	t = CATransform3DScale(t, 3, 3, 1);
	
	//Transform Animation
	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.fromValue = [NSValue valueWithCATransform3D: CATransform3DIdentity];
	animation.toValue = [NSValue valueWithCATransform3D: t];
	animation.duration = 1.0;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeBoth;
	[subLayer addAnimation:animation forKey:@"transform"];
	
	//Opacity Animation
	animation = [CABasicAnimation animation];
	animation.fromValue = [NSNumber numberWithFloat:1.0];
	animation.toValue = [NSNumber numberWithFloat:0.0];
	animation.duration = 1.0;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeBoth;
	[subLayer addAnimation:animation forKey:@"opacity"];
	
	//Start a timer to call 'reset:' once the animation has completed
	[NSTimer scheduledTimerWithTimeInterval:(Y_TIME_DELAY * 5.0 + 0.5) target:self selector:@selector(reset:) userInfo:nil repeats:NO];
}

//Animate the layers back into the original cube formation
-(void)reset:(id)sender 
{
	//Create the transform matrix for the animation
	
	//Move forward 1000 units along z-axis
	CATransform3D t = CATransform3DMakeTranslation( 0, 0, 1000);
	
	//Rotate Pi radians about the axis (0.7, 0.3, 0.0)
	t = CATransform3DRotate(t, M_PI, 0.7, 0.3, 0.0);
	
	//Scale the X and Y dimmensions by a factor of 3
	t = CATransform3DScale(t, 3, 3, 1);
	
	//Dont implicitly animate the delay change 
	[CATransaction setDisableActions:YES];
	
	//Set the delays lower for a faster animation
	replicatorX.instanceDelay = 0.1;
	replicatorY.instanceDelay = 0.6;
	replicatorZ.instanceDelay = -Z_TIME_DELAY;
	
	//Re-enable the implicit animations
	[CATransaction setDisableActions:NO];
	
	//Transform Animation
	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.fromValue = [NSValue valueWithCATransform3D: t];
	animation.toValue = [NSValue valueWithCATransform3D: CATransform3DIdentity];
	animation.duration = 1.0;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeBoth;
	[subLayer addAnimation:animation forKey:@"transform"];
	
	//Opacity Animation
	animation = [CABasicAnimation animation];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:1.0];
	animation.duration = 1.0;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeBoth;
	[subLayer addAnimation:animation forKey:@"opacity"];
	
	//Start a timer to call 'animate:' once the animation has completed
	[NSTimer scheduledTimerWithTimeInterval:(0.6 * 5.0 + 2.0) target:self selector:@selector(animate:) userInfo:nil repeats:NO];
}

//Activtes each replicator one by one using timers to control when each starts
// (Used for the intro sequnce where a single layer expands into the 3D cube)
-(void)addOffests:(id)sender 
{
	[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(addZReplicator:) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:2.6 target:self selector:@selector(addYReplicator:) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:5.2 target:self selector:@selector(addXReplicator:) userInfo:nil repeats:NO];
}

//Activtes the X replicator by settign its instance count and instance transform
// (Used for the intro sequnce where a single layer expands into the 3D cube)
-(void)addXReplicator:(id)sender 
{
	[CATransaction setDisableActions:YES];
	replicatorX.instanceCount = 6;
	replicatorX.instanceRedOffset = -0.2;
	[CATransaction setDisableActions:NO];
	[CATransaction setAnimationDuration:2.5];
	replicatorX.instanceTransform = CATransform3DMakeTranslation(60, 0, 0);
}

//Activtes the Y replicator by settign its instance count and instance transform
// (Used for the intro sequnce where a single layer expands into the 3D cube)
-(void)addYReplicator:(id)sender 
{
	[CATransaction setDisableActions:YES];
	replicatorY.instanceCount = 5;
	replicatorY.instanceBlueOffset = -0.2;
	[CATransaction setDisableActions:NO];
	[CATransaction setAnimationDuration:2.5];
	replicatorY.instanceTransform = CATransform3DMakeTranslation(0, -50, 0);
}

//Activtes the Z replicator by settign its instance count and instance transform
// (Used for the intro sequnce where a single layer expands into the 3D cube)
-(void)addZReplicator:(id)sender 
{
	[CATransaction setDisableActions:YES];
	replicatorZ.instanceCount = 5;
	replicatorZ.instanceGreenOffset = -0.2;
	[CATransaction setDisableActions:NO];
	[CATransaction setAnimationDuration:2.5];
	replicatorZ.instanceTransform = CATransform3DMakeTranslation(0, 0, -80);
}

@end
