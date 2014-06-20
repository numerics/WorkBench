//
//  CKTextFieldView.M
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKTextFieldView.h"

@implementation CKTextFieldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        self.textField = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.textField.userInteractionEnabled = YES;
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.textColor =  [UIColor blackColor];
        self.textField.textAlignment = NSTextAlignmentLeft;
        [self.textField setReturnKeyType:UIReturnKeyDone];
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.clearButtonMode = UITextFieldViewModeAlways;
        [self addSubview:self.textField];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withAnglePadding:(UIColor *)fillColor
{
	self = [self initWithFrame:frame];
    if (self)
	{
        CGRect tFrame = self.textField.frame;
        tFrame = CGRectMake(tFrame.origin.x, tFrame.origin.y, tFrame.size.width-15.0, tFrame.size.height);
        self.textField.frame = tFrame;
		self.aPadView = [[PaddedAngledView alloc] initWithFrame:CGRectMake(0, 0, 15.0, frame.size.height) fillColor:fillColor];
        [self addSubview:self.aPadView];
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.aPadView.left = 0;
    self.aPadView.top = 0;
    self.textField.left = self.aPadView.right;
    self.textField.top = 0;
}
@end



/////////// Padded Angled View View

@implementation PaddedAngledView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setOpaque:NO];
		self.fillColor = [UIColor colorWithHexString:@"0xFFFFFF"];
		self.leftInset = 10.0;
		self.topInset  =  9.0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setOpaque:NO];
		self.fillColor = fillColor;
		self.leftInset = 10.0;
		self.topInset  =  9.0;
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y + rect.size.height;
    
    CGFloat startPt;
    CGFloat endPt;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    startPt = left + self.leftInset;
    endPt = top + self.topInset;
    
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetAlpha(context, 1.0);
    CGPathMoveToPoint(   path, NULL, startPt ,top);
    CGPathAddLineToPoint(path, NULL, right,   top);
    CGPathAddLineToPoint(path, NULL, right,   bottom);
    CGPathAddLineToPoint(path, NULL, left,    bottom);
    CGPathAddLineToPoint(path, NULL, left,    endPt);
    CGPathAddLineToPoint(path, NULL, startPt, top);
    
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(context);
    CGContextAddPath (context, path);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    CGPathRelease (path);
    
}
@end
