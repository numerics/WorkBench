//
//  BasicAnimation.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "BasicAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import "UIColor+EliteKit.h"


@implementation BasicAnimation
@synthesize clView,picker;

+ (NSString *)className 
{
	return @"Shadow Animation";
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.clipsToBounds = YES;
        [self setUpView];
	}
    return self;
}

- (GHTextInputView *) textFieldAt: (CGRect) frame
{
    int fontSize = 14;
    
    //frame.size.width -= 10;
    GHTextInputView *textView = [[GHTextInputView alloc] initWithFrame: frame withAnglePadding:[UIColor whiteColor]];
    
    textView.textfield.userInteractionEnabled = YES;
    UIFont *euroBold = [UIFont fontWithName:@"EurostileBold" size:fontSize];
    textView.textfield.font = euroBold;
    textView.textfield.backgroundColor = [UIColor whiteColor];
    textView.textfield.textColor =  [UIColor colorWithHexString:@"0xAAAAAA"];
    textView.textfield.textAlignment = NSTextAlignmentLeft;
    [textView.textfield setReturnKeyType:UIReturnKeyDone];
    
    textView.textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textView.textfield.clearButtonMode = UITextFieldViewModeAlways;
    
    return textView;
}

#pragma mark Setup the View

- (void)setUpView 
{
//    self.backgroundColor  = [UIColor colorWithHexString:@"1b222b"];//[UIColor brownColor];
	self.backgroundColor = [UIColor whiteColor ];
//    UIImageView *cod = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CODImage.png"]];
//
//    [self  addSubview:cod];
    
    WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIFont *euroBold = [UIFont fontWithName:@"EurostileBold" size:14];

    CGRect frame = CGRectMake(10.0, 64, 160.0, 7.0);
	shadowAlpha = [[UISlider alloc] initWithFrame:frame];
	[shadowAlpha addTarget:self action:@selector(AlphaAction:) forControlEvents:UIControlEventValueChanged];
	shadowAlpha.backgroundColor = [UIColor clearColor];
	
	shadowAlpha.minimumValue = 0.0;
	shadowAlpha.maximumValue = 1.0;
	shadowAlpha.continuous = YES;
	shadowAlpha.value = 0.8;
	[evDelegate.benchViewController.parametersView addSubview:shadowAlpha];
	
	shadApha = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 64, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:shadApha];
	shadApha.text = [NSString stringWithFormat:@"Shadow Alpha = %f",shadowAlpha.value];
	shadApha.font = euroBold;

	frame = CGRectMake(10.0, 94, 160.0, 7.0);
	offSetH = [[UISlider alloc] initWithFrame:frame];
	[offSetH addTarget:self action:@selector(offAction:) forControlEvents:UIControlEventValueChanged];
	offSetH.backgroundColor = [UIColor clearColor];
	
	offSetH.minimumValue = -5.0;
	offSetH.maximumValue = 12.0;
	offSetH.continuous = YES;
	offSetH.value = 6.0;
	[evDelegate.benchViewController.parametersView addSubview:offSetH];
	
	offSetY = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 94, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:offSetY];
	offSetY.text = [NSString stringWithFormat:@"OffSet Y = %f",offSetH.value];
	offSetY.font = euroBold;

	frame = CGRectMake(10.0, 124, 160.0, 7.0);
	fradius = [[UISlider alloc] initWithFrame:frame];
	[fradius addTarget:self action:@selector(radiusAction:) forControlEvents:UIControlEventValueChanged];
	fradius.backgroundColor = [UIColor clearColor];
	
	fradius.minimumValue = 0.0;
	fradius.maximumValue = 12.0;
	fradius.continuous = YES;
	fradius.value = 4.0;
	[evDelegate.benchViewController.parametersView addSubview:fradius];
	
	radius = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 124, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:radius];
	radius.text = [NSString stringWithFormat:@"Radius = %f",fradius.value];
	radius.font = euroBold;
	

    CGRect cellFrame;
    
//    cellFrame = CGRectMake (50, 50, 650, 120);
//    
//     self.customView = [[GHCustomContainerView alloc] initWithFrame:cellFrame ];
//     self.customView.borderColor = [UIColor colorWithHexString:@"0x666666"];
//     self.customView.startColor = [UIColor colorWithHexString:@"0x222222"];
//     self.customView.endColor = [UIColor colorWithHexString:@"0x000000"];
//     self.customView.addShadow = YES;
//     self.customView.addTopRightNotch = YES;
//     self.customView.shadowColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
//     
//     self.customView.fillColor = [UIColor colorWithHexString:@"0x222222"];
//     self.customView.alpha = 0.8;
//     self.customView.lineWidth = 1.0;
//     self.customView.shouldCreateGradient = NO;
//
//     [self addSubview:self.customView];
    


    cellFrame = CGRectMake (50, 250, 500, 100);
    self.gsView = [[GHCustomContainerLayer alloc] initWithFrame:cellFrame];
    self.gsView.addTopLeftNotch = YES;
    self.gsView.borderColor = [UIColor colorWithHexString:@"0x666666"];
    self.gsView.lineWidth = 1.0;
    self.gsView.fillAlpha = 0.6;
    self.gsView.shouldCreateGradient = YES;
    self.gsView.addShadow = YES;
    [self addSubview:self.gsView];
    [self.gsView commit];
	
	cellFrame = CGRectMake (50, 450, 500, 210);
	self.statsView = [[GHCustomContainerLayer alloc] initWithFrame:cellFrame];
	self.statsView.addShadow = YES;
    self.statsView.borderColor = [UIColor colorWithHexString:@"0x666666"];
    self.statsView.lineWidth = 1.0;
	self.statsView.fillAlpha = 0.6;
    self.statsView.shouldCreateGradient = YES;
	self.statsView.shadowRadius	= 4.0;
	self.statsView.shadowOffset = CGSizeMake(0.0, 0.0);
	[self addSubview:self.statsView];
	[self.statsView commit];

