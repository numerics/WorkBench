//
//  ProgressBarTestView.m
//  WorkBench
//
//  Created by John Basile on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgressBarTestView.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"


@implementation ProgressBarTestView
@synthesize progressBar;

+ (NSString *)className 
{
	return @"ProgressBar";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor brownColor];
       	progressBar =  [[ProgressBar alloc] initWithFrame:CGRectMake(200., 200., 320, 100.)];	
        progressBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:progressBar];
        
        WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        startButton.frame = CGRectMake(10., 10., 145., 44.);
        [startButton setTitle:@"Start Progress" forState:UIControlStateNormal];
        [startButton addTarget:self action:@selector(startProgress:) forControlEvents:UIControlEventTouchUpInside];
        [evDelegate.benchViewController.parametersView addSubview:startButton];
    }
    return self;
}

#pragma mark Event Handlers
- (void)updateProgress:(id)sender 
{
	CGFloat p = progressBar.progress;
    p = p + 0.01;
    if( p > 1.0 )
    {
        progressBar.progress = 1.0;
    }
    else
    {
        progressBar.progress = p;
        [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateProgress:) userInfo:nil repeats:NO];
    }
}

- (void)startProgress:(id)sender 
{
    progressBar.progress = 0.0;
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateProgress:) userInfo:nil repeats:NO];
    
}



@end
