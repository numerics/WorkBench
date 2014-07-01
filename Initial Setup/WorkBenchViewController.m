//
//  WorkBenchViewController.m
//  WorkBench
//
//  Created by John Basile on 1/5/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "WorkBenchViewController.h"
#import "WorkBenchAppDelegate.h"
#import "StarFieldView.h"

@implementation WorkBenchViewController

@synthesize displayView;
@synthesize filterView;
@synthesize listOfAnimations;
@synthesize parametersView;
@synthesize statusView, statusTextLabel, lessonView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	evDelegate.benchViewController = self;								// giving this WorkBenchViewController global space
	if ( [self isLandscapeOrientation] )
	{
		self.displayView.frame       = CGRectMake(384,   0, 640, 716);
		self.filterView.frame        = CGRectMake(  0,   0, 384, 716);
		self.listOfAnimations.frame  = CGRectMake(  2,   0, 380, 330);
		self.parametersView.frame    = CGRectMake(  2, 334, 380, 382);
	}
	else
	{
		self.displayView.frame       = CGRectMake(0,   0, 768, 640);
		self.filterView.frame        = CGRectMake(0, 640, 768, 332);
		self.listOfAnimations.frame  = CGRectMake(2,   2, 380, 328);
		self.parametersView.frame    = CGRectMake(384, 2, 382, 328);
	}
	
	// Subscribe to orientation updates
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	lessons = [[LessonPlan alloc] init];
	self.title = @"Lessons";

	UIGestureRecognizer* recognizer;
	
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	[self.displayView addGestureRecognizer:recognizer];
	recognizer.delegate = self;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self.displayView addGestureRecognizer:panGesture];
	
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [self.displayView addGestureRecognizer:pinchGesture];
	
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [self.displayView addGestureRecognizer:rotationGesture];
}

- (void) updateStatusLabel:(NSString *)status
{
	self.statusTextLabel.text = status;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
   // NSLog( @"TouchView = %@", NSStringFromClass([touch.view class]) );
    BOOL btnP = ![NSStringFromClass([touch.view class]) isEqualToString:@"PieView"];
    BOOL btnS = ![NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"];
    BOOL btnT = ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
    BOOL btnCD = ![NSStringFromClass([touch.view class]) isEqualToString:@"CalendarDayView"];
    BOOL btnCY = ![NSStringFromClass([touch.view class]) isEqualToString:@"CalendarLayoutView"];
    BOOL btnCV = ![NSStringFromClass([touch.view class]) isEqualToString:@"CalendarView"];
    
    if( !btnS || !btnT || !btnCD || !btnCY || !btnCV || !btnP)
        return NO;
    else
        return YES;
    //return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}

//
// In response to a tap gesture, show the image view appropriately then make it fade out in place.
//
- (void) handleTapFrom:(UITapGestureRecognizer *)recognizer
{
	CALayer* layerThatWasTapped = [self.displayView.layer hitTest:[recognizer locationInView:self.displayView]];
	if([layerThatWasTapped.name length] > 2)
	{
		NSString *temp = [NSString stringWithFormat:@"Bounds:%@  Position:%@  Frame:%@  Anchor Point:%@",
						  NSStringFromCGRect(layerThatWasTapped.bounds), 
						  NSStringFromCGPoint(layerThatWasTapped.position),
						  NSStringFromCGRect(layerThatWasTapped.frame), 
						  NSStringFromCGPoint(layerThatWasTapped.anchorPoint)];

		[self updateStatusLabel:[NSString stringWithFormat:@"%@, %@", layerThatWasTapped.name, temp]];
		[layerThatWasTapped setNeedsDisplay];
	}
	else
		[self updateStatusLabel:@""];
}

- (void)panPiece:(UIPanGestureRecognizer *)recognizer
{
 	CALayer* panPiecelayer = [self.displayView.layer hitTest:[recognizer locationInView:self.displayView]];
	if([panPiecelayer.name length] > 2)
    {
		UIView *piece = [recognizer view];
//		if( [panPiecelayer.name isEqualToString:@"starfieldLayer"] )
//		{
//			if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) 
//			{
//				CGPoint translation = [recognizer translationInView:[piece superview]];
//				
//				deltaX = (translation.x - [panPiecelayer position].x)/200;
//				deltaY = -(translation.y - [panPiecelayer position].y)/200;
//				
//				[(StarFieldView *)self.lessonView orientWithX:(angleX+deltaX) andY:(angleY+deltaY)];
//			}
//			else if ( [recognizer state] == UIGestureRecognizerStateEnded )
//			{
//				angleX += deltaX;
//				angleY += deltaY;
//			}
//		}
//		else
		{
			if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) 
			{
				CGPoint translation = [recognizer translationInView:[piece superview]];
				
				[panPiecelayer setPosition:CGPointMake([panPiecelayer position].x + translation.x, [panPiecelayer position].y + translation.y)];
				
				[recognizer setTranslation:CGPointZero inView:[piece superview]];
			}
		}
	}
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)recognizer
{
 	CALayer* rotatePiecelayer = [self.displayView.layer hitTest:[recognizer locationInView:self.displayView]];
	if([rotatePiecelayer.name length] > 2)
    {
		UIView *piece = [recognizer view];
		if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) 
		{
			CGAffineTransform t2, t3;
			t2 = CGAffineTransformRotate([piece transform],  [recognizer rotation]);
			t3 = CGAffineTransformScale(t2,1.0,1.0);
			
			rotatePiecelayer.transform = CATransform3DMakeAffineTransform(t3);
			[recognizer setRotation:0];
		}
	}
}

