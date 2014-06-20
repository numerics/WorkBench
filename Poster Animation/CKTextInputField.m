//
//  CKTextInputField.M
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKTextInputField.h"

@interface CKTextInputField ()
- (void)_initialize;
@end


@implementation CKTextInputField

@synthesize textEdgeInsets = _textEdgeInsets;
@synthesize clearButtonEdgeInsets = _clearButtonEdgeInsets;
@synthesize placeholderTextColor = _placeholderTextColor;


- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
	_placeholderTextColor = placeholderTextColor;
	
	if (!self.text && self.placeholder)
	{
		[self setNeedsDisplay];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		[self _initialize];
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

		self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.textColor =  [UIColor blackColor];
        self.textAlignment = NSTextAlignmentLeft;
        [self setReturnKeyType:UIReturnKeyDone];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.clearButtonMode = UITextFieldViewModeAlways;
    }
    return self;
}

#pragma mark - UITextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
        return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], _textEdgeInsets);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return [self textRectForBounds:bounds];
}


- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
	CGRect rect = [super clearButtonRectForBounds:bounds];
	
	rect = CGRectSetY(rect, rect.origin.y + _clearButtonEdgeInsets.top);
	return CGRectSetX(rect, rect.origin.x + _clearButtonEdgeInsets.right);
}


- (void)drawPlaceholderInRect:(CGRect)rect
{
	if (!_placeholderTextColor)
	{
		[super drawPlaceholderInRect:rect];
		return;
	}
	
    [_placeholderTextColor setFill];
    if(isiOS7())
    {
        if( isiPhone() )
        {
            rect.origin.y = 10;
        }
        else
        {
            rect.origin.y = 14;
        }
    }
    else
    {
        if( isiPhone())
        {
            rect.origin.y = 2;
        }
    }
	
	NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    textStyle.alignment = self.textAlignment;
    UIFont *textFont = self.font;
	UIColor *txtColor = _placeholderTextColor;
	
	
    [self.placeholder drawInRect:rect withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:txtColor , NSParagraphStyleAttributeName:textStyle}];
	
 //   [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
	
}

#pragma mark - Private

- (void)_initialize
{
	_textEdgeInsets = UIEdgeInsetsZero;
	_clearButtonEdgeInsets = UIEdgeInsetsZero;
}

@end
