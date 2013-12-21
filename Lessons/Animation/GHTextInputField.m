//
//  GHTextInputField.m
//  WorkBench
//
//  Created by John Basile on 9/1/13.
//  Copyright (c) 2013 John Basile. All rights reserved.
//
//

#import "GHTextInputField.h"

@interface GHTextInputField ()
- (void)_initialize;
@end


@implementation GHTextInputField

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

CGRect CGRectSetX(CGRect rect, CGFloat x)
{
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectSetY(CGRect rect, CGFloat y)
{
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
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
    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
	
}

#pragma mark - Private

- (void)_initialize
{
	_textEdgeInsets = UIEdgeInsetsZero;
	_clearButtonEdgeInsets = UIEdgeInsetsZero;
}

@end
