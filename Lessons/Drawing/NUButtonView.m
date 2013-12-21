//
//  NUButtonView.m
//  WorkBench
//
//  Created by John Basile on 7/15/13.
//
//

#import "NUButtonView.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

@implementation NUButtonView
@synthesize cButton;

+ (NSString *)className
{
	return @"Custom Button";
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
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor whiteColor];
	
	self.cButton = [[NUButtonLayer alloc]init];
	
	cButton.anchorPoint = CGPointMake(0.5, 0.5);
	cButton.frame = CGRectMake(200.00, 200.00, 80.0, 30.0);
	//cButton.position = CGPointMake(200.00, 200.00);
	[self.layer addSublayer:cButton];
	[cButton setNeedsDisplay];
	
	
	toggleOpacityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	toggleOpacityButton.frame = CGRectMake(10., 60., 145., 44.);
	[toggleOpacityButton setTitle:@"Toggle Opacity" forState:UIControlStateNormal];
	[toggleOpacityButton addTarget:self action:@selector(toggleOpacity:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:toggleOpacityButton];
		
	
	
}


@end
