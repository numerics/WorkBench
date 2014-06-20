//
//  MZLabel.m
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKLabel.h"

@implementation CKLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        [self setBackgroundColor:[UIColor clearColor]];
		self.numberOfLines = 0;
//		self.textAlignment = NSTextAlignmentLeft;
//		self.textColor = [UIColor blackColor];
//        [self setFont:[UIFont fontWithName:@"Avenir Light" size:14]];
		
		[self setLabelApperance:@"AR14FFL"];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title andSize:(int)fontSize andGray:(CGFloat)grayValue
{
    self = [super initWithFrame:frame];
    if (self)
	{
		UIFont *avenLight = [UIFont fontWithName:@"Avenir Light" size:fontSize];
		self.font = avenLight;
		self.backgroundColor = [UIColor clearColor];
		self.textColor = [UIColor colorWithRed:grayValue green:grayValue blue:grayValue alpha:1];
		self.textAlignment = NSTextAlignmentLeft;
		self.text = title;
    }
    return self;
}

- (void) setHighlighted: (BOOL) highlighted
{
    [super setHighlighted: highlighted];

}

- (void) setLabelApperance:(NSString *)apperance withShadow:(int)shadowType
{
    NSString *typeface;
	NSString *colorAlign;
	
	typeface = [apperance substringFrom:0 to:3];
	colorAlign = [apperance substringFrom:4 to:6];
    
	UIFont *fnt = [MZStyleManager getFontAndSizeForLabel:typeface];
	self.font = fnt;
	
    NSTextAlignment align = [MZStyleManager getTextAlignmentForLabel:colorAlign];
    self.textAlignment = align;
    
    UIColor *txtColor  = [MZStyleManager getTextColorForLabel:colorAlign];
    [self setTextColor:txtColor];
    
	self.backgroundColor = [UIColor clearColor];
    
    NSString *drop = [MZStyleManager getDropShadowForLabelType:shadowType];
	
    if( [drop isEqualToString:@"YES"])
    {
        NSString *shadowClr = [MZStyleManager getShadowColorForLabelType:shadowType];
        CGFloat txtShadowAlpha  = [MZStyleManager getShadowOpacityForLabelType:shadowType];
        CGFloat txtShadowOffX    = [MZStyleManager getShadowOffXsetForLabelType:shadowType];
        CGFloat txtShadowOffY    = [MZStyleManager getShadowOffYsetForLabelType:shadowType];
        
        self.shadowColor = [UIColor colorWithHexString:shadowClr withAlpha:txtShadowAlpha];
        self.shadowOffset = CGSizeMake(txtShadowOffY, txtShadowOffX);
    }
}

- (void) setLabelApperance:(NSString *)apperance
{
    NSString *typeface;
	NSString *colorAlign;

	typeface = [apperance substringFrom:0 to:4];
	colorAlign = [apperance substringFrom:4 to:7];
    
	UIFont *fnt = [MZStyleManager getFontAndSizeForLabel:typeface];
	self.font = fnt;

    NSTextAlignment align = [MZStyleManager getTextAlignmentForLabel:colorAlign];
    self.textAlignment = align;
    
    UIColor *txtColor  = [MZStyleManager getTextColorForLabel:colorAlign];
    [self setTextColor:txtColor];
    
	self.backgroundColor = [UIColor clearColor];
}

@end
