//
//  GHBackgroundView.m
//
//  Created by Steve Kochan on 6/15/13
//

#import "GHCustomContainerView.h"
#import "UIColor+EliteKit.h"



@implementation GHCustomContainerView
{
    BOOL isHighlighting;
    UIColor  *saveFillColor;
}

- (id)initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        self.fillColor = [UIColor clearColor];
        
        if (!self.borderColor)
            self.borderColor = [UIColor colorWithHexString:@"0x666666"];
        
        if (!self.startColor)
            self.startColor = [UIColor colorWithHexString:@"0x222222"];
        
        if (!self.endColor)
            self.endColor = [UIColor colorWithHexString:@"0x000000"];
        
        if (!self.shadowColor)
            self.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        self.shouldCreateGradient = YES;
        self.notchSize = 10;
        
        self.alpha = 1.0;
        self.lineWidth = 1.0;
        self.lineAlpha = 1.0;
    }
	
    return self;
}

- (id)initWithFrame: (CGRect) frame andAlpha:(CGFloat)alpha
{
    self = [self initWithFrame: frame];
    if (self)
    {
        self.alpha = alpha;
    }
	
    return self;
    
}

-(void)select
{
    saveFillColor = self.fillColor;
    self.fillColor = [UIColor colorWithHexString:@"0xdcbe0e"];
    isHighlighting = YES;
    
    [self setNeedsDisplay];
}

-(void)resetColor
{
    if (saveFillColor)
        self.fillColor = saveFillColor;
    
    isHighlighting = NO;
    
    [self setNeedsDisplay];
}

-(void)highlight
{
    self.fillColor = [UIColor colorWithHexString:@"0xdcbe0e"];
    isHighlighting = YES;
    
    [self setNeedsDisplay];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self resetColor];
    });
    
}

- (void) drawRect:(CGRect)rect
{
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y + rect.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat topLeftEdgeInset = 0.0, topRightEdgeInset = 0.0, bottomLeftEdgeInset = 0.0, bottomRightEdgeInset = 0.0;
    
    if (self.addTopLeftNotch)
        topLeftEdgeInset = self.notchSize;
    
    if (self.addTopRightNotch)
        topRightEdgeInset = self.notchSize;
    
    if (self.addBottomRightNotch)
        bottomRightEdgeInset = self.notchSize;
    
    if (self.addBottomLeftNotch)
        bottomLeftEdgeInset = self.notchSize;
    
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    //CGContextSetAlpha(context, self.alpha);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint   (path, NULL, left  + topLeftEdgeInset,top           );
    CGPathAddLineToPoint(path, NULL, right - topRightEdgeInset,top          );
    CGPathAddLineToPoint(path, NULL, right,  top + topRightEdgeInset        );
    CGPathAddLineToPoint(path, NULL, right,  bottom - bottomRightEdgeInset  );
    CGPathAddLineToPoint(path, NULL, right - bottomRightEdgeInset , bottom  );
    CGPathAddLineToPoint(path, NULL, left  + bottomLeftEdgeInset , bottom   );
    CGPathAddLineToPoint(path, NULL, left ,  bottom - bottomLeftEdgeInset   );
    CGPathAddLineToPoint(path, NULL, left,   top + topLeftEdgeInset         );
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(context);
    CGContextAddPath (context, path);
    
    if (! self.shouldCreateGradient  || isHighlighting)
	{
        CGContextFillPath(context);
    }
    else
	{
        CGContextClip(context);
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        NSArray *colors = [NSArray arrayWithObjects: (id)self.startColor.CGColor, (id)self.endColor.CGColor, nil];
        CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (__bridge CFArrayRef) colors, NULL);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
    }
    
    CGContextRestoreGState(context);
    
    CGContextAddPath (context, path);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if( self.addShadow && ! isHighlighting )
    {
        CGPoint pointA = CGPointMake(left  + bottomLeftEdgeInset , bottom);
        CGPoint pointB = CGPointMake(right - bottomLeftEdgeInset , bottom);
        CGMutablePathRef pathLine = CGPathCreateMutable();
        CGPathMoveToPoint(pathLine, NULL, pointA.x,pointA.y);
        CGPathAddLineToPoint(pathLine, NULL,  pointB.x,pointB.y);
        CGPathCloseSubpath(pathLine);
        
        CGContextAddPath (context, pathLine);
        
        CGContextSaveGState(context);
        //CGContextEOClip(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 6.0, self.shadowColor.CGColor);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }
    
    CGPathRelease (path);
}


@end



















