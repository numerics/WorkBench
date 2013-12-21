//
//  CoreTextView.m
//  WorkBench
//
//  Created by John Basile on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreTextView.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import "UIFont+AppDefault.h"

#define FONT @"Helvetica"
#define TEXT @"University of @Cambridge researchers have developed  http://LikeAudience.com, a Web site that combines the information people share about themselves on Facebook with profile testing and psychological research data. The site enables any Facebook user to develop a profile of their average follower's personality, intelligence quotient, and satisfaction with life."

@implementation CoreTextView

@synthesize ctLabel, txLineLabel, paragraphLabel;

+ (NSString *)className 
{
	return @"CoreTextView";
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
	self.backgroundColor = [UIColor blueColor];
	
    txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 80)];
    txtLabel.text = TEXT;
    txtLabel.font = [UIFont fontWithName:FONT size:12.0];
    txtLabel.numberOfLines = 3;
    txtLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:txtLabel];

	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	CGRect frame = CGRectMake(10.0, 64, 160.0, 7.0);
	pointSize = [[UISlider alloc] initWithFrame:frame];
	[pointSize addTarget:self action:@selector(pointSizeAction:) forControlEvents:UIControlEventValueChanged];
	pointSize.backgroundColor = [UIColor clearColor];
	
	pointSize.minimumValue = 6.0;
	pointSize.maximumValue = 72.0;
	pointSize.continuous = YES;
	pointSize.value = 16.0;
	[evDelegate.benchViewController.parametersView addSubview:pointSize];
 
    fntLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 64, 60, 26)];
    fntLabel.text = @"16.0";
    
    fntLabel.font = [UIFont appBookFontOfSize:16];
	[evDelegate.benchViewController.parametersView addSubview:fntLabel];
    
	frame = CGRectMake(10.0, 94, 160.0, 7.0);
	kernSize = [[UISlider alloc] initWithFrame:frame];
	[kernSize addTarget:self action:@selector(kernSizeAction:) forControlEvents:UIControlEventValueChanged];
	kernSize.backgroundColor = [UIColor clearColor];
	
	kernSize.minimumValue = 0.0;
	kernSize.maximumValue = 1.0;
	kernSize.continuous = YES;
	kernSize.value = 0.5;
	[evDelegate.benchViewController.parametersView addSubview:kernSize];
    
    paragraphLabel = [[CTLabel alloc] initWithFrame:CGRectMake(100, 300, 300, 80) ];
    [paragraphLabel CTLabelFont:[UIFont appBookFontName] CTFontSize:16 CTTextColor:[UIColor redColor] ];
    [paragraphLabel ElipseAtFrac:0.5];
	paragraphLabel.text = TEXT;
    paragraphLabel.numberOfLines = 3;
	paragraphLabel.adjustsFontSizeToFitWidth = YES;
    paragraphLabel.VerticalAlignment = CTVerticalAlignmentBottom;
    paragraphLabel.createLinkButtons = YES;
    [paragraphLabel setLinkButtonCallBack:self theSelector:@selector(buttonTapped)];
    
    [self addSubview:paragraphLabel];
}

-(void)buttonTapped:(id)sender
{
    CTLinkButton *tp = (CTLinkButton *)sender;
    NSLog(@"The Button Title Selected is:%@",tp.title);
}

- (void)kernSizeAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    [paragraphLabel ElipseAtFrac:slider.value];
}

- (void)pointSizeAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    int sz = (int)slider.value;
    fntLabel.text = [NSString stringWithFormat:@"%d pt",sz];
    txtLabel.font = [UIFont fontWithName:FONT size:sz];
    
    //[ctLabel setGlyphSize:slider.value];
    //[txLineLabel setTextSize:slider.value];
    [paragraphLabel setTextSize:(CGFloat)sz];
}


@end
