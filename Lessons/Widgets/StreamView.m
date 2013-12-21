//
//  StreamView.m
//
//  Created by John Basile on 12/6/10.
//  Copyright 2010 Numerics. All rights reserved.
//

#import "StreamView.h"

#define EXAMPLE_STRING \
@"Watch\n\n" \
@"\n" \
@"\n\n" \
@" Now"


@implementation StreamView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		attributedTextLayer = [[CATextLayer alloc] init];
		CGRect layerFrame = [self bounds];
		attributedTextLayer.frame = layerFrame;
		attributedTextLayer.backgroundColor = [[UIColor whiteColor] CGColor];
		[self.layer addSublayer:attributedTextLayer];
		layerFrame = self.layer.frame;
		self.backgroundColor = [UIColor whiteColor];

/*
		CALayer *backLayer = [CALayer layer]; 
		backLayer.frame = self.bounds;
		CGImageRef sourceImageRef = [[UIImage imageNamed:@"glow.png"] CGImage]; 
		backLayer.contents = (id)sourceImageRef;
		[attributedTextLayer addSublayer:backLayer];
		
		UIImageView *glowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glow.png"]];
		glowImage.frame = CGRectMake(25.0, 25.0, 50.0, 50.0);
		[self addSubview:glowImage];
*/
		
		CTFontRef font = [self newCustomFontWithName:@"Helvetics-Nueva" 
											  ofType:@"otf" 
										  attributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:13.f] 
																				 forKey:(NSString *)kCTFontSizeAttribute]];
		[self setupAttributedTextLayerWithFont:font];
		CFRelease(font);
		
 		UIButton *streamButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[streamButton setTitle: @"Animate Text" forState:UIControlStateNormal];
		streamButton.bounds = CGRectMake(0.0, 0.0, 35.0, 35.0);
		streamButton.center = CGPointMake(self.center.x - 300, self.center.y - 300);
		//streamButton.center = CGPointMake(self.center.x - 50, self.center.y-52);
		[streamButton setImage:[UIImage imageNamed:@"livestream_offSM.png"] forState:UIControlStateNormal];
		[streamButton addTarget:self action:@selector(activate) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:streamButton];
	}
    return self;
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
	suggestedSize.height = 80;
	suggestedSize.width = 40;
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
	//attributedTextLayer.position = self.center;
	
	//CGRect lFrame = attributedTextLayer.frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
}
*/
- (void)rotate 
{
	CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	spin.toValue = [NSNumber numberWithFloat:M_PI * 2];
	spin.duration = 2.f;
	spin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	[CATransaction begin];
	[attributedTextLayer addAnimation:spin forKey:@"spinTheText"];
	[CATransaction commit];
}

- (void)activate 
{
	[self rotate];
}


@end
