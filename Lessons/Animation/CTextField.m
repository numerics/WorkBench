//
//  CTextField.m
//  WorkBench
//
//  Created by Basile, John on 8/6/13.
//
//

#import "CTextField.h"

@implementation CTextField
@synthesize theTextF;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.theTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, frame.size.width - 10, frame.size.height - 10)];
        self.theTextF.borderStyle = UITextBorderStyleNone;
        [self addSubview:self.theTextF];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat left = rect.origin.x;
    CGFloat right = left + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = top + rect.size.height;

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    CGSize bgCopy3DropShadowOffset = CGSizeMake(0.1, 2.1);
    CGFloat bgCopy3DropShadowBlurRadius = 6;
    UIColor* bgCopy3DropShadowColor = [UIColor colorWithRed: 0 green: 0.001 blue: 0.001 alpha: 0.8];
    UIColor* bgCopy3DropShadow = bgCopy3DropShadowColor;

    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:    CGPointMake(left, bottom)];
    [path addLineToPoint: CGPointMake(left, top + 10.0)];
    [path addLineToPoint: CGPointMake(left + 10.0, top)];
    [path addLineToPoint: CGPointMake(right, top)];
    [path addLineToPoint: CGPointMake(right, bottom)];
    [path addLineToPoint: CGPointMake(left, bottom)];
    [path closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, bgCopy3DropShadowOffset, bgCopy3DropShadowBlurRadius, bgCopy3DropShadow.CGColor);
    [fillColor setFill];
    [path fill];
    //[path stroke];
    CGContextRestoreGState(context);
}

@end
