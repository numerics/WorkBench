//
//  CTLabel.h
//  WorkBench
//
//  Created by John Basile on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "CTLinkButton.h"

typedef enum 
{
    CTVerticalAlignmentCenter = 0,          // The default
    CTVerticalAlignmentTop,
    CTVerticalAlignmentBottom,                  
} CTVerticalAlignment;


@interface CTLabel : UIView
{
    CGSize          _size;
    NSString        *_text;
    UIColor         *_textColor;
    NSString        *_font;
    CGFloat         _minFontSize;                // default is 6.0
    CGFloat         _fontSize;					// the actual fontSize, default is 16.0
	CGFloat			_originalFontSize;			// storage for adjustable font sizes
    NSInteger       _numberOfLines;
    
    CGFloat			fraction;					// fraction (from 0.0 to 1.0), of the last line to be displayed

	CTLinkButton	*linkButton;
	SEL				callback;
	id				btnDelegate;
	NSMutableArray	*rangeArray;
	CTFrameRef		tFrame;
	CGFloat			yOffSet;

	CFMutableAttributedStringRef attStr;       // the 'formed' attributed string
}
@property (nonatomic, strong) id			btnDelegate;
@property (nonatomic) SEL					callback;

@property(nonatomic,copy)   NSString       *text;            // default is nil
@property(nonatomic,strong) NSString       *font;            // default is nil 
@property(nonatomic,strong) UIColor        *textColor;       // default is nil 

@property(nonatomic)        UITextAlignment textAlignment;   // default is UITextAlignmentLeft
@property(nonatomic)        UILineBreakMode lineBreakMode;   // default is NSLineBreakByTruncatingTail. used for single and multiple lines of text

@property(nonatomic) BOOL createLinkButtons;                 // default is NO
@property(nonatomic) BOOL adjustsFontSizeToFitWidth;         // default is NO
@property(nonatomic) NSInteger numberOfLines;
@property(nonatomic) CTVerticalAlignment VerticalAlignment;  // default is CTVerticalAlignmentCenter


- (void)CTLabelFont:(NSString *)font CTFontSize:(CGFloat)fSize;
- (void)CTLabelFont:(NSString *)font CTFontSize:(CGFloat)fSize CTTextColor:(UIColor *)txtColor;
- (void)CTTextColor:(UIColor *)txtColor;
- (void)CTFontSize:(CGFloat)fSize;
- (void)CTLabelFont:(NSString *)font;
- (void)CTLabelText:(NSString *)txt;

- (void)ElipseAtFrac:(CGFloat)frac;

- (CGRect)CTRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;
- (CGFloat)lineHeight;
- (void)buildButtons:(CTFrameRef)textFrame;
- (void)addBtnStyleToString:(CFMutableAttributedStringRef)aStr WithProperty:(CFStringRef)property WithValue:(id)value WithRegExpression:(NSString*)regexpres;
- (void)addHBtnStyleToString:(CFMutableAttributedStringRef)aStr WithProperty:(CFStringRef)property WithValue:(id)value WithRegExpression:(NSString*)regexpres;
- (void)setLinkButtonCallBack:(id)theDelegate theSelector:(SEL)requestSelector;


- (void)setTextSize:(CGFloat)gSize;                                                         // gSize should be pt size ie.e 12pt, etc..

@end
