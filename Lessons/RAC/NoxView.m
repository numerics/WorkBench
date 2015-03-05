//
//  NoxView.m
//  WorkBench
//
//  Created by John Basile on 1/12/14.
//
//

#import "NoxView.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation NoxView

+ (NSString *)className
{
	return @"NoxEditor";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
    }
    return self;
}
- (void)setUpView
{
	self.backgroundColor = [UIColor whiteColor];
}
















/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
