//	 Copyright (c) 2011 Numerics and John Basile
//	 
//	 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	 THE SOFTWARE.


#import "LayerTree.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation LayerTree

+ (NSString *)className 
{
	return @"Layer Tree";
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

#pragma mark Setup the View

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	maskBlueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	maskBlueButton.frame = CGRectMake(10., 10., 145., 44.);
	[maskBlueButton setTitle:@"Mask Blue" forState:UIControlStateNormal];
	[maskBlueButton addTarget:self action:@selector(toggleBlueMask:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:maskBlueButton];
	
	maskContainerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	maskContainerButton.frame = CGRectMake(165., 10., 145., 44.);
	[maskContainerButton setTitle:@"Mask Container" forState:UIControlStateNormal];
	[maskContainerButton addTarget:self action:@selector(toggleContainerMask:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:maskContainerButton];
	
	reparentPurpleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	reparentPurpleButton.frame = CGRectMake(10., 60., 145., 44.);
	[reparentPurpleButton setTitle:@"Reparent Purple" forState:UIControlStateNormal];
	[reparentPurpleButton addTarget:self action:@selector(reparentPurpleLayer:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:reparentPurpleButton];
	
	addRemoveYellowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	addRemoveYellowButton.frame = CGRectMake(165., 60., 145., 44.);
	[addRemoveYellowButton setTitle:@"Add/Remove Yellow" forState:UIControlStateNormal];
	[addRemoveYellowButton addTarget:self action:@selector(addRemoveYellow:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:addRemoveYellowButton];
	
	containerLayer	= [[DetailedLayer alloc] init];
	containerLayer.name = @"containerLayer";

	redLayer		= [[DetailedLayer alloc] init];
	redLayer.name = @"redLayer";

	blueLayer		= [[DetailedLayer alloc] init];
	blueLayer.name = @"blueLayer";

	purpleLayer		= [[DetailedLayer alloc] init];
	purpleLayer.name = @"purpleLayer";

	yellowLayer		= [[DetailedLayer alloc] init];
	yellowLayer.name = @"yellowLayer";
	
	containerLayer.showAnchor = YES;
	redLayer.showAnchor = YES;
	blueLayer.showAnchor = YES;
	purpleLayer.showAnchor = YES;
	yellowLayer.showAnchor = YES;

	containerLayer.smallAnchor = YES;
	redLayer.smallAnchor = YES;
	blueLayer.smallAnchor = YES;
	purpleLayer.smallAnchor = YES;
	yellowLayer.smallAnchor = YES;

	containerLayer.brownAnchor = YES;
	redLayer.brownAnchor = YES;
	blueLayer.brownAnchor = YES;
	purpleLayer.brownAnchor = YES;
	yellowLayer.brownAnchor = YES;
	
	[self.layer addSublayer:containerLayer];
	[containerLayer addSublayer:redLayer];
	[containerLayer addSublayer:blueLayer];
	[blueLayer addSublayer:purpleLayer];
	
	containerLayer.backgroundColor = [[UIColor greenColor] CGColor];
	containerLayer.bounds = CGRectMake(0., 0., 200., 200.);
	containerLayer.position = self.center;
	[containerLayer setNeedsDisplay];
	
	CGRect rect = CGRectMake(0., 0., 100., 100.);
	
	redLayer.backgroundColor = [[UIColor colorWithRed:1.0 green:0.0 blue:0.0  alpha:0.75] CGColor];
	redLayer.bounds = rect;
	redLayer.position = CGPointMake(0., 200.);
	[redLayer setNeedsDisplay];
	
	blueLayer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:1.0  alpha:0.75] CGColor];
	blueLayer.bounds = rect;
	blueLayer.position = CGPointMake(200., 200.);
	[blueLayer setNeedsDisplay];
	
	purpleLayer.backgroundColor = [[UIColor colorWithRed:1.0 green:0.0 blue:1.0  alpha:0.75] CGColor];
	purpleLayer.bounds = rect;
	purpleLayer.position = CGPointMake(25., 25.);
	[purpleLayer setNeedsDisplay];
	
	yellowLayer.backgroundColor = [[UIColor colorWithRed:1.0 green:1.0 blue:0.0  alpha:0.75] CGColor];
	yellowLayer.bounds = rect;
	yellowLayer.position = CGPointMake(0., 0.);
	[yellowLayer setNeedsDisplay];
}


#pragma mark Event Handlers

- (void)toggleBlueMask:(id)sender 
{
	blueLayer.masksToBounds = !blueLayer.masksToBounds;
}

- (void)toggleContainerMask:(id)sender 
{
	containerLayer.masksToBounds = !containerLayer.masksToBounds;
}

- (void)reparentPurpleLayer:(id)sender 
{
	BOOL isChildOfRoot = (purpleLayer.superlayer == containerLayer);
	[purpleLayer removeFromSuperlayer];
	if(isChildOfRoot) 
	{
		[blueLayer addSublayer:purpleLayer];
	} 
	else 
	{
		[containerLayer addSublayer:purpleLayer];
	}
}

- (void)addRemoveYellow:(id)sender 
{
	if(yellowLayer.superlayer == nil) 
	{
		CALayer *purpleParent = purpleLayer.superlayer;
		[purpleParent insertSublayer:yellowLayer below:purpleLayer];
	} 
	else 
	{
		[yellowLayer removeFromSuperlayer];
	}
}

- (void)dealloc 
{
	containerLayer = nil;
	redLayer = nil;
	blueLayer = nil;
	purpleLayer = nil;
	yellowLayer = nil;
	maskBlueButton = nil;
	maskContainerButton = nil;
	reparentPurpleButton = nil;
	addRemoveYellowButton = nil;
}

@end
