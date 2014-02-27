//
//  NanoSporesiPadViewController.m
//  NanoSporesiPad
//
//  Created by Brad Larson on 4/29/2010.
//
//  This is a rough port of the Mac sample application NanoSpores ( http://groups.google.com/group/des-moines-cocoaheads/browse_thread/thread/f0fd4863b03793d4?pli=1 ) by Hari Wiguna
//  which was based on Scott Stevenson's NanoLife sample application ( http://theocacao.com/document.page/555/ )

#import "NanoSporesiPadView.h"

@interface NanoSporesiPadView ()
// holds all glowing sphere layers
@property (strong) CALayer* containerLayerForSpheres;
// the location of the click in a mouse click/drag event
@property CGPoint touchDownPoint;
@end


@interface NanoSporesiPadView (PathAnimations)
// create a CAAnimation object moving to and from between two points
- (CAAnimation*)pingPongAnimation:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
@end

@interface NanoSporesiPadView (SphereGeneration)
// create an NSImage to use as the layer contents
- (UIImage*)glowingSphereImageWithScaleFactor:(CGFloat)scale;
// create a new "sphere" layer and add it to the container layer
- (void)generateGlowingSphereLayer;
// create a bunch of sphere layers
- (void)generateAllGlowingSphereLayers:(CGPoint)origin;
// create paths surrounding origin and animate the sphere layers along those paths
- (void)animateAllSphereLayers:(CGPoint)origin;
@end

@interface NanoSporesiPadView (Misc)
- (CGPoint)centerOfView;
// create a basic gradient
- (void)setupBackgroundGradient;
// setup colors used to draw glowing sphere images
- (void)setupSphereColors;
@end

@implementation NanoSporesiPadView

+ (Class) layerClass 
{
	return [CAGradientLayer class];
}

+ (NSString *)className 
{
	return @"NanoSporesiPadView";
}

@synthesize containerLayerForSpheres;
@synthesize countOfSpheresToGenerate;
@synthesize touchDownPoint;
@synthesize sphereCoreColor;
@synthesize sphereGlowColor;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
	}
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)setUpView 
{	
	//self.backgroundColor = [UIColor blackColor];
	
	UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	[self addGestureRecognizer:recognizer];
	recognizer.delegate = self;
	
    srandomdev();														// initialize the random number generator
	[self setupBackgroundGradient];										// setup gradient to draw the background of the view
    [self setupSphereColors];											// setup colors used to draw glowing sphere images
    CALayer* sphereContainer = [CALayer layer];							// create container layer for spheres
    sphereContainer.name = @"sphereContainer";
    [self.layer addSublayer:sphereContainer];
	self.layer.masksToBounds = YES;
    self.containerLayerForSpheres = sphereContainer;    
	NSUInteger sphereCount = 31;										// generate a set number of spheres
    self.countOfSpheresToGenerate = sphereCount; 
	[self generateAllGlowingSphereLayers:[self centerOfView]];	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


#pragma mark -
#pragma mark Touch-handling methods
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint touchPointInView = [[touches anyObject] locationInView:self];

	// save the original mouse down as a instance variable, so that we
    // can start a new animation from here, if necessary.
    self.touchDownPoint = touchPointInView;
    
    // stop animating everything and move all the sphere layers so that
    // they're directly under the mouse pointer.
    NSArray* sublayers = self.containerLayerForSpheres.sublayers;
    for ( CALayer* layer in sublayers)
    {
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];	
		layer.position = [[layer presentationLayer] position];
		[CATransaction commit];		
		
        [layer removeAllAnimations];
        layer.position = touchPointInView;
    }
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	CGPoint touchPointInView = [[touches anyObject] locationInView:self];

    self.touchDownPoint = touchPointInView;
	
    [CATransaction begin];
	
	// make sure the dragging happens immediately. we set a specific
	// value here in case we want to it be nearly instant (0.1) later        
	[CATransaction setValue: [NSNumber numberWithBool:0.0]
					 forKey: kCATransactionAnimationDuration];
	
	NSArray* sublayers = self.containerLayerForSpheres.sublayers;
	for ( CALayer* layer in sublayers)
	{
		layer.position = [[layer presentationLayer] position];
		[layer removeAllAnimations];
		layer.position = touchPointInView;    
	}
	
	[CATransaction commit];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	// Reanimate sphere layers at the new mouse location
	[self animateAllSphereLayers:self.touchDownPoint];	
}
*/

