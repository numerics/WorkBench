//
//  TextLayers.m
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

/*
 Delicious font by Jos Buivenga (exljbris) -> http://www.exljbris.com
 Retrieved from http://www.josbuivenga.demon.nl/delicious.html
*/

#import "TextLayers.h"
#import <CoreText/CoreText.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

#define EXAMPLE_STRING \
@"Hello everyone! I am a CATextLayer.\n\n" \
@"I can render any attributed string you want. " \
@"Even if it's long like this one and wraps.\n\n" \
@"Welcome to the iPhone Dev LA Meetup\n\n" \
@"A blue link: http://www.numericsmobile.com/"


@implementation TextLayers

+ (NSString *)className 
{
  return @"Text Layers";
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
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor whiteColor];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	attributedTextLayer = [[CATextLayer alloc] init];
	attributedTextLayer.frame = self.bounds;
	[self.layer addSublayer:attributedTextLayer];
	
	animateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	animateButton.frame = CGRectMake(10., 10., 300., 44.);
	[animateButton setTitle:@"Animate!" forState:UIControlStateNormal];
	[animateButton addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:animateButton];

	CTFontRef font = [self newCustomFontWithName:@"Delicious-Roman" 
										  ofType:@"otf" 
									  attributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:16.f] 
																			 forKey:(NSString *)kCTFontSizeAttribute]];
	[self setupAttributedTextLayerWithFont:font];
	
	normalTextLayer = [[CATextLayer alloc] init];
	normalTextLayer.font = font;
	normalTextLayer.string = @"This is just a plain old CATextLayer";
	normalTextLayer.wrapped = YES;
	normalTextLayer.foregroundColor = [[UIColor purpleColor] CGColor];
	normalTextLayer.fontSize = 20.f;
	normalTextLayer.alignmentMode = kCAAlignmentCenter;
	normalTextLayer.frame = CGRectMake(0.f, 10.f, 320.f, 32.f);
	[self.layer addSublayer:normalTextLayer];
	CFRelease(font);
	


}

#pragma mark View drawing

- (void)colorAndUnderlineLinksInAttributedString:(NSMutableAttributedString *)attrString 
                                       withColor:(UIColor *)linkColor 
                                  underlineStyle:(CTUnderlineStyle)underlineStyle
{
	//NSDataDetector is part of the new (in iOS 4) regular expression engine
	Class nsDataDetector = NSClassFromString(@"NSDataDetector");
	if(nsDataDetector) 
	{
		NSError *error = nil;
		id linkDetector = [nsDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
		[linkDetector enumerateMatchesInString:[attrString string]
									   options:0 
										 range:NSMakeRange(0, [attrString length]) 
									usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) 
		 {
			 [attrString addAttribute:(NSString *)kCTForegroundColorAttributeName 
								value:(id)[linkColor CGColor] 
								range:[match range]];
			 
			 [attrString addAttribute:(NSString *)kCTUnderlineStyleAttributeName 
								value:[NSNumber numberWithInt:underlineStyle] 
								range:[match range]];
		 }];
	} 
}

- (CTFontRef)newFontWithAttributes:(NSDictionary *)attributes 
{
	CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
	CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, 0, NULL);
	CFRelease(descriptor);
	return font;
}

- (CTFontRef)newCustomFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes 
{
	NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:type];
	
	NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
	CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	
	CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
	CGDataProviderRelease(fontProvider);
	
	CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
	CTFontRef font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
	CFRelease(fontDescriptor);
	CGFontRelease(cgFont);
	return font;
}

- (CGSize)suggestSizeAndFitRange:(CFRange *)range 
             forAttributedString:(NSMutableAttributedString *)attrString 
                       usingSize:(CGSize)referenceSize
{
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
	CGSize suggestedSize = 
	CTFramesetterSuggestFrameSizeWithConstraints(framesetter, 
												 CFRangeMake(0, [attrString length]), 
												 NULL,
												 referenceSize,
												 range);
	
	//HACK: There is a bug in Core Text where suggested size is not quite right
	//I'm padding it with half line height to make up for the bug.
	//see the coretext-dev list: http://web.archiveorange.com/archive/v/nagQXwVJ6Gzix0veMh09
	
	CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
	CGFloat ascent, descent, leading;
	CTLineGetTypographicBounds(line, &ascent, &descent, &leading);  
	CGFloat lineHeight = ascent + descent + leading;
	suggestedSize.height += lineHeight / 2.f;
	//END HACK
	
	return suggestedSize;
}

