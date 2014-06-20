//
//  CKTextInputView.M
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKTextInputView.h"

@implementation CKTextInputView

@synthesize textfield,aPadView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.textfield = [[CKTextInputField alloc] initWithFrame:frame];
		self.aPadView = nil;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withAnglePadding:(UIColor *)fillColor
{
	self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		self.aPadView = [[AngledPaddedView alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, frame.size.height) fillColor:fillColor];
        [self addSubview:self.aPadView];
		
		CGRect tFrame = CGRectMake(15.0, 0.0, frame.size.width - 15, frame.size.height);
		self.textfield = [[CKTextInputField alloc] initWithFrame:tFrame];
		
        [self addSubview:self.textfield];
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
	if( self.aPadView)
	{
		self.aPadView.left = 0.0;
		self.aPadView.top = 0.0;
		
		self.textfield.left = self.aPadView.right;
		self.textfield.top = 0.0;
	}
}

@end

/////////// Angle View

@implementation AngledPaddedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setOpaque:YES];
		self.fillColor = [UIColor redColor];//[UIColor colorWithHexString:@"0xFFFFFF"];
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
		self.fillColor = [UIColor redColor];//fillColor;
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
    UIColor *fillColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    
    CGFloat topInset = 9.0;
    CGFloat leftInset = 10.0;
    startPt = left + leftInset;
    endPt = top + topInset;
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
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
