//
//  GeekBanner.m
//  WorkBench
//
//  Created by John Basile on 11/15/12.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "GeekBanner.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"


@implementation GeekBanner
@synthesize gkBannerBkg;

static BOOL didPlay = NO;

+ (NSString *)className 
{
	return @"Geek Banner";
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
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	playButton.frame = CGRectMake(10., 10., 145., 44.);
	[playButton setTitle:@"Play" forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:playButton];
		
	stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	stopButton.frame = CGRectMake(165., 10., 145., 44.);
	[stopButton setTitle:@"Stop" forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:stopButton];
	
	CGRect frame = CGRectMake(10.0, 130, 160.0, 7.0);
	starCount = [[UISlider alloc] initWithFrame:frame];
	[starCount addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	starCount.backgroundColor = [UIColor clearColor];
	
	starCount.minimumValue = 10.0;
	starCount.maximumValue = 100.0;
	starCount.continuous = YES;
	starCount.value = 20.0;
	numberOfStars = 20.0;
	[evDelegate.benchViewController.parametersView addSubview:starCount];
	
	//self.gkBannerBkg = [[BannerLayer alloc] initWithFrame:CGRectMake(0., 0., 768., 260.)];		// Sub-classed Layer
	self.gkBannerBkg = [[BannerLayer alloc] initWithFrame:CGRectMake(0., 0., 320, 108)];		// Sub-classed Layer
	
	self.gkBannerBkg.title = @"LOVE";
	[self.gkBannerBkg setColor:@"Red"];
	
//	self.gkBannerBkg.title = @"DECISIONS";
//	[self.gkBannerBkg setColor:@"Green"];
	
//	self.gkBannerBkg.title = @"CAREERS";
//	[self.gkBannerBkg setColor:@"Blue"];
	
	rootLayer = [CALayer layer];
	
	[self.layer addSublayer:rootLayer];
	[self.layer addSublayer:gkBannerBkg];
	
	gkBannerBkg.position = self.center;
	[gkBannerBkg setNeedsDisplay];
}

- (void)sliderAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
	numberOfStars = (slider.value + 0.5f);
}

- (void)orientWithX:(float)x andY:(float)y
{
	CATransform3D transform = CATransform3DMakeRotation(x, 0, 1, 0);
	transform = CATransform3DRotate(transform, y, 1, 0, 0);
	float zDistance = -450;
	transform.m34 = 1.0 / -zDistance;
	starfieldLayer.sublayerTransform = transform;
}

