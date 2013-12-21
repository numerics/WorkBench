//
//  WorkBenchViewController.h
//  WorkBench
//
//  Created by John Basile on 1/5/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonPlan.h"

@interface WorkBenchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
	UIView			*displayView;
	UIView			*filterView;
	UIView			*statusView;
	UITableView		*listOfAnimations;
	UIScrollView	*parametersView;
	UILabel			*statusTextLabel;
	LessonPlan		*lessons;
	UIView			*lessonView;

	CGFloat			angleX, angleY;
	CGFloat			deltaX, deltaY;
}
@property (nonatomic, strong) IBOutlet UITableView *listOfAnimations;
@property (nonatomic, strong) IBOutlet UIScrollView *parametersView;

@property (nonatomic, strong) IBOutlet UIView *displayView;
@property (nonatomic, strong) IBOutlet UIView *filterView;
@property (nonatomic, strong) IBOutlet UIView *statusView;

@property (nonatomic, strong) IBOutlet UILabel *statusTextLabel;

@property (nonatomic, strong) UIView *lessonView;

- (BOOL) isPortraitOrientation;
- (BOOL) isLandscapeOrientation;
- (void) updateStatusLabel:(NSString *)status;


@end