- (void)scalePiece:(UIPinchGestureRecognizer *)recognizer
{
 	CALayer* scalePiecelayer = [self.displayView.layer hitTest:[recognizer locationInView:self.displayView]];
	if([scalePiecelayer.name length] > 2)
    {
		//UIView *piece = [recognizer view];
		if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) 
		{
			//CGAffineTransform t3 = CGAffineTransformScale([piece transform],[recognizer scale],[recognizer scale]);
			CATransform3D currentTransform = scalePiecelayer.transform;
			CATransform3D scaled = CATransform3DScale(currentTransform, [recognizer scale], [recognizer scale], [recognizer scale]);
			scalePiecelayer.transform = scaled;
			[recognizer setScale:1];
		}
	}
}

#pragma mark -
#pragma mark Table Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return [lessons groupCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [lessons LessonCountForGroup:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	return [lessons groupTitleAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSString *theTitle = [lessons LessonNameAtIndexPath:indexPath];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:theTitle];
	if (cell == nil) 
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:theTitle];
	}
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.textLabel.text = theTitle;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[self updateStatusLabel:@""];						// clear out the status label
	NSArray* subviews = self.displayView.subviews;
	for (UIView *aView in subviews)
	{
		[aView removeFromSuperview];
	}
	subviews = self.parametersView.subviews;
	for (UIView *aView in subviews)
	{
		[aView removeFromSuperview];
	}
	CGRect bounds = CGRectMake(0.0, 0.0, self.displayView.frame.size.width, self.displayView.frame.size.height);
	self.lessonView = [lessons LessonViewForIndexPath:indexPath withFrame:bounds];
	self.lessonView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | 
	UIViewAutoresizingFlexibleBottomMargin | 
	UIViewAutoresizingFlexibleWidth |
	UIViewAutoresizingFlexibleRightMargin | 
	UIViewAutoresizingFlexibleHeight;
	[self.displayView addSubview:self.lessonView];
	
}

#pragma mark -
#pragma mark Interface Orientations
-(void)receivedRotate:(NSNotification *)notification 
{
	if ( [self isLandscapeOrientation] )
	{
		self.displayView.frame       = CGRectMake(384,   0, 640, 716);
		self.filterView.frame        = CGRectMake(  0,   0, 384, 716);
		self.listOfAnimations.frame  = CGRectMake(  2,   0, 380, 330);
		self.parametersView.frame    = CGRectMake(  2, 334, 380, 382);
	}
	else
	{
		self.displayView.frame       = CGRectMake(0,   0, 768, 640);
		self.filterView.frame        = CGRectMake(0, 640, 768, 332);
		self.listOfAnimations.frame  = CGRectMake(2,   2, 380, 328);
		self.parametersView.frame    = CGRectMake(384, 2, 382, 328);
	}
}

- (BOOL) isPortraitOrientation
{
	return UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL) isLandscapeOrientation
{
	return !UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.displayView = nil;
    self.filterView = nil;
	lessons = nil;
}


- (void)dealloc 
{
	lessons = nil;
}

@end
