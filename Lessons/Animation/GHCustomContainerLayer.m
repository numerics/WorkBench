//
//  GHCustomContainerLayer
//  layers
//
//  Created by John Basile on 8/26/13.
//  Copyright 2013 Numerics. All rights reserved.
//


#import "GHCustomContainerLayer.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+EliteKit.h"

//static inline double radians (double degrees)
//{
//    return degrees * M_PI/180;
//}

void MyDrawColoredPattern (void *info, CGContextRef context)
{
    UIColor * dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0];
    UIColor * shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    
    CGContextSetFillColorWithColor(context, dotColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor.CGColor);
    
//    CGContextAddArc(context, 3, 3, 2, 0, radians(360), 0);
//    CGContextFillPath(context);
    
    CGContextAddRect(context, CGRectMake(3, 3, 1, 1));
//    CGContextAddArc(context, 16, 16, 2, 0, radians(360), 0);
    CGContextFillPath(context);
}

@implementation GHCustomContainerLayer
{
    BOOL isHighlighting;
    UIColor  *saveFillColor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.lineAlpha = 1.0;
        self.fillAlpha = 0.8;
        
        [self setColorApperance:kFillColor   WithHexString:@"0x222222" withAlpha:1.0];
        [self setColorApperance:kStartColor  WithHexString:@"0x222222" withAlpha:1.0];
        [self setColorApperance:kEndColor    WithHexString:@"0x000000" withAlpha:1.0];
        
        [self setColorApperance:kBorderColor WithHexString:@"0x666666" withAlpha:self.lineAlpha];
        
        if (!self.shadowColor)
            self.shadowColor = [UIColor blackColor];
        
        
        pathRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.notchSize = 6;
        self.shouldCreateGradient = NO;
        
        self.alpha = 1.0;
        self.lineWidth = 1.0;
        
        self.glowRadius = 10.0;
        self.glowAlpha = 0.8;
        
        self.shadowAlpha = 0.8;
        self.shadowRadius = 6.0;
        self.shadowOffset = CGSizeMake(0.0, 4.0);
		self.layer.shouldRasterize = YES;
        [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
		
		self.opaque = YES;
        
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
/*
- (void) setContainerApperance:(int)apperance
{
    
    self.fillAlpha = [GHStyleManager getOpacityForContainerType:apperance];
    self.borderColor = [UIColor colorWithHexString:[GHStyleManager getBorderColorForContainerType:apperance]];
    
    NSString *grad = [GHStyleManager getGradientForContainerType:apperance];
    if( [grad isEqualToString:@"YES"])
    {
        self.shouldCreateGradient = YES;
        self.startColor = [UIColor colorWithHexString:[GHStyleManager getStartColorForContainerType:apperance] withAlpha:self.fillAlpha];
        self.endColor = [UIColor colorWithHexString:[GHStyleManager getEndColorForContainerType:apperance] withAlpha:self.fillAlpha];
    }
    else
    {
        self.shouldCreateGradient = NO;
        self.fillColor = [UIColor colorWithHexString:[GHStyleManager getFillColorForContainerType:apperance] withAlpha:self.fillAlpha];
    }
    
    NSString *drop = [GHStyleManager getDropShadowForContainerType:apperance];
    if( [drop isEqualToString:@"YES"])
    {
        self.addShadow = YES;
        self.shadowAlpha = [GHStyleManager getShadowOpacityForContainerType:apperance];
        self.shadowRadius = [GHStyleManager getShadowRadiusForContainerType:apperance];
        CGFloat off = [GHStyleManager getShadowOffsetForContainerType:apperance];
        self.shadowOffset = CGSizeMake(0.0, off);
    }
	
}

*/
- (void) setColorApperance:(int)apperance WithHexString:(NSString *) stringToConvert withAlpha:(CGFloat)alpha
{
    if( apperance == kFillColor)
	{
        if(self.fillColor && stringToConvert == nil )
		{
			[UIColor colorWithRed:self.fillColor.red green:self.fillColor.green blue:self.fillColor.blue alpha:alpha];
		}
		else
			self.fillColor = [UIColor colorWithHexString:stringToConvert withAlpha:alpha];
	}
    else if (apperance == kBorderColor )
	{
        if(self.borderColor && stringToConvert == nil )
		{
			[UIColor colorWithRed:self.borderColor.red green:self.borderColor.green blue:self.borderColor.blue alpha:alpha];
		}
		else
			self.borderColor = [UIColor colorWithHexString:stringToConvert withAlpha:alpha];
	}
    else if (apperance == kStartColor )
	{
        if(self.startColor && stringToConvert == nil )
		{
			[UIColor colorWithRed:self.startColor.red green:self.startColor.green blue:self.startColor.blue alpha:alpha];
		}
		else
			self.startColor = [UIColor colorWithHexString:stringToConvert withAlpha:alpha];
	}
    else if (apperance == kEndColor )
	{
        if(self.endColor && stringToConvert == nil )
		{
			[UIColor colorWithRed:self.endColor.red green:self.endColor.green blue:self.endColor.blue alpha:alpha];
		}
		else
			self.endColor = [UIColor colorWithHexString:stringToConvert withAlpha:alpha];
	}
}

-(void)setAddShadow:(BOOL)addShadow
{
    if( addShadow )
    {
        self.addOuterGlow = NO;
    }
    _addShadow = addShadow;
}

-(void)setAddOuterGlow:(BOOL)addOuterGlow
{
    if( addOuterGlow )
    {
        self.addShadow = NO;
    }
    _addOuterGlow = addOuterGlow;
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

-(CAGradientLayer *)createGradientMask:(CGRect)frame
{
    CAGradientLayer *gr = [CAGradientLayer layer];
    gr.contentsScale = [UIScreen mainScreen].scale;
    
    gr.frame = frame;
    gr.startPoint = CGPointMake(0.5, 0.0);
    gr.endPoint   = CGPointMake(0.5, 1.0);
	
    //NSString *sColor = @"0x020202";
    NSString *sColor = @"0x000000";
	
    NSNumber *stop1 = [NSNumber numberWithFloat:0.00];
    NSNumber *stop2 = [NSNumber numberWithFloat:0.25];
    NSNumber *stop3 = [NSNumber numberWithFloat:0.44];
    NSNumber *stop4 = [NSNumber numberWithFloat:0.63];
    NSNumber *stop5 = [NSNumber numberWithFloat:1.00];
    
    UIColor *color1 = [UIColor colorWithHexString:sColor withAlpha:0.0];
    UIColor *color2 = [UIColor colorWithHexString:sColor withAlpha:0.0];
    UIColor *color3 = [UIColor colorWithHexString:sColor withAlpha:0.5];
    UIColor *color4 = [UIColor colorWithHexString:sColor withAlpha:1.0];
    UIColor *color5 = [UIColor colorWithHexString:sColor withAlpha:1.0];
	
    NSArray *locations = [NSArray arrayWithObjects:stop1, stop2, stop3, stop4, stop5,nil];
    gr.locations = locations;
    
    
    gr.colors = [NSArray arrayWithObjects:
                 (id)color1.CGColor,
                 (id)color2.CGColor,
                 (id)color3.CGColor,
                 (id)color4.CGColor,
                 (id)color5.CGColor,
                 nil];
    
    gr.opacity = 1.0;
    
//    CGRect shadowRect = CGRectMake(0, 0, frame.size.width, 4.0);
//    CGPathRef shadowPath = CGPathCreateWithRect(shadowRect, NULL);
//    CGSize sOffSet = CGSizeMake(0.0, frame.size.height + 2.0);
    
//    gr.shadowColor = [UIColor blackColor].CGColor;
//    gr.shadowOpacity = 0.8;
//    gr.shadowOffset = sOffSet;
//    gr.shadowRadius = 4.0;
//    gr.shadowPath = shadowPath;
//	
//	CGPathRelease(shadowPath);
    return gr;
}

-(CAGradientLayer *)createGradient
{
    CAGradientLayer *gr = [CAGradientLayer layer];
    gr.contentsScale = [UIScreen mainScreen].scale;
    
    gr.frame = self.bounds;
    gr.startPoint = CGPointMake(0.5, 0.0);
    gr.endPoint   = CGPointMake(0.5, 1.0);
    
    gr.colors = [NSArray arrayWithObjects:
                 (id)self.startColor.CGColor,
                 (id)self.endColor.CGColor,
                 nil];
    
    gr.needsDisplayOnBoundsChange = YES;
    
    return gr;
    
}

- (void) drawRect:(CGRect)rect
{
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y + rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    [[UIColor whiteColor] setStroke];
    
    UIBezierPath *bpath = [UIBezierPath bezierPath];
	bpath.lineWidth = 2.0;
    [bpath moveToPoint:CGPointMake(left, top + self.notchSize)];
    [bpath addLineToPoint:CGPointMake(left ,top)];
    [bpath addLineToPoint:CGPointMake(left + self.notchSize ,top)];
    
    [bpath stroke];
    
    [bpath moveToPoint:CGPointMake(right - self.notchSize, top)];
    [bpath addLineToPoint:CGPointMake(right ,top)];
    [bpath addLineToPoint:CGPointMake(right,top + self.notchSize)];
    [bpath stroke];
    
    [bpath moveToPoint:CGPointMake(right - self.notchSize, bottom)];
    [bpath addLineToPoint:CGPointMake(right, bottom)];
    [bpath addLineToPoint:CGPointMake(right, bottom - self.notchSize)];
    [bpath stroke];
    
    [bpath moveToPoint:CGPointMake(left + self.notchSize, bottom)];
    [bpath addLineToPoint:CGPointMake(left, bottom)];
    [bpath addLineToPoint:CGPointMake(left, bottom - self.notchSize)];
    [bpath stroke];
	bpath.lineWidth = 1.0;
    
	draw1PxStroke(context, CGPointMake(left+3, top+2), CGPointMake(right-3, top+2), [UIColor whiteColor].CGColor);
	drawLinearGradientFromTo(context, CGPointMake(left+20, top+2), CGPointMake(left+30, top+3), [UIColor whiteColor].CGColor,[UIColor lightGrayColor].CGColor);
	draw1PxStroke(context, CGPointMake(left+30, top+2), CGPointMake(left+40, top+2), [UIColor lightGrayColor].CGColor);
	drawLinearGradientFromTo(context, CGPointMake(left+40, top+2), CGPointMake(left+50, top+3), [UIColor lightGrayColor].CGColor,[UIColor whiteColor].CGColor);
    
    static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           CGRectInset(rect, 3.0, 3.0),
                                           CGAffineTransformIdentity,
                                           4,
                                           4,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    CGFloat alpha = .30;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, CGRectInset(rect, 4.0, 4.0));
    CGContextRestoreGState(context);
    
	UIColor *fgC = [UIColor colorWithHexString:@"0xd1f5ff"];
	CGContextSaveGState(context);

    UIColor * shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
	CGContextSetAlpha(context, 0.07);
    CGContextSetFillColorWithColor(context, fgC.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(-10, 14), 5, shadowColor.CGColor);
	CGContextAddArc(context, left+35, top+14, 10, 0, radians(360), 0);
	CGContextFillPath(context);
    CGContextSetShadowWithColor(context, CGSizeMake(5, -14), 5, shadowColor.CGColor);
	CGContextAddArc(context, left+40, top+28, 10, 0, radians(360), 0);
	CGContextFillPath(context);
	CGContextRestoreGState(context);

}

-(CGMutablePathRef)createFrame:(CGRect)rect
{
    CGFloat left = rect.origin.x;
//    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
//    CGFloat bottom = rect.origin.y + rect.size.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, left , top + self.notchSize);
    CGPathAddRect(path, NULL, CGRectInset(rect, 3.0, 3.0));
    
//    UIBezierPath *bpath = [UIBezierPath bezierPath];
//    [bpath moveToPoint:CGPointMake(left, top + self.notchSize)];
//    [bpath addLineToPoint:CGPointMake(left ,top)];
//    [bpath addLineToPoint:CGPointMake(left + self.notchSize ,top)];
//    [bpath stroke];
//    
//    [bpath moveToPoint:CGPointMake(right - self.notchSize, top)];
//    [bpath addLineToPoint:CGPointMake(right ,top)];
//    [bpath addLineToPoint:CGPointMake(right,top + self.notchSize)];
//    [bpath stroke];
//    
//    [bpath moveToPoint:CGPointMake(right - self.notchSize, bottom)];
//    [bpath addLineToPoint:CGPointMake(right, bottom)];
//    [bpath addLineToPoint:CGPointMake(right, bottom - self.notchSize)];
//    [bpath stroke];
//    
//    [bpath moveToPoint:CGPointMake(left + self.notchSize, bottom)];
//    [bpath addLineToPoint:CGPointMake(left, bottom)];
//    [bpath addLineToPoint:CGPointMake(left, bottom - self.notchSize)];
//    [bpath stroke];
    
    return path;
    
}


- (void) commit
{
    pathRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerPath = [self createFrame:pathRect];
    if(shapeLayer)
    {
        [shapeLayer removeFromSuperlayer];
    }
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.contentsScale = [UIScreen mainScreen].scale;
	shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinMiter;
    shapeLayer.opacity = self.fillAlpha;
    shapeLayer.lineWidth = 0;//self.lineWidth;
    shapeLayer.path = containerPath;
	[self.layer addSublayer:shapeLayer];
    
    if(pathLayer)
    {
        [pathLayer removeFromSuperlayer];
    }
    pathLayer = [CAShapeLayer layer];
	[self.layer addSublayer:pathLayer];
    pathLayer.contentsScale = [UIScreen mainScreen].scale;
    pathLayer.lineWidth = 0;//self.lineWidth;
    pathLayer.strokeColor = self.borderColor.CGColor;
    pathLayer.lineCap = kCALineCapRound;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.path = containerPath;
    
    
    if( self.shouldCreateGradient)
    {
		maskLayer = [CAShapeLayer layer];
		maskLayer.lineWidth = 0;
		maskLayer.path = containerPath;
		[shapeLayer addSublayer:maskLayer];
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        if( gradientLayer)
        {
            [gradientLayer removeFromSuperlayer];
        }
        
        gradientLayer = [self createGradient];
        [shapeLayer addSublayer:gradientLayer];
        [gradientLayer setMask:maskLayer];
        [gradientLayer setNeedsDisplay];
    }
    else
    {
		maskLayer = [CAShapeLayer layer];
		maskLayer.lineWidth = 0;
		
//		CGMutablePathRef path = CGPathCreateMutable();
//		CGPathMoveToPoint(path, NULL, 0.5*self.frame.size.width , 0);
//		CGPathAddLineToPoint(path, NULL, 0, self.frame.size.height);
//		CGPathAddLineToPoint(path, NULL, self.frame.size.width, self.frame.size.height);
//		CGPathCloseSubpath(path);
		maskLayer.path = containerPath;
		[shapeLayer addSublayer:maskLayer];
//        maskLayer.fillColor = [UIColor blackColor].CGColor;
//        if( gradientLayer)
//        {
//            [gradientLayer removeFromSuperlayer];
//        }
//        CGRect mframe = CGRectMake(1, -4, 10, 0.3*self.frame.size.height);
//        gradientLayer = [self createGradientMask:mframe];
//        [shapeLayer addSublayer:gradientLayer];
//        [gradientLayer setMask:maskLayer];
//        [gradientLayer setNeedsDisplay];
		
		maskLayer.fillColor = self.fillColor.CGColor;
        [shapeLayer setNeedsDisplay];
    }
    
    if( self.addShadow )
    {
		CGRect shadowRect = CGRectMake(0, 0, self.frame.size.width, self.shadowRadius);
		
        CGPathRef shadowPath = CGPathCreateWithRect(shadowRect, NULL);
		
		CGSize sOffSet = CGSizeMake(self.shadowOffset.width, self.frame.size.height + self.shadowOffset.height);
		
		shapeLayer.shadowColor = self.shadowColor.CGColor;
        shapeLayer.shadowOpacity = self.shadowAlpha;
        shapeLayer.shadowOffset = sOffSet;
        shapeLayer.shadowRadius = self.shadowRadius;
        shapeLayer.shadowPath = shadowPath;
        
        [shapeLayer setNeedsDisplay];
    }
	
    if( self.addOuterGlow )
    {
        shapeLayer.shadowColor = [UIColor blackColor].CGColor;
        shapeLayer.shadowOpacity = self.glowAlpha;
        shapeLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        shapeLayer.shadowRadius = self.glowRadius;
        shapeLayer.shadowPath = containerPath;
        [self.layer setNeedsDisplay];
    }
    CGPathRelease (containerPath);
    
}



@end
