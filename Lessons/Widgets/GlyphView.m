//
//  GlyphView.m
//  WorkBench
//
//  Created by John Basile on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlyphView.h"
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import <CoreText/CoreText.h>

#define FONT @"Helvetica"
#define TEXT @"Hello! my friends welcome to the show that never ends."

@implementation GlyphView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        fontPtSize = 12.0;
        kernPtSize = 0.0;
	}
    return self;
}


- (void)drawRect:(CGRect)p_rect
{
	self.backgroundColor = [UIColor blackColor];
	CGContextRef X = UIGraphicsGetCurrentContext();	
	
	CGRect rect =  self.bounds;
    
	CGAffineTransform T = [self transformToCartesian:rect];
	CGContextConcatCTM ( X, T );
	
	NSString* string = TEXT;
	
	CFMutableAttributedStringRef attStr;
	// get attributed-string from string
	{
		UIFont* font = [UIFont fontWithName:FONT size:fontPtSize];
		CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
		
		NSNumber* NS_0 = [NSNumber numberWithInteger:0];
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									(__bridge id) ctFont, kCTFontAttributeName,		// NSFontAttributeName
									(id) NS_0, kCTLigatureAttributeName,	// NSLigatureAttributeName
									nil];
		assert(attributes != nil);
		
		NSAttributedString* ns_attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
		
		attStr = (__bridge CFMutableAttributedStringRef) ns_attrString;
	}	
	
	CTLineRef line = CTLineCreateWithAttributedString( attStr ) ;
    CGFloat ascent,descent,leading, lineHeight, glyPosY;
    CGFloat glyPosX;
    
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    lineHeight = ascent + descent + leading;  
	CFArrayRef runArray = CTLineGetGlyphRuns(line);
    glyPosX = 0.0;
    glyPosY = 0.0;
    CGFloat xdelta = 0.0;
    int linNum = 1;
    NSInteger cnt = CFArrayGetCount(runArray);
	
	for (CFIndex runIndex = 0; runIndex < cnt; runIndex++)                              // for each RUN
	{
		CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);            // Get FONT for this run
		CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
		
        NSInteger gCnt = CTRunGetGlyphCount(run);
		for (CFIndex runGlyphIndex = 0; runGlyphIndex < gCnt; runGlyphIndex++)          // for each GLYPH in run 
		{
			
			CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);                     // get Glyph & Glyph-data, one at a time
			CGGlyph glyph;
			CGPoint position;
			CTRunGetGlyphs(run, thisGlyphRange, &glyph);
			CTRunGetPositions(run, thisGlyphRange, &position);                          // this is in 'normalized space units'
			// Render it
			{
				CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);               // font for this section/run of text
				//CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
				//CGContextSetTextMatrix(X, textMatrix);
                CGContextSetTextMatrix(X, CGAffineTransformIdentity);
 				
				CGContextSetFont(X, cgFont);
                CGFloat ptSize = CTFontGetSize(runFont);
				CGContextSetFontSize(X, ptSize);
				CGContextSetRGBFillColor(X, 1.0, 1.0, 1.0, 1.0);
                CGContextSetShouldSubpixelPositionFonts(X, YES);
                CGContextSetAllowsFontSmoothing(X, YES );
                CGRect glyphRect = CTRunGetImageBounds(run, X, thisGlyphRange);          // get the glyph bound to check the a letter does not exceed the view area
                CGFloat px, gx, dx;
                
                px = position.x;    
                gx = glyphRect.origin.x;
                dx = gx - px;                                                           // difference between glyph start and glyph boundary start
                
                //NSLog(@"GlyphRect: X:%f, Width:%f, Right:%f", glyphRect.origin.x, glyphRect.size.width, glyphRect.origin.x+ glyphRect.size.width);
                
                position.x = position.x + runGlyphIndex * kernPtSize;                   // handle Kerning
                CGFloat xpos = position.x + xdelta - dx + glyphRect.size.width;         // this encompasses the whole glyph position.. if any part exceeds the width
                if( xpos > 1.0 )                                                        // of the view, then sart a new line
                {
                    glyPosX = 0.0;                                                      // line starts at a padded position on the left, defaults to zero
                    glyPosY = glyPosY - (lineHeight + .1);                              // x, and y are lower left, but we start at top-left
                    linNum = linNum + 1;                                                // so, minus to go lower, etc...
                    xdelta = -position.x;                                               // shift the virtual line to the left by the amount of its final position on the real line
                    position.x = glyPosX;
                    position.y = glyPosY;
                }
                else
                {
                    if( linNum > 1 )                                                    // first line real = virtual, just use the calculated Positions
                    {
                        glyPosX = position.x + xdelta;                                  // now calculate the real line position
                        position.x = glyPosX;
                        position.y = glyPosY;
                    }
                }
                //NSLog(@"position: X = %f, Y = %f", position.x, position.y);

				CGContextShowGlyphsAtPositions(X, &glyph, &position, 1);
				CFRelease(cgFont);
			}
		}
	}
    
	CFRelease(line);	
}

- (CGAffineTransform)transformToCartesian:(CGRect)rect
{
	CGAffineTransform T;
    T = CGAffineTransformIdentity;
	T = CGAffineTransformTranslate( T, -rect.origin.x, -rect.origin.y);                     // shift to make the view starting point 0,0
	T = CGAffineTransformScale( T, rect.size.width, rect.size.height );                     // SCALE so that we normalize range from TL(0, 0) - BR(1, 1)
	T = CGAffineTransformTranslate( T, 0, 0.01+fontPtSize);                                 // shift by fontSize so the text is/starts its display within the bounds
	T = CGAffineTransformScale( T, 1, -1 );                                                 // flip y, so 1,1 is top right
	
    return T;
}


#pragma mark Event Handlers
- (void)setGlyphSize:(CGFloat)gSize                                                         // gSize should be pt size ie.e 12pt, etc..
{                                                                                   
   // fontPtSize = gSize;
    CGFloat dh = self.bounds.size.height;
    CGFloat frameScale = 72.0/ dh;
    fontPtSize = frameScale * (gSize/132.0);
    [self setNeedsDisplay];
}

- (void)setGlyphKern:(CGFloat)gKern
{
    kernPtSize = gKern;
    [self setNeedsDisplay];
}


@end
