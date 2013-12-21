//
//  StarFieldView.m
//  WorkBench
//
//  Created by John Basile on 1/17/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "StarFieldView.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"


@implementation StarFieldView
BOOL didPlay = NO;

+ (NSString *)className 
{
	return @"StarFieldView";
}

static double frandom(double start, double end)
{
	double r = random();
	r /= RAND_MAX;
	r = start + r*(end-start);
	
	return r;
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
	self.backgroundColor = [UIColor blackColor];

	UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	[self addGestureRecognizer:recognizer];
	recognizer.delegate = self;

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self addGestureRecognizer:panGesture];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	playButton.frame = CGRectMake(10., 10., 145., 44.);
	[playButton setTitle:@"Play" forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:playButton];
	
	//[self addSubview:moveAnchorPointButton];
	
	stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	stopButton.frame = CGRectMake(165., 10., 145., 44.);
	[stopButton setTitle:@"Stop" forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:stopButton];

	
	resetOreintationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	resetOreintationButton.frame = CGRectMake(10., 64, 160, 44.);
	[resetOreintationButton setTitle:@"Reset Orientation" forState:UIControlStateNormal];
	[resetOreintationButton addTarget:self action:@selector(resetOrientation:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:resetOreintationButton];
		
	resetClickedLayersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	resetClickedLayersButton.frame = CGRectMake(190, 64, 180, 44.);
	[resetClickedLayersButton setTitle:@"Reset Clicked Layers" forState:UIControlStateNormal];
	[resetClickedLayersButton addTarget:self action:@selector(resetClickedLayers:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:resetClickedLayersButton];

	
	CGRect frame = CGRectMake(10.0, 130, 160.0, 7.0);
	starCount = [[UISlider alloc] initWithFrame:frame];
	[starCount addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	starCount.backgroundColor = [UIColor clearColor];
	
	starCount.minimumValue = 10.0;
	starCount.maximumValue = 500.0;
	starCount.continuous = YES;
	starCount.value = 200.0;
	numberOfStars = 200.0;
	[evDelegate.benchViewController.parametersView addSubview:starCount];
	
	guideToEye = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	guideToEye.frame = CGRectMake(10, 200, 250, 44.);
	[guideToEye setTitle:@"Play Guide to the Eye" forState:UIControlStateNormal];
	[guideToEye addTarget:self action:@selector(playEye:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:guideToEye];
	
	
	rootLayer = [CALayer layer];
	[self.layer addSublayer:rootLayer];

	
//	[self buildStars];
//		
//	[self spinLayer:[starfieldLayer.sublayers objectAtIndex:150]];
}

- (void)sliderAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
	numberOfStars = (slider.value + 0.5f);
}

- (void)showMovement
{
	angleX = 10;
	angleY = 10;

	// Set custom duration for animating to new orientation
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:2] forKey:kCATransactionAnimationDuration];

	[self orientWithX:angleX andY:angleY];

	[CATransaction commit];
	[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(resetOrientation:) userInfo:nil repeats:NO];
//	[self resetOrientation:nil];
}

- (void)playEye:(id)sender 
{
	if ( didPlay == NO )
	{
		didPlay = YES;
		// Create our container layer
		starfieldLayer = [[DetailedLayer alloc] init];//[[CALayer layer] retain];
		starfieldLayer.name = @"starfieldLayer";
		
		[self orientWithX:0 andY:0.3];
		[rootLayer addSublayer:starfieldLayer];
		self.layer.masksToBounds = YES;
		// Center layer
		[self viewDidEndLiveResize];
		
		[self buildStars];
		int indx = 0.75 * numberOfStars;
		[self spinLayer:[starfieldLayer.sublayers objectAtIndex:indx]];
		[self showMovement];
	}	
}


- (void)play:(id)sender 
{
	if ( didPlay == NO )
	{
		didPlay = YES;
		// Create our container layer
		starfieldLayer = [[DetailedLayer alloc] init];//[[CALayer layer] retain];
		starfieldLayer.name = @"starfieldLayer";
		
		[self orientWithX:0 andY:0.3];
		[rootLayer addSublayer:starfieldLayer];
		self.layer.masksToBounds = YES;
		// Center layer
		[self viewDidEndLiveResize];

		[self buildStars];
		int indx = 0.75 * numberOfStars;
		[self spinLayer:[starfieldLayer.sublayers objectAtIndex:indx]];
	}
}

