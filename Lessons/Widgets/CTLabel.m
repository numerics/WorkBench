//
//  CTLabel.m
//
//  Created by John Basile on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CTLabel.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import <CoreText/CoreText.h>
#import "UIFont+AppDefault.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@implementation CTLabel

@synthesize numberOfLines = _numberOfLines;
@synthesize textAlignment;
@synthesize lineBreakMode;
@synthesize adjustsFontSizeToFitWidth,createLinkButtons;
@synthesize VerticalAlignment,callback,btnDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _fontSize = 16.0;
        fraction = 1.0;
		_minFontSize = 6.0;
		_originalFontSize = _fontSize;
		adjustsFontSizeToFitWidth = NO;
        createLinkButtons = NO;
        self.backgroundColor = [UIColor whiteColor];
		self.layer.shouldRasterize = YES;
        self.numberOfLines = 1;
        self.VerticalAlignment  = CTVerticalAlignmentCenter;
    }
    return self;
}

// NSMutableAttributedString:
NS_INLINE CFMutableAttributedStringRef	UKNSToCFMutableAttributedString( NSMutableAttributedString* inMutableAttributedString )
{
	return (__bridge CFMutableAttributedStringRef)inMutableAttributedString;
}


NS_INLINE NSMutableAttributedString*	UKCFToNSMutableAttributedString( CFMutableAttributedStringRef inMutableAttributedString )
{
	return (__bridge NSMutableAttributedString*)inMutableAttributedString;
}

#pragma mark Advanced Label Methods

- (void)CTLabelFont:(NSString *)font CTFontSize:(CGFloat)fSize
{
    _font = font;
    _fontSize = fSize;
	_originalFontSize = _fontSize;
	[self setNeedsDisplay];
}

- (void)CTLabelFont:(NSString *)font CTFontSize:(CGFloat)fSize CTTextColor:(UIColor *)txtColor
{
    _font = font;
    _fontSize = fSize;
	_originalFontSize = _fontSize;
    _textColor = txtColor;
	[self setNeedsDisplay];
}

- (void)CTTextColor:(UIColor *)txtColor
{
    _textColor = txtColor;
	[self setNeedsDisplay];
}

- (void)CTFontSize:(CGFloat)fSize
{
    _fontSize = fSize;
}

- (void)CTLabelFont:(NSString *)f
{
    _font = f;    
}

- (void)ElipseAtFrac:(CGFloat)frac
{
    fraction = frac;
}

- (void)CTLabelText:(NSString *)txt
{
    _text = txt;
	[self setNeedsDisplay];
}

#pragma mark Basic Label Setters

-(void)setLineBreakMode:(UILineBreakMode )n
{
	lineBreakMode = n;
	[self setNeedsDisplay];
}

-(void)setTextAlignment:(UITextAlignment )t
{
	textAlignment = t;
	[self setNeedsDisplay];
}

-(void) setFontWithName:(NSString *)f andSize:(CGFloat) s
{
	_font = f;
	_fontSize = s;
	_originalFontSize = _fontSize;
	[self setNeedsDisplay];
}

-(void)setFont:(NSString *)f
{
	_font = f;
	[self setNeedsDisplay];
}
-(NSString *)font
{
	return _font;
}

-(void)setFontSize:(CGFloat)size
{
	_fontSize = size;
	_originalFontSize = _fontSize;
	[self setNeedsDisplay];
	
}
-(CGFloat)fontSize
{
	return _fontSize;
}

-(void)setText:(NSString *)text
{
	_text = text;
	[self setNeedsDisplay];
}
-(NSString *)text
{
	return _text;
}

-(void)setTextColor:(UIColor *)color
{
	_textColor = color;
	[self setNeedsDisplay];
}
-(UIColor *)textColor
{
	return _textColor;
}

#pragma mark Label Drawing Methods

