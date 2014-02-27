//
//  AttentionEventAnimation.h
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import "AttentionEventAnimation.h"
#import <CoreText/CoreText.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

#define EXAMPLE_STRING \
@"Watch\n\n" \
@"" \
@"\n\n" \
@" Now"


@implementation AttentionEventAnimation
@synthesize stream;

+ (NSString *)className 
{
	return @"Widget Attention";
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


#pragma mark Load and unload the view

- (void)setUpView 
{
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	attributedTextLayer = [[CATextLayer alloc] init];
	attributedTextLayer.frame = self.bounds;
	[self.layer addSublayer:attributedTextLayer];
	
	animateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	animateButton.frame = CGRectMake(10., 10., 145., 44.);
	[animateButton setTitle:@"Animate Text" forState:UIControlStateNormal];
	[animateButton addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:animateButton];
	
	stream = [[StreamView alloc] initWithFrame:CGRectMake(300, 300, 40, 80)];
	[self addSubview:stream];
	
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
	suggestedSize.height = 100.0;
	return suggestedSize;
}

- (void)setupAttributedTextLayerWithFont:(CTFontRef)font 
{
	NSDictionary *baseAttributes = [NSDictionary dictionaryWithObject:(__bridge id)font 
															   forKey:(NSString *)kCTFontAttributeName];
	
	NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:EXAMPLE_STRING 
																				   attributes:baseAttributes];
	CFRelease(font);  

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
	[stream rotate];
}

- (void)dealloc 
{
	attributedTextLayer = nil;
	normalTextLayer = nil;
}
@end