- (void)stop:(id)sender 
{
	if ( didPlay == YES )
	{
		didPlay = NO;
	
		for (CALayer* layer in starfieldLayer.sublayers)
		{
			[layer removeAllAnimations];
		}
		[starfieldLayer removeFromSuperlayer];
	}
}




- (void) handleTapFrom:(UITapGestureRecognizer *)recognizer
{
	UIView *piece = [recognizer view];
	CGPoint point = [recognizer locationInView:[piece superview]];
	CALayer* layer = [[self layer] hitTest:point];
	
	// Only spin text layers
	if (strcmp(object_getClassName(layer), "CATextLayer"))	return;
	
	CATextLayer* textLayer = (CATextLayer*)layer;
	[self spinLayer:textLayer];
}

- (void)panPiece:(UIPanGestureRecognizer *)recognizer
{
	UIView *piece = [recognizer view];
	if ([recognizer state] == UIGestureRecognizerStateBegan) 
	{
		CGPoint translation = [recognizer translationInView:[piece superview]];
		dragStart.x = translation.x;
		dragStart.y = translation.y;
	}
	else if ( [recognizer state] == UIGestureRecognizerStateChanged )
	{
		CGPoint translation = [recognizer translationInView:[piece superview]];
		
		deltaX = (translation.x - dragStart.x)/200;
		deltaY = -(translation.y - dragStart.y)/200;
		
		[self orientWithX:(angleX+deltaX) andY:(angleY+deltaY)];
	}
	else if ( [recognizer state] == UIGestureRecognizerStateEnded )
	{
		angleX += deltaX;
		angleY += deltaY;
	}
}

//
//	buildStars
//		create 3d text layers
//
- (void)buildStars
{
	
	// Common text style
	NSDictionary* textStyle = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"Futura-MediumItalic", @"font",
							   kCAAlignmentCenter, @"alignmentMode",
							   nil];
	
	// Range of textlayer positions
	float	width	= [self frame].size.width/1.5;
	float	height	= [self frame].size.height/1.5;
	
	int i, numStars = 200;
	numStars = numberOfStars;
	for (i=0; i < numStars; i++)
	{
		
		float x		= frandom(-width, width);
		float y		= frandom(-height, height);
		
		float red	= frandom(0.0, 0.7);
		float green	= frandom(0.6, 0.8);
		float blue	= 1;
		
		float fontSize	= frandom(10, 20);
		
		// Create text layer
		CATextLayer* layer = [CATextLayer layer];
		layer.fontSize = fontSize;
		layer.style = textStyle;
		
		layer.foregroundColor = [[UIColor colorWithRed:red green:green blue:blue  alpha:1.0] CGColor];
		layer.position = CGPointMake(x, y);
		
		// Randomly select its content
		float whichText = frandom(0, 4);
		if (whichText >= 0.0 && whichText <= 1.0)	layer.string = @"Core";
		if (whichText >= 1.0 && whichText <= 2.0)	layer.string = @"Animation";
		if (whichText >= 2.0 && whichText <= 3.0)	layer.string = @"iPhone Developers LA";
		if (whichText >= 3.0 && whichText <= 4.0)	layer.string = @"Numerics Mobile";
		
		// Set layer bounds
		CGSize s = [layer preferredFrameSize];
		layer.bounds = CGRectMake(0, 0, s.width, s.height);
		
		
		//
		// We animate position and opacity. 
		//	position is just going from A to B,
		//	opacity is going from invisble to visible to invisble, therefore we need a keyframe animation.
		//
		float	duration = frandom(0.8, 8);
		
		CABasicAnimation *theAnimation;
		theAnimation=[CABasicAnimation animationWithKeyPath:@"zPosition"];
//		theAnimation=[CABasicAnimation animationWithKeyPath:@"position.y"];
		NSNumber	*from = [NSNumber numberWithFloat:frandom(400, 300)];
		NSNumber	*to = [NSNumber numberWithFloat:frandom(-300, -100)];
//		NSNumber	*from = [NSNumber numberWithFloat:frandom(-500, -200)];
//		NSNumber	*to = [NSNumber numberWithFloat:frandom(1500, 1200)];
		theAnimation.fromValue = from;
		theAnimation.toValue = to;
		
//		theAnimation.fromValue=[NSNumber numberWithFloat:frandom(800, 400)];
//		theAnimation.toValue=[NSNumber numberWithFloat:frandom(-300, -100)];
		theAnimation.duration=duration;
		theAnimation.repeatCount = FLT_MAX;
		[layer addAnimation:theAnimation forKey:@"zPosition"];
//		[layer addAnimation:theAnimation forKey:@"position.y"];
		
		CAKeyframeAnimation* opacityAnimation;
		opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
		opacityAnimation.values = [NSArray arrayWithObjects:
								   [NSNumber numberWithFloat:0.0], 
								   [NSNumber numberWithFloat:1.0], 
								   [NSNumber numberWithFloat:1.0], 
								   [NSNumber numberWithFloat:0.0],
								   nil];
		opacityAnimation.duration = duration;
		opacityAnimation.repeatCount = FLT_MAX;
		[layer addAnimation:opacityAnimation forKey:@"opacity"];
		
		[starfieldLayer addSublayer:layer];
		
//		NSString *temp = [NSString stringWithFormat:@"Bounds:%@  Position:%@  Frame:%@  Anchor Point:%@",
//						  NSStringFromCGRect(starfieldLayer.bounds), 
//						  NSStringFromCGPoint(starfieldLayer.position),
//						  NSStringFromCGRect(starfieldLayer.frame), 
//						  NSStringFromCGPoint(starfieldLayer.anchorPoint)];
//		NSLog(@"%@, %@", starfieldLayer.name, temp);
	}
}

