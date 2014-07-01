//
//  StyleProperties.m
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "StyleProperties.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import "AnimationGroups.h"
#import "CKShareButton.h"
#import "CKHeartButton.h"
#import "CKCommentButton.h"

@interface StyleProperties()

@property(nonatomic, strong) AnimationGroups *amp;
@property(nonatomic, strong) CKShareButton *shareBtn;
@property(nonatomic, strong) CKHeartButton *heartBtn;
@property(nonatomic, strong) CKCommentButton *commentBtn;

@property(nonatomic, strong) UILabel *wdLabel, *hgtLabel;
@end

@implementation StyleProperties

+ (NSString *)className 
{
	return @"Style Properties";
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
		[self setupPieMenu];
	}
    return self;
}

#pragma mark Setup the View

- (void)setUpView 
{
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor whiteColor];
    UIFont *euroBold = [UIFont fontWithName:@"EurostileBold" size:11];

//	self.amp = [[AnimationGroups alloc] initWithFrame:CGRectMake(200, 200, 85.0, 75.0)];
//	[self addSubview:self.amp];
	
	
	self.shareBtn = [[CKShareButton alloc]initWithFrame:CGRectMake(100, 100, 85.0, 75.0)];
	[self addSubview:self.shareBtn];
	self.shareBtn.borderColor = [UIColor blackColor];
	self.shareBtn.fillColor = [UIColor redColor];
	self.shareBtn.startColor = [UIColor lightGrayColor];
	self.shareBtn.endColor = [UIColor darkGrayColor];
	self.shareBtn.gradientButton = NO;
	self.shareBtn.lineWidth = 1.0;
	//[self.shareBtn commit];
	
	
	self.heartBtn = [[CKHeartButton alloc]initWithFrame:CGRectMake(200, 300, 85.0, 75.0)];
	[self addSubview:self.heartBtn];
	self.heartBtn.borderColor = [UIColor blackColor];
	self.heartBtn.fillColor = [UIColor redColor];
	self.heartBtn.startColor = [UIColor lightGrayColor];
	self.heartBtn.endColor = [UIColor darkGrayColor];
	self.heartBtn.gradientButton = NO;
	self.heartBtn.lineWidth = 1.0;
	//[self.heartBtn commit];

	self.commentBtn = [[CKCommentButton alloc]initWithFrame:CGRectMake(400, 500, 85.0, 75.0)];
	[self addSubview:self.commentBtn];
	self.commentBtn.borderColor = [UIColor blackColor];
	self.commentBtn.fillColor = [UIColor redColor];
	self.commentBtn.startColor = [UIColor lightGrayColor];
	self.commentBtn.endColor = [UIColor darkGrayColor];
	self.commentBtn.gradientButton = NO;
	self.commentBtn.lineWidth = 1.0;
	//[self.commentBtn commit];

	/////////  Width Slider + Label
	CGRect frame = CGRectMake(10.0, 200, 160.0, 7.0);
	UISlider *wd = [[UISlider alloc] initWithFrame:frame];
	[wd addTarget:self action:@selector(WidthAction:) forControlEvents:UIControlEventValueChanged];
	wd.backgroundColor = [UIColor clearColor];
	
	wd.minimumValue = 30.0;
	wd.maximumValue = 400.0;
	wd.continuous = YES;
	wd.value = 85.0;
	[evDelegate.benchViewController.parametersView addSubview:wd];
	
	self.wdLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 200, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:self.wdLabel];
	self.wdLabel.text = [NSString stringWithFormat:@"Width = %.2f",wd.value];
	self.wdLabel.font = euroBold;
	
	/////////  Width Slider + Label
	frame = CGRectMake(10.0, 240, 160.0, 7.0);
	UISlider *hgt = [[UISlider alloc] initWithFrame:frame];
	[hgt addTarget:self action:@selector(HeightAction:) forControlEvents:UIControlEventValueChanged];
	hgt.backgroundColor = [UIColor clearColor];
	
	hgt.minimumValue = 30.0;
	hgt.maximumValue = 400.0;
	hgt.continuous = YES;
	hgt.value = 75.0;
	[evDelegate.benchViewController.parametersView addSubview:hgt];
	
	self.hgtLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 240, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:self.hgtLabel];
	self.hgtLabel.text = [NSString stringWithFormat:@"Height = %.2f",hgt.value];
	self.hgtLabel.font = euroBold;

	CGFloat y0 = 30.0;
	CGFloat yd = 40.0;
	
	/////////  Alpha Slider + Label
	frame = CGRectMake(10.0, y0, 160.0, 7.0);
	Alpha = [[UISlider alloc] initWithFrame:frame];
	[Alpha addTarget:self action:@selector(AlphaAction:) forControlEvents:UIControlEventValueChanged];
	Alpha.backgroundColor = [UIColor clearColor];
	
	Alpha.minimumValue = 0.0;
	Alpha.maximumValue = 1.0;
	Alpha.continuous = YES;
	Alpha.value = 1.00;
	[evDelegate.benchViewController.parametersView addSubview:Alpha];
	
	self.alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, y0, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:self.alphaLabel];
	self.alphaLabel.text = [NSString stringWithFormat:@"Alpha = %.2f",Alpha.value];
	self.alphaLabel.font = euroBold;
	[evDelegate.benchViewController.parametersView addSubview:self.alphaLabel];
	
	
	/////////  Red Color Slider  + Label
	y0 = y0 + yd;
	frame = CGRectMake(10.0, y0, 160.0, 16.0);
	redC = [[UISlider alloc] initWithFrame:frame];
	[redC addTarget:self action:@selector(redAction:) forControlEvents:UIControlEventValueChanged];
	redC.backgroundColor = [UIColor clearColor];
	
	redC.minimumValue = 0;
	redC.maximumValue = 255;
	redC.continuous = YES;
	redC.value = 255;
	[evDelegate.benchViewController.parametersView addSubview:redC];
	
	redLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, y0, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:redLabel];
	redLabel.text = [NSString stringWithFormat:@"Red = %.2f",redC.value];
	redLabel.font = euroBold;
	[evDelegate.benchViewController.parametersView addSubview:redLabel];
	
	
	/////////  Green Color Slider  + Label
	y0 = y0 + yd;
	frame = CGRectMake(10.0, y0, 160.0, 7.0);
	greenC = [[UISlider alloc] initWithFrame:frame];
	[greenC addTarget:self action:@selector(greenAction:) forControlEvents:UIControlEventValueChanged];
	greenC.backgroundColor = [UIColor clearColor];
	
	greenC.minimumValue = 0;
	greenC.maximumValue = 255;
	greenC.continuous = YES;
	greenC.value = 0;
	[evDelegate.benchViewController.parametersView addSubview:greenC];
	
	greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, y0, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:greenLabel];
	greenLabel.text = [NSString stringWithFormat:@"Green = %.2f",greenC.value];
	greenLabel.font = euroBold;
	[evDelegate.benchViewController.parametersView addSubview:greenLabel];
	
	/////////  Blue Color Slider  + Label
	y0 = y0 + yd;
	frame = CGRectMake(10.0, y0, 160.0, 7.0);
	blueC = [[UISlider alloc] initWithFrame:frame];
	[blueC addTarget:self action:@selector(blueAction:) forControlEvents:UIControlEventValueChanged];
	blueC.backgroundColor = [UIColor clearColor];
	
	blueC.minimumValue = 0;
	blueC.maximumValue = 255;
	blueC.continuous = YES;
	blueC.value = 0;
	[evDelegate.benchViewController.parametersView addSubview:blueC];
	
	blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, y0, 180.0, 16.0)];
	[evDelegate.benchViewController.parametersView addSubview:blueLabel];
	blueLabel.text = [NSString stringWithFormat:@"Blue = %.2f",blueC.value];
	blueLabel.font = euroBold;
	
	
	
}
- (void)AlphaAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
	self.alphaLabel.text = [NSString stringWithFormat:@"Alpha = %.2f",sz];

    self.shareBtn.fillAlpha = sz;
	[self.shareBtn update];

    self.heartBtn.fillAlpha = sz;
	[self.heartBtn update];

    self.commentBtn.fillAlpha = sz;
	[self.commentBtn update];
}

