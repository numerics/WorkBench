//	 Copyright (c) 2011 Numerics and John Basile
//	 


#import "LessonPlan.h"
#import <objc/runtime.h>
#import "LayerTree.h"
#import "ShapeLayers.h"
#import "Geometry.h"
#import "LayerDrawing.h"
#import "BasicAnimation.h"
#import "KeyframeAnimation.h"
#import "GradientLayers.h"
#import "TransformingLayers.h"
#import "StyleProperties.h"
#import "AnimationTransactions.h"
#import "AnimationGroups.h"
#import "LayerTransitions.h"
#import "AdvancedShapeLayers.h"
#import "TextLayers.h"
#import "CustomPropertyAnimation.h"
#import "AttentionEventAnimation.h"
#import "SceneAnimation.h"
#import "StarFieldView.h"
#import "ReplicatorView.h"
#import "NanoSporesiPadView.h"
#import "AITransformView.h"
#import "MotionAlongAPathView.h"
#import "CoreTextView.h"
#import "ProgressBar.h"
#import "AccordianDemo.h"
#import "GeekBanner.h"
#import "ProgressBarTestView.h"
#import "NUButtonView.h"
#import "GHImageContainerView.h"
#import "CustomDrawView.h"
#import "Playground.h"
#import "NoxView.h"

@interface UIViewController (ThisIsHereToAviodACompilerWarning)

+ (NSString *)className;

@end

@implementation LessonPlan
{
}
@synthesize groups,Lessons;


- (id)init 
{
	self = [super init];
	if (self != nil) 
	{
//		NSString *ag = [Geometry class];
		NSArray *geom = [NSArray arrayWithObjects:[Playground class],[NoxView class],[CustomDrawView class],[NUButtonView class],[AccordianDemo class],[Geometry class], [TransformingLayers class], nil];
		NSArray *hier = [NSArray arrayWithObjects:[LayerTree class],nil];
		NSArray *drawing = [NSArray arrayWithObjects:[LayerDrawing class], [StyleProperties class], nil];
		NSArray *animation = [NSArray arrayWithObjects:[BasicAnimation class], [GHImageContainerView class],[AnimationGroups class], 
							  [AnimationTransactions class], [KeyframeAnimation class], [MotionAlongAPathView class],
							  [LayerTransitions class], [CustomPropertyAnimation class], nil];
		NSArray *special = [NSArray arrayWithObjects:[ShapeLayers class], [AdvancedShapeLayers class], [GradientLayers class], [TextLayers class], nil];
		NSArray *advanced = [NSArray arrayWithObjects:[AttentionEventAnimation class], [SceneAnimation class], [StarFieldView class], [ReplicatorView class],
							 [NanoSporesiPadView class],  [GeekBanner class],  [CoreTextView class], [ProgressBarTestView class],nil];
		
		
		groups = [[NSArray alloc] initWithObjects:@"Geometry",
				   @"Layer Structure",
				   @"Drawing",
				   @"Animation",
				   @"Layer Types",
				   @"Avanced Techniques",
				   nil];
		
		Lessons = [[NSArray alloc] initWithObjects:geom, hier, drawing, animation, special, advanced, nil]; 
	}
	return self;
}


- (NSUInteger)groupCount 
{
	return [groups count];
}

- (NSUInteger)LessonCountForGroup:(NSUInteger)group 
{
	return [[Lessons objectAtIndex:group] count];
}

- (NSArray *)LessonsForGroup:(NSUInteger)group 
{
	return [[Lessons objectAtIndex:group] copy];
}

- (NSString *)LessonNameAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray *samples = [Lessons objectAtIndex:indexPath.section];
	Class clazz = [samples objectAtIndex:indexPath.row];
	return [clazz className];
}

- (UIViewController *)LessonForIndexPath:(NSIndexPath *)indexPath 
{
	NSArray *samples = [Lessons objectAtIndex:indexPath.section];
	Class clazz = [samples objectAtIndex:indexPath.row];
	
	UIViewController *instance = [[clazz alloc] initWithNibName:nil bundle:nil];
	return instance;
}

- (UIView *)LessonViewForIndexPath:(NSIndexPath *)indexPath withFrame:(CGRect)frame
{
	NSArray *samples = [Lessons objectAtIndex:indexPath.section];
	Class clazz = [samples objectAtIndex:indexPath.row];
	
	UIView *instance = [[clazz alloc] initWithFrame:frame];
	return instance;
}


- (NSString *)groupTitleAtIndex:(NSUInteger)index 
{
	return [[groups objectAtIndex:index] copy];
}

@end
