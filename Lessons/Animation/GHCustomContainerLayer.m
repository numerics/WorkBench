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
        self.notchSize = 10;
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

-(CGMutablePathRef)createFrame:(CGRect)rect
{
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y + rect.size.height;
    
    CGFloat topLeftEdgeInset = 0.0, topRightEdgeInset = 0.0, bottomLeftEdgeInset = 0.0, bottomRightEdgeInset = 0.0;
    
    if (self.addTopLeftNotch)
        topLeftEdgeInset = self.notchSize;
    
    if (self.addTopRightNotch)
        topRightEdgeInset = self.notchSize;
    
    if (self.addBottomRightNotch)
        bottomRightEdgeInset = self.notchSize;
    
    if (self.addBottomLeftNotch)
        bottomLeftEdgeInset = self.notchSize;
    
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
    pathLayer.lineWidth = self.lineWidth;
    pathLayer.strokeColor = self.borderColor.CGColor;
    pathLayer.lineCap = kCALineCapRound;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.path = containerPath;
    
    maskLayer = [CAShapeLayer layer];
    maskLayer.lineWidth = 0;//self.lineWidth;
    maskLayer.path = containerPath;
    [shapeLayer addSublayer:maskLayer];
    
    if( self.shouldCreateGradient)
    {
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


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