- (void)redAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
    self.redValue = sz/255.0;
	redLabel.text = [NSString stringWithFormat:@"Red = %.2f",sz];

	self.shareBtn.fillColor = [UIColor colorWithRed: self.redValue green: self.greenValue blue: self.blueValue alpha: self.shareBtn.fillAlpha];
	self.shareBtn.startColor = [UIColor colorWithRed: 1.0-self.redValue green: 1.0-self.greenValue blue: 1.0-self.blueValue alpha: self.shareBtn.fillAlpha];
	self.shareBtn.endColor = self.shareBtn.fillColor;
	//[self.shareBtn update];

    self.heartBtn.fillColor = self.shareBtn.fillColor;
    self.heartBtn.startColor = self.shareBtn.startColor;
    self.heartBtn.endColor = self.shareBtn.endColor;
	//[self.heartBtn update];
	
    self.commentBtn.fillColor = self.shareBtn.fillColor;
    self.commentBtn.startColor = self.shareBtn.startColor;
    self.commentBtn.endColor = self.shareBtn.endColor;
	//[self.commentBtn update];
}

- (void)greenAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
	greenLabel.text = [NSString stringWithFormat:@"Green = %.2f",sz];

    self.greenValue = sz/255.0;
	self.shareBtn.fillColor = [UIColor colorWithRed: self.redValue green: self.greenValue blue: self.blueValue alpha: self.shareBtn.fillAlpha];
	self.shareBtn.startColor = [UIColor colorWithRed: 1.0-self.redValue green: 1.0-self.greenValue blue: 1.0-self.blueValue alpha: self.shareBtn.fillAlpha];
	self.shareBtn.endColor = self.shareBtn.fillColor;
	//[self.shareBtn update];

    self.heartBtn.fillColor = self.shareBtn.fillColor;
    self.heartBtn.startColor = self.shareBtn.startColor;
    self.heartBtn.endColor = self.shareBtn.endColor;
	//[self.heartBtn update];
	
    self.commentBtn.fillColor = self.shareBtn.fillColor;
    self.commentBtn.startColor = self.shareBtn.startColor;
    self.commentBtn.endColor = self.shareBtn.endColor;
	//[self.commentBtn update];
}