- (void)setupAttributedTextLayerWithFont:(CTFontRef)font 
{
	NSDictionary *baseAttributes = [NSDictionary dictionaryWithObject:(__bridge id)font
															   forKey:(NSString *)kCTFontAttributeName];
	
	NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:EXAMPLE_STRING 
																				   attributes:baseAttributes];
	CFRelease(font);  
	
	[self colorAndUnderlineLinksInAttributedString:attrString 
										 withColor:[UIColor blueColor] 
									underlineStyle:kCTUnderlineStyleSingle|kCTUnderlinePatternDash];
	
	//Make the class name in the string Courier Bold and red
	NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
									@"Courier", (NSString *)kCTFontFamilyNameAttribute,
									@"Bold", (NSString *)kCTFontStyleNameAttribute,
									[NSNumber numberWithFloat:16.f], (NSString *)kCTFontSizeAttribute,
									nil];
	CTFontRef courierFont = [self newFontWithAttributes:fontAttributes];
	
	NSRange rangeOfClassName = [[attrString string] rangeOfString:@"CATextLayer"];
	
	[attrString addAttribute:(NSString *)kCTFontAttributeName 
					   value:(__bridge id)courierFont 
					   range:rangeOfClassName];
	[attrString addAttribute:(NSString *)kCTForegroundColorAttributeName 
					   value:(id)[[UIColor redColor] CGColor] 
					   range:rangeOfClassName];
	
	CFRelease(courierFont);
	
	attributedTextLayer.string = attrString;
	attributedTextLayer.wrapped = YES;
	CFRange fitRange;
	CGRect textDisplayRect = CGRectInset(attributedTextLayer.bounds, 10.f, 10.f);
	CGSize recommendedSize = [self suggestSizeAndFitRange:&fitRange 
									  forAttributedString:attrString 
												usingSize:textDisplayRect.size];
	[attributedTextLayer setValue:[NSValue valueWithCGSize:recommendedSize] forKeyPath:@"bounds.size"];
	attributedTextLayer.position = self.center;
}


#pragma mark Event Handlers

- (void)animate:(id)sender 
{
	CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	spin.toValue = [NSNumber numberWithFloat:M_PI * 2];
	spin.duration = 1.f;
	spin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	[CATransaction begin];
	[CATransaction setCompletionBlock:^{
		CABasicAnimation *squish = [CABasicAnimation animationWithKeyPath:@"transform"];
		CATransform3D squishTransform = CATransform3DMakeScale(1.75f, .25f, 1.f);
		squish.toValue = [NSValue valueWithCATransform3D:squishTransform];
		squish.duration = .5f;
		squish.repeatCount = 1;
		squish.autoreverses = YES;
		
		CABasicAnimation *fadeOutBG = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
		fadeOutBG.toValue = (id)[[UIColor yellowColor] CGColor];
		fadeOutBG.duration = .55f;
		fadeOutBG.repeatCount = 1;
		fadeOutBG.autoreverses = YES;
		fadeOutBG.beginTime = 1.f;
		
		CAAnimationGroup *group = [CAAnimationGroup animation];
		group.animations = [NSArray arrayWithObjects:squish, fadeOutBG, nil];
		group.duration = 2.f;
		group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		
		[attributedTextLayer addAnimation:group forKey:@"SquishAndHighlight"];
	}];
	
	[attributedTextLayer addAnimation:spin forKey:@"spinTheText"];
	[CATransaction commit];
}

- (void)dealloc 
{
	attributedTextLayer = nil;
	normalTextLayer = nil;
}

@end