- (void) handleTapFrom:(UITapGestureRecognizer *)recognizer
{
	UIView *piece = [recognizer view];
	CGPoint point = [recognizer locationInView:[piece superview]];

    self.touchDownPoint = point;
    
    // stop animating everything and move all the sphere layers so that
    // they're directly under the mouse pointer.
    NSArray* sublayers = self.containerLayerForSpheres.sublayers;
    for ( CALayer* layer in sublayers)
    {
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];	
		layer.position = [[layer presentationLayer] position];
		//		NSLog(@"Position: %f, %f", layer.position.x, layer.position.y);
		[CATransaction commit];		
		
        [layer removeAllAnimations];
        layer.position = point;
    }
	[self animateAllSphereLayers:self.touchDownPoint];	
}

#pragma mark -
#pragma mark Path Animations


// ---------------------------------------------------------------------------
// -pingPongAnimation:
// ---------------------------------------------------------------------------
// create a CAAnimation object moving to and from between two points

- (CAAnimation*)pingPongAnimation:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
	// Create a path for the animation to follow
    CGPoint allPoints[2];    
    allPoints[0] = fromPoint;
	allPoints[1] = toPoint;
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathAddLines ( thePath, NULL, allPoints, 2 );     
	
	// Create the animation object following the path
    CAKeyframeAnimation* animation;
    animation                   = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path              = thePath;
    //animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration          = ( random() % 5 + 3 ); // 15-32 seconds
    animation.autoreverses      = YES;
    animation.repeatCount       = 1e100;
	
    CGPathRelease ( thePath );        
    return animation;
}

#pragma mark -
#pragma mark Sphere Layer Generation


// ---------------------------------------------------------------------------
// -glowingSphereImageWithScaleFactor:
// ---------------------------------------------------------------------------
// create a new "sphere" layer and add it to the container layer

- (UIImage*)glowingSphereImageWithScaleFactor:(CGFloat)scale
{
	return nil;
}

// ---------------------------------------------------------------------------
// -generateGlowingSphereLayer
// ---------------------------------------------------------------------------
// create a new "sphere" layer and add it to the container layer

- (void)generateGlowingSphereLayer
{
    // generate a random size scale for glowing sphere
    NSUInteger randomSizeInt = (random() % 200 + 50 );
    CGFloat sizeScale = (CGFloat)randomSizeInt / 100.0;    
	
    UIImage* compositeImage = [self glowingSphereImageWithScaleFactor:sizeScale];
    CGImageRef cgCompositeImage = [compositeImage CGImage];
    
    // generate a random opacity value with a minimum of 15%
    NSUInteger randomOpacityInt = (random() % 100 + 15 );
    CGFloat opacityScale = (CGFloat)randomOpacityInt / 100.0;
    
    CALayer* sphereLayer            = [CALayer layer];
    sphereLayer.name                = @"glowingSphere";
    sphereLayer.bounds              = CGRectMake ( 0, 0, 10.0 * sizeScale, 10.0  * sizeScale );
    sphereLayer.contents            = (__bridge id)cgCompositeImage;
    sphereLayer.contentsGravity     = kCAGravityCenter;
    sphereLayer.delegate            = self;    
    sphereLayer.opacity             = opacityScale;  

	sphereLayer.backgroundColor = [[UIColor yellowColor] CGColor];
	sphereLayer.cornerRadius = 5.0 * sizeScale;
	
    [self.containerLayerForSpheres addSublayer:sphereLayer];        
    
   // CGImageRelease ( cgCompositeImage );
}

// ---------------------------------------------------------------------------
// -generateAllGlowingSphereLayers
// ---------------------------------------------------------------------------
// Generate a bunch of sphere layers around origin

- (void)generateAllGlowingSphereLayers:(CGPoint)origin
{
	int tNumPoints = [self countOfSpheresToGenerate];
	NSUInteger i,j;
	
	for (i=0; i<(tNumPoints-1); i++)	// Take all points except the last one...
	{
		for (j=i+1; j<tNumPoints; j++)	// ...connect it to all subsequent points.
		{
			[self generateGlowingSphereLayer];
		}
	}
	
	[self animateAllSphereLayers:origin];
}


// ---------------------------------------------------------------------------
// -animateAllSphereLayers
// ---------------------------------------------------------------------------
// create paths surrounding origin and animate the sphere layers along those paths