CTParagraphStyleRef CreateFullCTStyle       ( 
                                       int     align,
                                       int     linebreak
                                             ) 
{ 
    CTTextAlignment alignment = align;                              //kCTLeftTextAlignment; 
    CTLineBreakMode breakMode = linebreak;                          //kCTLineBreakByTruncatingTail;//kCTLineBreakByWordWrapping;; 
    CTWritingDirection direction = kCTWritingDirectionLeftToRight; 
        
    CGFloat firstLineIndent = 0.0; 
    CGFloat headIndent  = 0.0;
    CGFloat tailIndent = 0.0; 
    CGFloat lineHeightMultiple = 0.0; 
    CGFloat maxLineHeight = 0.0; 
    CGFloat minLineHeight = 0.0; 
    CGFloat lineSpacing = 0.0;
    CGFloat paragraphSpacing = 0.0;
    CGFloat paragraphSpacingBefore = 0.0;

    CTParagraphStyleSetting settings[] = 
    { 
        { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment }, 
        { kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &breakMode }, 
        { kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &direction }, 
        { kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineIndent }, 
        { kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent }, 
        { kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent }, 
        { kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple }, 
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight }, 
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight }, 
        { kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing }, 
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing }, 
        { kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore }, 
    }; 
    
    CTParagraphStyleRef style; 
    style = CTParagraphStyleCreate( settings, sizeof(settings) / sizeof(CTParagraphStyleSetting) ); 
    return style;
}

- (CGRect)CTRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect frame;
    CGFloat lh = [self lineHeight];
    CGFloat dh = lh * numberOfLines;
    
    if( dh < bounds.size.height )
    {
        frame = CGRectMake(0.0, 0.0, bounds.size.width, dh);
    }
    else
    {
        frame = bounds;
    }
    
    return (frame);
}

- (CGFloat)lineHeight
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)_font, _fontSize, NULL);
    CGFloat h = CTFontGetAscent(ctFont) + CTFontGetDescent(ctFont) + CTFontGetLeading(ctFont);
    CFRelease(ctFont);
    return h;
}

- (int )NumberOfVisibleCharacters:(CGRect)xrect limitedToNumberOfLines:(NSInteger)numberOfLines
{
	CGRect				LineBounds;
	int					charCount;
    CTFrameRef			frame;
    CTFramesetterRef	framesetter;
	
	
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)_font, _fontSize, NULL);
	CFMutableAttributedStringRef aStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	CFAttributedStringReplaceString (aStr, CFRangeMake(0, 0), (__bridge CFStringRef) self.text);
	CFAttributedStringSetAttribute(aStr, CFRangeMake(0, CFAttributedStringGetLength(attStr)), kCTFontAttributeName, ctFont);
	LineBounds = [self CTRectForBounds:xrect limitedToNumberOfLines:numberOfLines];
	CGMutablePathRef tempPath = CGPathCreateMutable();
	CGPathAddRect(tempPath, NULL, LineBounds);

	framesetter = CTFramesetterCreateWithAttributedString(attStr);    
	frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), tempPath, NULL);
	CFRange visibleRange = CTFrameGetVisibleStringRange(frame); 
	charCount = visibleRange.length;
	
	CFRelease(aStr);
    CFRelease(ctFont);
	CFRelease(frame);
	CFRelease(framesetter);
	CGPathRelease(tempPath);
    return charCount;
}