- (void)play:(id)sender 
{
	if ( didPlay == NO )
	{
		didPlay = YES;
		starfieldLayer = [CALayer layer];
		starfieldLayer.name = @"starfieldLayer";
		//starfieldLayer.bounds = CGRectMake(0.00, 0.00, 768., 260);
		starfieldLayer.bounds = CGRectMake(0.00, 0.00, 320.0, 108.0);

		[gkBannerBkg addSublayer:starfieldLayer];
		starfieldLayer.position = CGPointMake(gkBannerBkg.frame.size.width/2, gkBannerBkg.frame.size.height/2);
		[self orientWithX:0 andY:0.3];
		
		self.gkBannerBkg.masksToBounds = YES;
		
//		[self buildBannerItem:@"Red"];
		[self buildBannerItem:@"Green"];
//		[self buildBannerItem:@"Blue"];
		
		[self.gkBannerBkg addTextLayers];
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

- (void)buildBannerItem:(NSString *)color
{
	
	// Common text style
	NSDictionary* textStyle = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"Futura-MediumItalic", @"font",
							   kCAAlignmentCenter, @"alignmentMode",
							   nil];
	

	// Range of textlayer positions
//	float	width	= [self frame].size.width/1.5;
//	float	height	= [self frame].size.height/1.5;
	
	float	top = 0.0;
	float	bot = self.gkBannerBkg.frame.size.height; 
	float	left = 0.0;
	float	right = self.gkBannerBkg.frame.size.width;
	
	
	int i, numStars = 200;
	numStars = numberOfStars;
	for (i=0; i < numStars; i++)
	{
		
//		float x		= frandom(-width, width);
//		float y		= frandom(-height, height);
		float x		= frandom(left, 2*right);
		float y		= frandom(top, bot);
		
		float red	= 0;
		float green	= 0;
		float blue	= 0;
		if( [color isEqualToString:@"Red"])
		{
			red = frandom(0.7, 1.0);;
		}
		else if( [color isEqualToString:@"Blue"])
		{
			blue = frandom(0.7, 1.0);;
		}
		else if( [color isEqualToString:@"Green"])
		{
			green = frandom(0.7, 1.0);
		}
		
		float fontSize	= frandom(9, 18);//frandom(12, 30);
		
		// Create text layer
		CATextLayer* layer = [CATextLayer layer];
		layer.fontSize = fontSize;
		layer.style = textStyle;
		
		layer.foregroundColor = [[UIColor colorWithRed:red green:green blue:blue  alpha:1.0] CGColor];
		layer.position = CGPointMake(x, y);
		
		// Randomly select its content
		float whichText = frandom(0, 11);
		if (whichText >= 0.0 && whichText <= 1.0)	layer.string = @"Do you have a snowball's chance in hell with her?";
		if (whichText >= 1.0 && whichText <= 2.0)	layer.string = @"Is this one for fun or for real?";
		if (whichText >= 2.0 && whichText <= 3.0)	layer.string = @"Should you go to a bachelor party in Vegas against your girlfriend's wishes?";
		if (whichText >= 3.0 && whichText <= 4.0)	layer.string = @"Are you whipped?";
		if (whichText >= 4.0 && whichText <= 5.0)	layer.string = @"Should you apologize?";
		if (whichText >= 5.0 && whichText <= 6.0)	layer.string = @"Should you let her see where you live?";
		if (whichText >= 6.0 && whichText <= 7.0)	layer.string = @"Can you stop doing sit-ups or trimming nose hair?";
		if (whichText >= 7.0 && whichText <= 8.0)	layer.string = @"Should you put up with that annoying habit?";
		if (whichText >= 8.0 && whichText <= 9.0)	layer.string = @"Should you lie?";
		if (whichText >= 9.0 && whichText <= 10.0)	layer.string = @"Whose Turn Is It?";
		if (whichText >= 10.0 && whichText <= 11.0)	layer.string = @"Whose family should you visit over the holidays?";
		
		// Set layer bounds
		CGSize s = [layer preferredFrameSize];
		layer.bounds = CGRectMake(0, 0, s.width, s.height);
		
		
		//
		// We animate position and opacity. 
		//	position is just going from A to B,
		//	opacity is going from invisble to visible to invisble, therefore we need a keyframe animation.
		//
		float	duration = frandom(4, 28);
		
		CABasicAnimation *theAnimation;
		theAnimation=[CABasicAnimation animationWithKeyPath:@"position.x"];
		
		NSNumber	*from, *to;
		NSNumber	*Rfrom = [NSNumber numberWithFloat:frandom( 300, 1000)];
		NSNumber	*Rto = [NSNumber numberWithFloat:  frandom(-500, -300)];
		
//		NSNumber	*Lfrom = [NSNumber numberWithFloat:frandom(-500, -300)];
//		NSNumber	*Lto = [NSNumber numberWithFloat:  frandom( 300, 1000)];
		
		from = Rfrom;
		to = Rto;
//		if( (i % 2) == 0 )
//		{
//			from = Rfrom;
//			to = Rto;
//		}
//		else
//		{
//			from = Lfrom;
//			to = Lto;
//		}
		
		theAnimation.fromValue = from;
		theAnimation.toValue = to;
		
		theAnimation.duration = duration;
		theAnimation.repeatCount = FLT_MAX;
		
		[layer addAnimation:theAnimation forKey:@"position.x"];
		
		CAKeyframeAnimation* opacityAnimation;
		opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
		opacityAnimation.values = [NSArray arrayWithObjects:
								   [NSNumber numberWithFloat:0.0],
								   [NSNumber numberWithFloat:0.3],
								   [NSNumber numberWithFloat:0.5],
								   [NSNumber numberWithFloat:0.8],
								   [NSNumber numberWithFloat:1.0],
								   [NSNumber numberWithFloat:1.0], 
								   [NSNumber numberWithFloat:0.8],
								   [NSNumber numberWithFloat:0.5],
								   [NSNumber numberWithFloat:0.3],
								   [NSNumber numberWithFloat:0.0],
								   nil];
		
		
		opacityAnimation.duration = duration;
		opacityAnimation.repeatCount = FLT_MAX;
		[layer addAnimation:opacityAnimation forKey:@"opacity"];
		
		[starfieldLayer addSublayer:layer];
	}
}


@end
