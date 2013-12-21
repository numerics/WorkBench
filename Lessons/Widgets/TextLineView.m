//
//  TextLineView.m
//  WorkBench
//
//  Created by John Basile on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextLineView.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import <CoreText/CoreText.h>

#define FONT @"Helvetica"
#define TEXT @"Hello! my friends welcome to the show that never ends."


@implementation TextLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        fontPtSize = 12.0;
    }
    return self;
}

- (void)drawRect:(CGRect)xrect
{
	
    self.backgroundColor = [UIColor whiteColor];
	CGContextRef X = UIGraphicsGetCurrentContext();	
	
	//CGRect rect =  self.bounds;
    
	NSString* string = TEXT;
	
	CFMutableAttributedStringRef attStr;
    UIFont* font = [UIFont fontWithName:FONT size:fontPtSize];
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    CGColorRef color = [UIColor blackColor].CGColor;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (__bridge id) ctFont, kCTFontAttributeName,
                                (__bridge id) color, kCTForegroundColorAttributeName,
                                nil];
    assert(attributes != nil);
    
    NSAttributedString* ns_attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    attStr = (__bridge CFMutableAttributedStringRef) ns_attrString; 
	CTLineRef line = CTLineCreateWithAttributedString( attStr );
    CGFloat ascent, descent, leading, lineHeight;
    //CGFloat lineWidth;
    
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    lineHeight = ascent + descent + leading;  
    
    CGContextSetTextMatrix(X, CGAffineTransformIdentity);
 	CGContextTranslateCTM( X, 0, lineHeight);                     
 	//CGContextTranslateCTM( X, 0, ([self bounds]).size.height);                     
    CGContextScaleCTM(X, 1.0, -1.0);

    CGFloat x, y;
    
    x = 0.0;
    y = 0.0;
    CGContextSetTextPosition(X, x, y);
    CTLineDraw(line, X);
    
}

#pragma mark Event Handlers
- (void)setTextSize:(CGFloat)gSize                                                         // gSize should be pt size ie.e 12pt, etc..
{                                                                                   
    // fontPtSize = gSize;
    fontPtSize = gSize;
    [self setNeedsDisplay];
}


@end