- (void)blueAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
	blueLabel.text = [NSString stringWithFormat:@"Blue = %.2f",sz];
    self.blueValue = sz/255.0;
	
	self.shareBtn.fillColor = [UIColor colorWithRed: self.redValue green: self.greenValue blue: self.blueValue alpha: self.shareBtn.fillAlpha];
	self.shareBtn.startColor = [UIColor colorWithRed: 1.0-self.redValue green: 1.0-self.greenValue blue: 1.0-self.blueValue alpha: self.shareBtn.fillAlpha];
	self.shareBtn.endColor = self.shareBtn.fillColor;
	//[self.shareBtn update];
	
    self.heartBtn.fillColor = self.shareBtn.fillColor;
    self.heartBtn.startColor = self.shareBtn.startColor;
    self.heartBtn.endColor = self.shareBtn.endColor;
	//[self.heartBtn update];
	
    self.commentBtn.fillColor = self.shareBtn.fillColor;
    self.commentBtn.startColor = self.shareBtn.startColor;
    self.commentBtn.endColor = self.shareBtn.endColor;
	//[self.commentBtn update];
}


- (void)WidthAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
	self.wdLabel.text = [NSString stringWithFormat:@"Width = %.2f",sz];
	
	self.shareBtn.width = sz;
	[self.shareBtn setNeedsDisplay];
	
    self.heartBtn.width = sz;
	[self.heartBtn setNeedsDisplay];
	
    self.commentBtn.width = sz;
	[self.heartBtn setNeedsDisplay];}

- (void)HeightAction:(id)sender
{
	UISlider *slider = (UISlider *)sender;
    CGFloat sz = (CGFloat)slider.value;
	self.hgtLabel.text = [NSString stringWithFormat:@"Height = %.2f",sz];
	
	self.shareBtn.height = sz;
	//[self.shareBtn update];
	
    self.heartBtn.height = sz;
	//[self.heartBtn update];
	
    self.commentBtn.height = sz;
	//[self.commentBtn update];
}