- (void)CreateAttributeStringWithStyle:(NSString *)string ForBounds:(CGRect)xrect
{
	CGRect LineBounds;
    CTFrameRef frame;
    CTFramesetterRef framesetter;
    CTFontRef ctFont;
	CGColorRef color;
	CTParagraphStyleRef style1,style2;
	
    if( attStr ) 
        CFRelease(attStr);
 	attStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	CFAttributedStringReplaceString (attStr, CFRangeMake(0, 0), (__bridge CFStringRef) string);
   	
    if(self.numberOfLines > 1 )
    {
		ctFont = CTFontCreateWithName((__bridge CFStringRef)_font, _fontSize, NULL);
		color = (_textColor).CGColor;
		CFAttributedStringSetAttribute(attStr, CFRangeMake(0, CFAttributedStringGetLength(attStr)), kCTFontAttributeName, ctFont);
		CFAttributedStringSetAttribute(attStr, CFRangeMake(0, CFAttributedStringGetLength(attStr)), kCTForegroundColorAttributeName, color);
        if( createLinkButtons )
        {
            [self addBtnStyleToString:attStr WithProperty:kCTForegroundColorAttributeName WithValue:(id)RGBCOLOR(0, 186, 239).CGColor WithRegExpression:@"@([A-Za-z0-9_]+)"];
            [self addHBtnStyleToString:attStr WithProperty:kCTForegroundColorAttributeName WithValue:(id)RGBCOLOR(0, 186, 239).CGColor WithRegExpression:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"];
        }
        LineBounds = [self CTRectForBounds:xrect limitedToNumberOfLines:self.numberOfLines - 1];        // frame all but the last line
        CGMutablePathRef tempPath = CGPathCreateMutable();
        CGPathAddRect(tempPath, NULL, LineBounds);
        framesetter = CTFramesetterCreateWithAttributedString(attStr);    
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), tempPath, NULL);
        
        CFRange visibleRange = CTFrameGetVisibleStringRange(frame);                                     // gets the number of characters in all but the last line
        style1 = CreateFullCTStyle(kCTLeftTextAlignment,kCTLineBreakByWordWrapping);                    // get the word wrap style
		style2 = CreateFullCTStyle(kCTLeftTextAlignment,kCTLineBreakByTruncatingTail);                  // trailing ... style
        int len = CFAttributedStringGetLength(attStr);                                                  // total characters of the string
        int vLen = visibleRange.length + 1;                                                             // 
		CFAttributedStringSetAttribute(attStr, CFRangeMake(0, visibleRange.length), kCTParagraphStyleAttributeName, style1); // sets all but the last line
        CFAttributedStringSetAttribute(attStr, CFRangeMake(vLen-1, len - vLen), kCTParagraphStyleAttributeName, style2);        // sets the last line
        
        CFRelease(style1);
        CFRelease(style2);
        CGPathRelease(tempPath);
    }
	else		// 1 line, check for
	{
		fraction = 1.0;
		if( adjustsFontSizeToFitWidth )
		{
			int			visLen;
			int			len = CFAttributedStringGetLength(attStr);
			
			visLen = [self NumberOfVisibleCharacters:xrect limitedToNumberOfLines:1];
            
			while ( visLen < len ) 
			{
				_fontSize = _fontSize - 1.0;
				if( _fontSize <= _minFontSize ) visLen = len;		// breaks out
				visLen = [self NumberOfVisibleCharacters:xrect limitedToNumberOfLines:1];
			}
			if (_fontSize <= _minFontSize)					// if we've reached the min font size, then set the trail attribute
			{
				style1 = CreateFullCTStyle(kCTLeftTextAlignment,kCTLineBreakByTruncatingTail); 
			}
			else
				style1 = CreateFullCTStyle(kCTLeftTextAlignment,kCTLineBreakByClipping); 
		}
		else							// fixed size
		{
			style1 = CreateFullCTStyle(kCTLeftTextAlignment,kCTLineBreakByTruncatingTail); 
		}
		ctFont = CTFontCreateWithName((__bridge CFStringRef)_font, _fontSize, NULL);
		color = (_textColor).CGColor;
		CFAttributedStringSetAttribute(attStr, CFRangeMake(0, CFAttributedStringGetLength(attStr)), kCTFontAttributeName, ctFont);
		CFAttributedStringSetAttribute(attStr, CFRangeMake(0, CFAttributedStringGetLength(attStr)), kCTForegroundColorAttributeName, color);
        if( createLinkButtons )
        {
            [self addBtnStyleToString:attStr WithProperty:kCTForegroundColorAttributeName WithValue:(id)RGBCOLOR(0, 186, 239).CGColor WithRegExpression:@"@([A-Za-z0-9_]+)"];
            [self addHBtnStyleToString:attStr WithProperty:kCTForegroundColorAttributeName WithValue:(id)RGBCOLOR(0, 186, 239).CGColor WithRegExpression:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"];
        }
        LineBounds = [self CTRectForBounds:xrect limitedToNumberOfLines:1];
        CGMutablePathRef tempPath = CGPathCreateMutable();
        CGPathAddRect(tempPath, NULL, LineBounds);
        framesetter = CTFramesetterCreateWithAttributedString(attStr);    
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), tempPath, NULL);
        CFRange visibleRange = CTFrameGetVisibleStringRange(frame);            
		CFAttributedStringSetAttribute(attStr, CFRangeMake(0, visibleRange.length), kCTParagraphStyleAttributeName, style1);
        CFRelease(style1);
        CGPathRelease(tempPath);
	}
    CFRelease(framesetter);
    CFRelease(ctFont);
	CFRelease(frame);
}