//
// Recenter starfield on resize
//
- (void)viewDidEndLiveResize
{
	starfieldLayer.position = CGPointMake([self frame].size.width/2, [self frame].size.height/2);
}



//
//	orientWithX andY
//		set a new perspective transform for starfieldLayer, built from 2 rotation angles
//
- (void)orientWithX:(float)x andY:(float)y
{
	CATransform3D transform = CATransform3DMakeRotation(x, 0, 1, 0); 
	transform = CATransform3DRotate(transform, y, 1, 0, 0);
	float zDistance = -450; 
	transform.m34 = 1.0 / -zDistance;
	starfieldLayer.sublayerTransform = transform;	
}

//
//	button reset orientation (reset X and Y rotation)
//
- (void)resetOrientation:(id)sender
{
	angleX = 0;
	angleY = 0;
	
	// Set custom duration for animating to new orientation
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:3] forKey:kCATransactionAnimationDuration];
	
	[self orientWithX:0 andY:0];
	
	[CATransaction commit];
}


//
//	remove rotation animations from text layers
//
- (void)resetClickedLayers:(id)sender
{
	
	for (CALayer* layer in starfieldLayer.sublayers)
	{
		[layer removeAnimationForKey:@"rotationX"];
		[layer removeAnimationForKey:@"rotationZ"];
	}
}

//
//	spinLayer
//		spin a text layer around x and z
//
- (void)spinLayer:(CATextLayer*)textLayer
{
	textLayer.foregroundColor = [[UIColor colorWithRed:1.0 green:0.3 blue:0.5  alpha:1.0] CGColor];
	
	CABasicAnimation *theAnimation;
	
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
	theAnimation.fromValue=[NSNumber numberWithFloat:0];
	theAnimation.toValue=[NSNumber numberWithFloat:-6000];
	theAnimation.duration=1000;
	theAnimation.repeatCount = FLT_MAX;
	[textLayer addAnimation:theAnimation forKey:@"rotationX"];
	
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	theAnimation.fromValue=[NSNumber numberWithFloat:0];
	theAnimation.toValue=[NSNumber numberWithFloat:-3000];
	theAnimation.duration=800;
	theAnimation.repeatCount = FLT_MAX;
	[textLayer addAnimation:theAnimation forKey:@"rotationZ"];
}



/*		// from iPhone question on Transfor rotation
- (void)TutoialonRoation
{
	CAKeyframeAnimation *rotation = [CAKeyframeAnimation animation];
	if (direction == ROTATE_FROM_LEFT) 
	{
		rotation.values = [NSArray arrayWithObjects:
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f)],nil];
	} 
	else if (direction == ROTATE_FROM_RIGHT) 
	{
		rotation.values = [NSArray arrayWithObjects:
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f)],nil];
	} 
	else 
	{
		rotation.values = [NSArray arrayWithObjects:
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2, 0.0f, 1.0f, 0.0f)],nil];
		duration *= 2;
	}
	
	rotation.duration = duration;
	rotation.delegate = self;
	
	[[self layer] addAnimation:rotation forKey:@"transform"];
}
*/
@end