/*
	self.textView = [self textFieldAt:CGRectMake (100, 20, 274-15, 44)];
	[self addSubview:self.textView];
	
	self.textView.textfield.text = @"Hello";
	self.textView.textfield.textEdgeInsets = UIEdgeInsetsMake(0.0, 35.0, 0.0, 0.0);
	self.textView.textfield.placeholder = @"Enter a Value Please";
	self.textView.textfield.placeholderTextColor = [UIColor redColor];
	
	self.textFld.clearButtonEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -10.0);
	
	
	self.textFld = [[GHTextInputField alloc ] initWithFrame:  CGRectMake (100, 80, 274-15, 44)];
	[self addSubview:self.textFld];
    self.textFld.userInteractionEnabled = YES;
    UIFont *euroBold = [UIFont fontWithName:@"EurostileBold" size:14];
    self.textFld.font = euroBold;
    self.textFld.backgroundColor = [UIColor whiteColor];
    self.textFld.textColor =  [UIColor colorWithHexString:@"0xAAAAAA"];
    self.textFld.textAlignment = NSTextAlignmentLeft;
    [self.textFld setReturnKeyType:UIReturnKeyDone];
    
    self.textFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFld.clearButtonMode = UITextFieldViewModeAlways;
	self.textFld.text = @"Hello";
												//top   lft   btm  rgt
	self.textFld.textEdgeInsets = UIEdgeInsetsMake(0.0, 35.0, 0.0, 0.0);
	self.textFld.placeholder = @"Enter a Value Please";
	self.textFld.placeholderTextColor = [UIColor redColor];
	
	self.textFld.clearButtonEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -10.0);
	
	
	cellFrame = CGRectMake (50, 300, 200, 40);
	self.customBtn = [[GHCustomButtonLayer alloc] initWithFrame:cellFrame Title:@"This is A Button" andSubTitle:@"This is a SubTitle"];
    [self addSubview:self.customBtn];
	
    self.customBtn.addTopLeftNotch = YES;
    self.customBtn.borderColor = [UIColor redColor];
    self.customBtn.lineWidth = 1.0;
    self.customBtn.lineAlpha = 1.0;
    self.customBtn.shouldCreateGradient = YES;
    self.customBtn.addShadow = YES;
	self.customBtn.titleLabel.textColor = [UIColor colorWithHexString:@"0xaaaaaa"];
	self.customBtn.subTitle.textColor = [UIColor colorWithHexString:@"0xaaaaaa"];
	
	[self.customBtn setAlignLabel:kLabelLeft];

	[self.customBtn addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchDown];
	
	[self.customBtn addImage:CGRectMake(0, 0, 16, 16) icon:[UIImage imageNamed:@"little_arrow_white"] selectedIcon:[UIImage imageNamed:@"little_arrow_black"] align:kIconRight];

    [self.customBtn commit];
	

	cellFrame = CGRectMake (50, 380, 200, 40);
	GHCustomButtonLayer *singleLineBtn = [[GHCustomButtonLayer alloc] initWithFrame:cellFrame andTitle:@"This is one line"];
    [self addSubview:singleLineBtn];
	
    singleLineBtn.addTopLeftNotch = YES;
    singleLineBtn.borderColor = [UIColor redColor];
    singleLineBtn.lineWidth = 1.0;
    singleLineBtn.lineAlpha = 1.0;
    singleLineBtn.shouldCreateGradient = YES;
    singleLineBtn.addShadow = YES;
	singleLineBtn.titleLabel.textColor = [UIColor colorWithHexString:@"0xaaaaaa"];
	singleLineBtn.subTitle.textColor = [UIColor colorWithHexString:@"0xaaaaaa"];
	
	//[singleLineBtn setAlignLabel:kLabelLeft];
	
    [singleLineBtn commit];
	[singleLineBtn addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchDown];
*/
    
//    cellFrame = CGRectMake (50, 400, 400, 80);
//	self.picker = [[SSRatingPicker alloc] initWithFrame:cellFrame];
//	self.picker.backgroundColor = [UIColor clearColor];
//	[self addSubview:self.picker];
//	
	
//    self.clView = [[GHClanManageCustomContainerLayer alloc] initWithFrame:cellFrame];
//    [self addSubview:self.clView];
//    self.clView.headerTitle.text = @"clans.clan_mgr_edit_clan_name";
//    self.clView.accessoryImageView = nil;
    
 }
- (void) layoutSubviews
{
    [super layoutSubviews];
    
	self.statsView.left = self.gsView.left;
	self.statsView.top = self.gsView.bottom ;
}

- (void)AlphaAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
    self.gsView.shadowAlpha = sz;
    [self.gsView commit];
	shadApha.text = [NSString stringWithFormat:@"Shadow Alpha = %f",shadowAlpha.value];
}

- (void)radiusAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
    self.gsView.shadowRadius = sz;
    [self.gsView commit];
	radius.text = [NSString stringWithFormat:@"Radius = %f",fradius.value];
}

- (void)offAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
    self.gsView.shadowOffset = CGSizeMake(0.0, sz);
    [self.gsView commit];
	offSetY.text = [NSString stringWithFormat:@"OffSet Y = %f",offSetH.value];
}
- (void)testActionAll
{
	NSLog(@"touchedAll");
}
- (void)testAction
{
	NSLog(@"touched");
}


- (void)dealloc
{
	pulseLayer = nil;
}


@end