#pragma mark -
#pragma mark PieMenu
- (void)setupPieMenu
{
	self.pieMenu = [[PieMenu alloc] init];
	PieMenuItem *itemA = [[PieMenuItem alloc] initWithTitle:@"Images"
													  label:nil
													 target:self
												   selector:@selector(itemSelected:)
												   userInfo:nil
													   icon:nil]; // [UIImage imageNamed:@"icon1.png"]];
	itemA.userInfo = itemA;
	
	PieMenuItem *itemB = [[PieMenuItem alloc] init];
	itemB.title = @"Movies";
	itemB.target = self;
	itemB.action = @selector(itemSelected:);
	itemB.userInfo = itemB;
    
	PieMenuItem *itemC = [[PieMenuItem alloc] init];
	itemC.title = @"Maps";
	itemC.target = self;
	itemC.action = @selector(itemSelected:);
	itemC.userInfo = itemC;
	// itemC.icon = [UIImage imageNamed:@"icon2.png"];
    
	PieMenuItem *itemD = [[PieMenuItem alloc] init];
	itemD.title = @"Business";
	itemD.target = self;
	itemD.action = @selector(itemSelected:);
	itemD.userInfo = itemD;
	// itemD.icon = [UIImage imageNamed:@"icon3.png"];
    
	PieMenuItem *itemE = [[PieMenuItem alloc] init];
	itemE.title = @"News";
	itemE.target = self;
	itemE.action = @selector(itemSelected:);
	itemE.userInfo = itemE;
	// itemE.icon = [UIImage imageNamed:@"icon4.png"];
    
	PieMenuItem *itemF = [[PieMenuItem alloc] init];
	itemF.title = @"Direct";
	itemF.target = self;
	itemF.action = @selector(itemSelected:);
	itemF.userInfo = itemF;
	// itemF.icon = [UIImage imageNamed:@"icon4.png"];
	
	PieMenuItem* itemVoiceSearch = [[PieMenuItem alloc] init];
	itemVoiceSearch.title = @"Voice Search";
	itemVoiceSearch.target = self;
	itemVoiceSearch.action = @selector(itemSelected:);
	
	[self.pieMenu addItem:itemA];
	[self.pieMenu addItem:itemB];
	[self.pieMenu addItem:itemC];
	[self.pieMenu addItem:itemD];
	[self.pieMenu addItem:itemE];
	[self.pieMenu addItem:itemF];
	
	
	[self.pieMenu setCenterImage:[UIImage imageNamed:@"centerLogo.png"]];
	
}

- (void) itemSelected:(PieMenuItem *)item
{
	NSLog(@"Item '%s' selected", [item.title UTF8String]);
}
/*
- (void)fingerStillDown:(NSSet*)touches
{
	//NSLog(@"touches: %@",touches);
	
	UITouch *touch = [touches anyObject];
	if (touch.phase == UITouchPhaseStationary)
    {
		CGPoint p = [touch locationInView:self];
		[self.pieMenu showInView:self atPoint:p];
		[[self.pieMenu view] becomeFirstResponder];
	}
}
*/
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fingerStillDown:) object:nil];
//	[super touchesEnded:touches withEvent:event];
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fingerStillDown:) object:nil];
//	[super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	[self performSelector:@selector(fingerStillDown:) withObject:touches afterDelay:0.4];
//	[super touchesBegan:touches withEvent:event];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	[self.pieMenu showInView:self atPoint:p];
    [super touchesBegan:touches withEvent:event];
}
#pragma mark Event Handlers
- (void)toggleMaskLayer:(id)sender
{
    CALayer *mask;
    //	CALayer *mask = (simpleLayer.mask == nil) ? maskLayer : nil;
    if( simpleLayer.mask == nil )
        mask = maskLayer;
    else
        mask = nil;
    
	simpleLayer.mask = mask;
}

- (void)roundCorners:(id)sender 
{
	if(simpleLayer.cornerRadius > 0.) 
	{
		simpleLayer.cornerRadius = 0.;
	} 
	else 
	{
		simpleLayer.cornerRadius = 25.;
	}
}

- (void)toggleBorder:(id)sender 
{
	if(simpleLayer.borderWidth > 0.) 
	{
		simpleLayer.borderWidth = 0.;
	} 
	else 
	{
		simpleLayer.borderWidth = 4.;
		simpleLayer.borderColor = [[UIColor redColor] CGColor];
	}
}

- (void)toggleOpacity:(id)sender 
{
	if(simpleLayer.opacity < 1.) 
	{
		simpleLayer.opacity = 1.;
	} 
	else 
	{
		simpleLayer.opacity = .25;
	}
}


@end