- (void)drawRect:(CGRect)xrect
{
	CGRect LineBounds;
    CTFrameRef frame;
    CTFramesetterRef framesetter;
    CGFloat width, fracWidth, height, x0, y0, lineHeight;
	
	CGContextRef X = UIGraphicsGetCurrentContext();	
    
	rangeArray = [[NSMutableArray alloc] init];
   	[self CreateAttributeStringWithStyle:self.text ForBounds:xrect];
    
    LineBounds = [self CTRectForBounds:xrect limitedToNumberOfLines:self.numberOfLines];
    if( self.VerticalAlignment == CTVerticalAlignmentCenter )
    {
        LineBounds.origin.y = 0.5*(xrect.size.height - LineBounds.size.height) + xrect.origin.y;
    }
    else if( self.VerticalAlignment == CTVerticalAlignmentBottom )
    {
        LineBounds.origin.y = xrect.origin.y;
    }
    else if( self.VerticalAlignment == CTVerticalAlignmentTop )
    {
        LineBounds.origin.y = xrect.origin.y + xrect.size.height - LineBounds.size.height;
    }

    framesetter = CTFramesetterCreateWithAttributedString(attStr);    
    
    lineHeight = [self lineHeight];
    width = LineBounds.size.width;
    height = LineBounds.size.height;
    fracWidth = fraction * width;
    x0 = LineBounds.origin.x;
    y0 = LineBounds.origin.y;
    yOffSet = y0;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x0, y0);
    CGPathAddLineToPoint(path, NULL, x0, y0 + height);
    CGPathAddLineToPoint(path, NULL, x0 + width, y0 + height);
    CGPathAddLineToPoint(path, NULL, x0 + width, y0 + lineHeight);
    CGPathAddLineToPoint(path, NULL, x0 + fracWidth, y0 + lineHeight);
    CGPathAddLineToPoint(path, NULL, x0 + fracWidth, y0);
    CGPathAddLineToPoint(path, NULL, x0, y0);
	
    CGContextTranslateCTM( X, 0, ([self bounds]).size.height);                     
    CGContextScaleCTM(X, 1.0, -1.0);
    
    frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
	if( createLinkButtons && [rangeArray count] > 0 )                   // If were creating linked buttons from the text, and we've founf a link,
	{
		[self buildButtons:frame];                                      // create the button
	}
    CTFrameDraw(frame, X);
	
	rangeArray = nil;
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(path);
}

#pragma mark Button Parsing Handlers