- (void)animateAllSphereLayers:(CGPoint)origin{
	//--- Layer array ---
	NSArray* sublayers = self.containerLayerForSpheres.sublayers;
	
	//--- Figure out center and radius ---
	int tNumPoints = [self countOfSpheresToGenerate];
	CGPoint tPoints[tNumPoints];
	CGSize tViewSize = self.bounds.size;
	NSUInteger tRandomRadius = ( (tViewSize.height) / 2 ) - 50 - 10;	// -10 pixels so none of the orbs fall would never fall outside initial window
	float tRadius = (random() % tRandomRadius) + 50; // At least 50 pixel radius
	NSUInteger i,j;
	
	//--- Compute all points in a circle ---
	for (i=0; i< tNumPoints; i++)
	{
		float a = (2 * M_PI * i / tNumPoints);
		CGFloat tX = origin.x + sin(a)*tRadius;
		CGFloat tY = origin.y + cos(a)*tRadius;
		tPoints[i] = CGPointMake(tX,tY);
	}
	
	//--- jumble up the points so the animation would look more random ---
	for (i = 0; i < tNumPoints; i++) 
	{
		NSUInteger tRandomIndex = random() % tNumPoints;
		CGPoint tmpPoint = tPoints[i];
		tPoints[i] = tPoints[tRandomIndex];
		tPoints[tRandomIndex] = tmpPoint;
	}
	
	//--- Animate spheres from mousepoint to their initial place in the cirle ---
	NSUInteger tSphereIndex = 0;
	for (i=0; i<(tNumPoints-1); i++)	// Take all points except the last one...
	{
		for (j=i+1; j<tNumPoints; j++)	// ...connect it to all subsequent points.
		{
			// We don't care which sphereLayer is which, just animate each of them in sequence
			CALayer* tSphereLayer = [sublayers objectAtIndex:tSphereIndex++];
			[tSphereLayer setPosition:tPoints[i]];
		}
	}
	
	//--- Connect all possible points in the circle, using each line segment as an animation path for each sphereLayer ---
	tSphereIndex = 0;
	for (i=0; i<(tNumPoints-1); i++)	// Take all points except the last one...
	{
		for (j=i+1; j<tNumPoints; j++)	// ...connect it to all subsequent points.
		{
			// We don't care which sphereLayer is which, just animate each of them in sequence
			CALayer* tSphereLayer = [sublayers objectAtIndex:tSphereIndex++];
			// "movementPath" is a custom key for just this app
			[tSphereLayer addAnimation:[self pingPongAnimation:tPoints[i] toPoint:tPoints[j]] forKey:@"movementPath"];
		}
	}
	
}


#pragma mark -
#pragma mark Misc

// ---------------------------------------------------------------------------
// -centerOfView
// ---------------------------------------------------------------------------

- (CGPoint)centerOfView
{
	CGSize tSize = self.bounds.size;
	CGPoint tCenter = CGPointMake(tSize.width / 2, tSize.height / 2);
	return tCenter;
}


// ---------------------------------------------------------------------------
// -setupBackgroundGradient
// ---------------------------------------------------------------------------
// create a basic gradient

- (void)setupBackgroundGradient
{
    // create a basic gradient for the background of the view
    
    CGFloat red1   =  200 / 255.0;
    CGFloat green1 =   72.0 / 255.0;
    CGFloat blue1  =  0 / 255.0;
	
    CGFloat red2    =   127 / 255.0;
    CGFloat green2  =  10.0 / 255.0;
    CGFloat blue2   =  10.0 / 255.0;
	
    UIColor* gradientTop    = [UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:1.0];    
    UIColor* gradientBottom = [UIColor colorWithRed:red2 green:green2 blue:blue2 alpha:1.0];
	
	CAGradientLayer *gradient = (CAGradientLayer *)self.layer;
	[gradient setColors:[NSArray arrayWithObjects:(id)[gradientTop CGColor], (id)[gradientBottom CGColor], nil]];

	NSLog(@"Set up gradient");
//	[gradientLayer setStartPoint:CGPointMake(0.5,0.35)]; [gradientLayer setEndPoint:CGPointMake(0.5,1.0)];
}


// ---------------------------------------------------------------------------
// -setupSphereColors
// ---------------------------------------------------------------------------
// setup colors used to draw glowing sphere images

- (void)setupSphereColors
{
    self.sphereCoreColor = [UIColor whiteColor];
    
    CGFloat red   = 189.0 / 255.0;
    CGFloat green = 189.0 / 255.0;
    CGFloat blue  = 0.0 / 255.0;
    
    self.sphereGlowColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
