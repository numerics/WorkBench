//
//  CKNotchedContainerLayer.m
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CKNotchedContainerView.h"

@interface CKNotchedContainerView ()
{
}
@property (nonatomic, assign) BOOL created;

@end

@implementation CKNotchedContainerView
{
    BOOL isHighlighting;
    UIColor  *saveFillColor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit:frame];
    }
    return self;
}

- (id)initWithFrame: (CGRect) frame andAlpha:(CGFloat)alpha
{
    self = [self initWithFrame: frame];
    if (self)
    {
        self.fillAlpha = alpha;
    }
	
    return self;
    
}

-(void)defaultInit:(CGRect)frame
{
    self.created = NO;
    self.backgroundColor = [UIColor clearColor];
    self.lineAlpha = 1.0;
    self.fillAlpha = 0.9;
    
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
    self.shadowOffset = CGSizeMake(0.0, 2.0);
    self.layer.shouldRasterize = YES;
    [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
}
/*
- (void) setContainerApperance:(int)apperance
{
    
    self.fillAlpha = [MZStyleManager getOpacityForContainerType:apperance];
    self.borderColor = [UIColor colorWithHexString:[MZStyleManager getBorderColorForContainerType:apperance]];
    
    NSString *grad = [MZStyleManager getGradientForContainerType:apperance];
    if( [grad isEqualToString:@"YES"])
    {
        self.shouldCreateGradient = YES;
        self.startColor = [UIColor colorWithHexString:[MZStyleManager getStartColorForContainerType:apperance] withAlpha:self.fillAlpha];
        self.endColor = [UIColor colorWithHexString:[MZStyleManager getEndColorForContainerType:apperance] withAlpha:self.fillAlpha];
    }
    else
    {
        self.shouldCreateGradient = NO;
        self.fillColor = [UIColor colorWithHexString:[MZStyleManager getFillColorForContainerType:apperance] withAlpha:self.fillAlpha];
    }
    
    NSString *drop = [MZStyleManager getDropShadowForContainerType:apperance];
    if( [drop isEqualToString:@"YES"])
    {
        self.addShadow = YES;
        self.shadowAlpha = [MZStyleManager getShadowOpacityForContainerType:apperance];
        self.shadowRadius = [MZStyleManager getShadowRadiusForContainerType:apperance];
        CGFloat off = [MZStyleManager getShadowOffsetForContainerType:apperance];
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
    
    gr.opacity = self.fillAlpha;
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

- (void)drawBox
{
    pathRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerPath = [self createFrame:pathRect];
    if(!shapeLayer)
    {
        shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:shapeLayer];
    }
    shapeLayer.contentsScale = [UIScreen mainScreen].scale;
	shapeLayer.fillColor = self.fillColor.CGColor;//[UIColor clearColor].CGColor;
	//shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinMiter;
    shapeLayer.opacity = self.fillAlpha;
    shapeLayer.lineWidth = 0;//self.lineWidth;
    shapeLayer.path = containerPath;
    
    if(!pathLayer)
    {
        pathLayer = [CAShapeLayer layer];
        [self.layer addSublayer:pathLayer];
    }
    pathLayer.contentsScale = [UIScreen mainScreen].scale;
    pathLayer.lineWidth = self.lineWidth;
    pathLayer.strokeColor = self.borderColor.CGColor;
    pathLayer.lineCap = kCALineCapRound;
    pathLayer.lineJoin = kCALineJoinMiter;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.path = containerPath;
    
    if(!maskLayer)
    {
        maskLayer = [CAShapeLayer layer];
        [shapeLayer addSublayer:pathLayer];
    }
	maskLayer.contentsScale = [UIScreen mainScreen].scale;
    maskLayer.lineWidth = 0;//self.lineWidth;
    maskLayer.path = containerPath;
}

- (void)drawBackgroundLayer
{
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    if( !gradientLayer)
    {
        gradientLayer = [self createGradient];
        [shapeLayer addSublayer:gradientLayer];
        [gradientLayer setMask:maskLayer];
    }
}

-(void)doShadow
{
    CGPathRef shadowPath;
    CGSize sOffSet;
    
    // if (self.addBottomRightNotch || self.addBottomLeftNotch )
    if (self.addBottomRightNotch || self.addBottomLeftNotch ||self.addTopRightNotch || self.addTopLeftNotch)
    {
        shadowPath = [self createFrame:CGRectMake(0, 0, self.frame.size.width, self.notchSize + self.shadowRadius)];
        sOffSet = CGSizeMake(self.shadowOffset.width, self.frame.size.height + self.shadowOffset.height - self.notchSize);
    }
    else
    {
        CGRect shadowRect = CGRectMake(0, 0, self.frame.size.width, self.shadowRadius);
        shadowPath = CGPathCreateWithRect(shadowRect, NULL);
        sOffSet = CGSizeMake(self.shadowOffset.width, self.frame.size.height + self.shadowOffset.height);
    }
    
	
	shapeLayer.shadowColor = self.shadowColor.CGColor;
	shapeLayer.shadowOpacity = self.shadowAlpha;
	shapeLayer.shadowOffset = sOffSet;
	shapeLayer.shadowRadius = self.shadowRadius;
	shapeLayer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
}


-(BOOL)createAllLayers
{
    [self drawBox];
    if( self.shouldCreateGradient)
    {
        [self drawBackgroundLayer];
    }
    else
    {
        maskLayer.fillColor = self.fillColor.CGColor;
    }
    
    if( self.addShadow )
    {
		[self doShadow];
    }
	
    if( self.addOuterGlow )
    {
        shapeLayer.shadowColor = [UIColor blackColor].CGColor;
        shapeLayer.shadowOpacity = self.glowAlpha;
        shapeLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        shapeLayer.shadowRadius = self.glowRadius;
        shapeLayer.shadowPath = containerPath;
    }
    CGPathRelease (containerPath);
    return YES;
}

- (void) commit
{
	if( !self.created)
        self.created = [self createAllLayers];
    
    [self.layer setNeedsDisplay];
}

- (void) update
{
    [self createAllLayers];
}

@end