-(void)buildButtons:(CTFrameRef)textFrame
{
	if ([rangeArray count]) 
	{
		for (UIView *bt in [self subviews]) 
		{
			if ([bt class] == [CTLinkButton class]) 
			{
				[bt removeFromSuperview];
			}
		}
		
		CFArrayRef lines = CTFrameGetLines(textFrame);
		CFIndex i, total = CFArrayGetCount(lines);
		CGFloat y;
		NSUInteger k = 0;
		
		while (k<[rangeArray count]) 
		{
			for (i = 0; i < total; i++) 
			{
				CGPoint origins;
				CTFrameGetLineOrigins( textFrame, CFRangeMake(i, 1), &origins);
				CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, i);
				y = self.bounds.origin.y + self.bounds.size.height - origins.y;
				
				CFArrayRef runs = CTLineGetGlyphRuns(line);
				CFIndex r, runsTotal = CFArrayGetCount(runs);
				for (r = 0; r< runsTotal; r++) 
				{
					CGRect runBounds = CTRunGetImageBounds(CFArrayGetValueAtIndex(runs, r), UIGraphicsGetCurrentContext(), CFRangeMake(0, 0));
					
					if (CTRunGetStringRange(CFArrayGetValueAtIndex(runs, r)).location == [[rangeArray objectAtIndex:k] range].location) 
					{
						CGFloat x0,y0,width,height;
						x0 = round(runBounds.origin.x);
						y0 = round(y-runBounds.size.height-runBounds.origin.y);
						y0 = y0 - yOffSet;
						width = runBounds.size.width;
						height = runBounds.size.height;
						linkButton = [[CTLinkButton alloc] initWithFrame:CGRectMake(x0, y0, width, height) ];
						linkButton.link =[NSString stringWithString:[_text substringWithRange:[[rangeArray objectAtIndex:k] range]]];
						linkButton.title =[NSString stringWithString:[_text substringWithRange:NSMakeRange(CTRunGetStringRange(CFArrayGetValueAtIndex(runs, r)).location, CTRunGetStringRange(CFArrayGetValueAtIndex(runs, r)).length)]];						
						linkButton.title = [linkButton.title stringByReplacingOccurrencesOfString:@"@" withString:@""];
						
						[linkButton buildStringLayerWithFont:_font andSize:_fontSize usingDelegate:btnDelegate theSelector:callback];
						[self addSubview:linkButton];
						
						if (CTRunGetStringRange(CFArrayGetValueAtIndex(runs, r)).length != [[rangeArray objectAtIndex:k] range].length) 
						{
							CTFrameGetLineOrigins( textFrame, CFRangeMake(i+1, 1), &origins);
							y = self.bounds.origin.y + self.bounds.size.height - origins.y;
							if( i+1 < total )
							{
								runs = CTLineGetGlyphRuns((CTLineRef)CFArrayGetValueAtIndex(lines, i+1));
								runBounds = CTRunGetImageBounds(CFArrayGetValueAtIndex(runs, 0), UIGraphicsGetCurrentContext(), CFRangeMake(0, 0));
								
								x0 = round(runBounds.origin.x);
								y0 = round(y-runBounds.size.height-runBounds.origin.y);
								y0 = y0 - yOffSet;
								width = runBounds.size.width;
								height = runBounds.size.height;
								
								CTLinkButton *linkButton2 = [[CTLinkButton alloc] initWithFrame:CGRectMake(x0, y0, width, height) ];
								linkButton2.link = [NSString stringWithString:[_text substringWithRange:[[rangeArray objectAtIndex:k] range]]];
								linkButton2.title =[NSString stringWithString:[_text substringWithRange:NSMakeRange(CTRunGetStringRange(CFArrayGetValueAtIndex(runs, 0)).location, CTRunGetStringRange(CFArrayGetValueAtIndex(runs, 0)).length)]];
								linkButton2.title = [linkButton2.title stringByReplacingOccurrencesOfString:@"@" withString:@""];
								
								[linkButton2 buildStringLayerWithFont:_font andSize:_fontSize usingDelegate:btnDelegate theSelector:callback];
								[linkButton2 setLinkdButton:linkButton.label];
								[linkButton setLinkdButton:linkButton2.label];
								[self addSubview:linkButton2];
							}
						}
						r = runsTotal;
						i = total;
					}
				}
			}
			k++;
		}
	}
}
- (void)setLinkButtonCallBack:(id)theDelegate theSelector:(SEL)requestSelector
{
	self.btnDelegate = theDelegate;
	self.callback = requestSelector;    
}

-(void)addBtnStyleToString:(CFMutableAttributedStringRef)aStr WithProperty:(CFStringRef)property WithValue:(id)value WithRegExpression:(NSString*)regexpres
{
	NSString  *sp = @" ";
    NSMutableAttributedString *mStr = UKCFToNSMutableAttributedString(aStr);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexpres options:NSRegularExpressionCaseInsensitive error:nil];
	[regex enumerateMatchesInString:_text options:0 range:NSMakeRange(0, [_text length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
	 {
		 NSRange srange = [match range];
		 CFRange mrange = CFRangeMake(srange.location, srange.length);
         NSRange atRange;
         atRange.location = srange.location;
         atRange.length = 1;
         
         [mStr replaceCharactersInRange:atRange withString:sp];
		 CFAttributedStringSetAttribute(aStr, mrange, property, (__bridge CFTypeRef)(value));
		 [rangeArray addObject:match];
	 }];
}

-(void)addHBtnStyleToString:(CFMutableAttributedStringRef)aStr WithProperty:(CFStringRef)property WithValue:(id)value WithRegExpression:(NSString*)regexpres
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexpres options:NSRegularExpressionCaseInsensitive error:nil];
	[regex enumerateMatchesInString:_text options:0 range:NSMakeRange(0, [_text length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
	 {
		 NSRange srange = [match range];
		 CFRange mrange = CFRangeMake(srange.location, srange.length);
         
		 CFAttributedStringSetAttribute(aStr, mrange, property, (__bridge CFTypeRef)(value));
		 [rangeArray addObject:match];
	 }];
}
#pragma mark Event Handlers
- (void)setTextSize:(CGFloat)gSize                                                         // gSize should be pt size ie.e 12pt, etc..
{                                                                                   
    _fontSize = gSize;
    [self setNeedsDisplay];
}


@end
