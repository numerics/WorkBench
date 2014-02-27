//
//  GHCustomButtonLayer.m
//  GhostKit
//
//  Created by Basile, John on 8/28/13.
//  Copyright (c) 2013 Sota, Karan. All rights reserved.
//

#import "GHCustomButtonLayer.h"

@interface GHCustomButtonLayer ()
{
    BOOL    isHighlighting;  // for drawRect
}
@property (strong, nonatomic) UILabel *selectedTitle;
@property (strong, nonatomic) UILabel *selectedSubTitle;

@end


@implementation GHCustomButtonLayer

#pragma mark - init methods

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.frame = frame;
		[self defaultInit:frame];
	}
	return self;
}

-(void)defaultInit:(CGRect)frame
{
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	self.contentMode = UIViewContentModeRedraw;
	self.lineAlpha = 1.0;
	self.fillAlpha = 0.6;
	
	self.offSetLabel_X = 10.0;
	self.offSetLabel_Y = 4.0;
	
	self.offSetIcon_X = 0.0;
	self.offSetIcon_Y = .0;
	self.alignIcon = kIconRight;
	
	[self setColorApperance:kFillColor   WithHexString:@"0x222222" withAlpha:0.6];
	[self setColorApperance:kStartColor  WithHexString:@"0x222222" withAlpha:0.6];
	[self setColorApperance:kEndColor    WithHexString:@"0x000000" withAlpha:0.6];
	
	[self setColorApperance:kBorderColor WithHexString:@"0x666666" withAlpha:self.lineAlpha];
	
	if (!self.shadowColor)
		self.shadowColor = [UIColor blackColor];
	
	
	pathRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
	self.notchSize = 10;
	
	self.alpha = 1.0;
	
	self.glowRadius = 10.0;
	self.glowAlpha = 0.8;
	
	self.shadowAlpha = 0.8;
	self.shadowRadius = 6.0;
	self.shadowOffset = CGSizeMake(0.0, 1.0);
	
	self.shouldCreateGradient = YES;
	
	
	isHighlighting = NO;
	self.lineWidth = 1.0;
	

}

- (id)initWithFrame:(CGRect)frame attrTitle:(NSMutableAttributedString *)aTitle
{
    self = [self initWithFrame:frame];
	self.lineWidth = 1.0;
	
    self.titleLabel.attributedText = aTitle;
    [self.titleLabel setNumberOfLines:0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
	
    [self bringSubviewToFront:self.titleLabel];
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title andSubTitle:(NSString *)subTitle
{
	self = [self initWithFrame:frame andTitle:title];
	
	self.subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10, 16)];
	[self addSubview:self.subTitle];
	self.subTitle.hidden = NO;

	self.selectedSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10, 16)];
	[self addSubview:self.selectedSubTitle];
	self.selectedSubTitle.hidden = YES;
	
    UIFont *euroBold = [UIFont fontWithName:@"EurostileBold" size:14];
	
	self.subTitle.text = subTitle;
	self.subTitle.textColor = [UIColor colorWithHexString:@"0xaaaaaa"] ;
    self.subTitle.numberOfLines = 1;
    self.subTitle.font = euroBold;
    self.subTitle.textAlignment = NSTextAlignmentCenter;
    self.subTitle.backgroundColor = [UIColor clearColor];
    self.subTitle.lineBreakMode = NSLineBreakByTruncatingTail;
	[self bringSubviewToFront:self.subTitle];
	
	self.selectedSubTitle.text = subTitle;
	self.selectedSubTitle.textColor = [UIColor blackColor];
    self.selectedSubTitle.numberOfLines = 1;
    self.selectedSubTitle.font = euroBold;
    self.selectedSubTitle.textAlignment = NSTextAlignmentCenter;
    self.selectedSubTitle.backgroundColor = [UIColor clearColor];
    self.selectedSubTitle.lineBreakMode = NSLineBreakByTruncatingTail;
	
	// refactor the title label size to fit
	///TODO This these more work
	
	self.titleLabel.height = 18;
	self.selectedTitle.height = 18;
	
    return self;
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    self = [self initWithFrame:frame];
	
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10, 20)];
	[self addSubview:self.titleLabel];
	self.titleLabel.hidden = NO;

	self.selectedTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10, 20)];
	[self addSubview:self.selectedTitle];
	self.selectedTitle.hidden = YES;
	
    UIFont *euroBold = [UIFont fontWithName:@"EurostileBold" size:16];
	self.titleLabel.text = title;
	self.titleLabel.textColor = [UIColor colorWithHexString:@"0xaaaaaa"] ;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = euroBold;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	[self bringSubviewToFront:self.titleLabel];
	
	self.selectedTitle.text = self.titleLabel.text;
	self.selectedTitle.textColor = [UIColor blackColor];
    self.selectedTitle.numberOfLines = 1;
    self.selectedTitle.font = euroBold;
    self.selectedTitle.textAlignment = NSTextAlignmentCenter;
    self.selectedTitle.backgroundColor = [UIColor clearColor];
    self.selectedTitle.lineBreakMode = NSLineBreakByTruncatingTail;
	
    return self;
}

-(void)addImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon
{
	if( icon )
	{
		self.normalIcon = [[UIImageView alloc] initWithFrame:frame];
		self.normalIcon.image =icon;
		[self addSubview:self.normalIcon];
		self.normalIcon.hidden = NO;
	}
	else
		self.normalIcon = nil;
		
	if( selectedIcon )
	{
		self.selectedIcon = [[UIImageView alloc] initWithFrame:frame];
		self.selectedIcon.image = selectedIcon;
		[self addSubview:self.selectedIcon];
		self.selectedIcon.hidden = YES;
	}
	else
		self.selectedIcon = nil;
	
	self.alignIcon = kIconRight;
}

-(void)addImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon align:(int)align
{
	[self addImage:frame icon:icon selectedIcon:selectedIcon];
	self.alignIcon = align;
}

/*
- (void) setButtonApperance:(int)apperance
{
    UIColor *aa = getTextColorForButton(apperance);
    [self setTitleColor:aa forState: UIControlStateNormal];
    NSString *face = getFontTypeForButton(apperance) ;
    UIFont *euroBold = [UIFont fontWithName:face size:getTextSizeForButton(apperance)];
    self.titleLabel.font = euroBold;

    //self.borderColor = getBackgroundColorForButton(apperance);
    self.borderColor = getBorderColorForButton(apperance);
    
    NSTextAlignment align = getTextAlignmentForButton(apperance);
    if ( align == NSTextAlignmentLeft)
        self.alignLabel = kLabelLeft;
    if ( align == NSTextAlignmentRight)
        self.alignLabel = kLabelRight;
    
    NSString *grad = [GHStyleManager getGradientForButtonType:apperance];
    if( [grad isEqualToString:@"YES"])
    {
        self.shouldCreateGradient = YES;
        self.fillAlpha = [GHStyleManager getOpacityForButtonType:apperance];
        self.startColor = [UIColor colorWithHexString:[GHStyleManager getStartColorForButtonType:apperance] withAlpha:self.fillAlpha];
        self.endColor = [UIColor colorWithHexString:[GHStyleManager getEndColorForButtonType:apperance] withAlpha:self.fillAlpha];
    }
    else
        self.shouldCreateGradient = NO;
    
    NSString *drop = [GHStyleManager getDropShadowForButtonType:apperance];
    if( [drop isEqualToString:@"YES"])
    {
        self.addShadow = YES;
        self.shadowAlpha = [GHStyleManager getShadowOpacityForButtonType:apperance];
        self.shadowRadius = [GHStyleManager getShadowRadiusForButtonType:apperance];
        CGFloat off = [GHStyleManager getShadowOffsetForButtonType:apperance];
        self.shadowOffset = CGSizeMake(0.0, off);
    }
    
}
*/
- (void) setColorApperance:(int)apperance WithHexString:(NSString *) stringToConvert withAlpha:(CGFloat)alpha
{
    if( apperance == kFillColor)
        self.fillColor = [UIColor colorWithHexString:stringToConvert withAlpha:alpha];
    else if (apperance == kBorderColor )
        self.borderColor = [UIColor colorWithHexString:stringToConvert withAlpha:alpha];
    else if (apperance == kStartColor )
        self.startColor = [UIColor colorWithHexString:stringToConvert withAlpha:alpha];
    else if (apperance == kEndColor )
        self.endColor = [UIColor colorWithHexString:stringToConvert withAlpha:alpha];
}

-(void)setAlignLabel:(LabeAlignment)alignLabel
{
    _alignLabel = alignLabel;
    if( alignLabel == kLabelLeft)
    {
		self.titleLabel.textAlignment = NSTextAlignmentLeft;
		self.selectedTitle.textAlignment = NSTextAlignmentLeft;
		self.subTitle.textAlignment = NSTextAlignmentLeft;
		self.selectedSubTitle.textAlignment = NSTextAlignmentLeft;
    }
    else if( alignLabel == kLabelRight)
    {
		self.titleLabel.textAlignment = NSTextAlignmentRight;
		self.selectedTitle.textAlignment = NSTextAlignmentRight;
		self.subTitle.textAlignment = NSTextAlignmentRight;
		self.selectedSubTitle.textAlignment = NSTextAlignmentRight;
    }
    else
	{
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		self.selectedTitle.textAlignment = NSTextAlignmentCenter;
		self.subTitle.textAlignment = NSTextAlignmentCenter;
		self.selectedSubTitle.textAlignment = NSTextAlignmentCenter;
	}
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if( self.alignLabel == kLabelLeft)
	{
        self.titleLabel.left = self.offSetLabel_X;
	}
    else if( self.alignLabel == kLabelRight)
	{
        self.titleLabel.right = self.frame.size.width - self.offSetLabel_X;
	}
	else
	{
		self.titleLabel.horizontalCenter = self.frame.size.width / 2;
	}
	
	if( !self.subTitle)
	{
		self.titleLabel.verticalCenter = self.height/2;
		self.selectedTitle.top =self.titleLabel.top;
		self.selectedTitle.left =self.titleLabel.left;
	}
	else
	{
		self.titleLabel.top	= self.offSetLabel_Y;
		self.subTitle.top = self.titleLabel.bottom;
		self.subTitle.left = self.titleLabel.left;
		
	}
	self.selectedTitle.top =self.titleLabel.top;
	self.selectedTitle.left =self.titleLabel.left;
	self.selectedSubTitle.top =self.subTitle.top;
	self.selectedSubTitle.left =self.subTitle.left;
	
	if( self.normalIcon)
	{
		self.normalIcon.verticalCenter = self.frame.size.height / 2;
		
		if( self.alignIcon == kIconLeft)
		{
			self.normalIcon.left = 10 + self.offSetIcon_X;
		}
		else if (self.alignIcon == kIconRight )
		{
			self.normalIcon.right = self.frame.size.width - 10 - self.offSetIcon_X;
		}
		else
		{
			self.normalIcon.horizontalCenter = self.frame.size.width / 2;
			self.normalIcon.left += self.offSetIcon_X;
			self.normalIcon.top += self.offSetIcon_Y;
		}
		self.selectedIcon.top = self.normalIcon.top;
		self.selectedIcon.left = self.normalIcon.left;
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

-(void)btnSelected
{
    [shapeLayer addSublayer:highlightBackgroundLayer];
    [shapeLayer setNeedsDisplay];
}

-(void)resetBtnColor
{
    self.fillColor = [UIColor clearColor];
    isHighlighting = NO;
    
    [self commit];
    //[self setNeedsDisplay];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
    [shapeLayer removeFromSuperlayer];
    [self.layer addSublayer:highlightBackgroundLayer];
    [self bringSubviewToFront:self.selectedTitle];
	self.selectedTitle.hidden = NO;
	self.titleLabel.hidden = YES;
	if( self.subTitle)
	{
		[self bringSubviewToFront:self.selectedSubTitle];
		self.selectedSubTitle.hidden = NO;
		self.subTitle.hidden = YES;
	}
	if( self.normalIcon && self.selectedIcon)
	{
		self.normalIcon.hidden = YES;
		self.selectedIcon.hidden = NO;
		[self bringSubviewToFront:self.selectedIcon];
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
    [highlightBackgroundLayer removeFromSuperlayer];
    [self.layer addSublayer:shapeLayer];
	[self bringSubviewToFront:self.titleLabel];
	self.selectedTitle.hidden = YES;
	self.titleLabel.hidden = NO;
	if( self.subTitle)
	{
		[self bringSubviewToFront:self.selectedSubTitle];
		self.selectedSubTitle.hidden = YES;
		self.subTitle.hidden = NO;
	}
	if( self.normalIcon && self.selectedIcon)
	{
		self.normalIcon.hidden = NO;
		self.selectedIcon.hidden = YES;
		[self bringSubviewToFront:self.normalIcon];
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [highlightBackgroundLayer removeFromSuperlayer];
    [self.layer addSublayer:shapeLayer];
	[self bringSubviewToFront:self.titleLabel];
	self.selectedTitle.hidden = YES;
	self.titleLabel.hidden = NO;
	if( self.subTitle)
	{
		[self bringSubviewToFront:self.selectedSubTitle];
		self.selectedSubTitle.hidden = YES;
		self.subTitle.hidden = NO;
	}
	if( self.normalIcon && self.selectedIcon)
	{
		self.normalIcon.hidden = NO;
		self.selectedIcon.hidden = YES;
		[self bringSubviewToFront:self.normalIcon];
	}
}

-(void)btnHighlighted
{
    self.fillColor = [UIColor colorWithHexString:@"0xdcbe0e"];
    self.alpha = 1.0;
    isHighlighting = YES;
    
    [self commit];//[self setNeedsDisplay];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self resetBtnColor];
    });
    
}

-(CAGradientLayer *)createBackGroundGradient
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
    gr.shouldRasterize = YES;
    return gr;
    
}

-(CAGradientLayer *)createhightlightGradient
{
    CAGradientLayer *hl = [CAGradientLayer layer];
    hl.contentsScale = [UIScreen mainScreen].scale;
    
    hl.frame = self.bounds;
    hl.startPoint = CGPointMake(0.5, 0.0);
    hl.endPoint   = CGPointMake(0.5, 1.0);
    UIColor *hlS = [UIColor colorWithHexString:@"0xdcbe0e"];
    UIColor *hlE = [UIColor colorWithHexString:@"0xdcbe0e"];
    
    hl.colors = [NSArray arrayWithObjects:
                 (id)hlE.CGColor,
                 (id)hlS.CGColor,
                 nil];
    
    hl.needsDisplayOnBoundsChange = YES;
    
    return hl;
    
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

#pragma mark - Layer setters

- (void)drawButton
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
    
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
	
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions([layer frame].size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext([layer frame].size);
	
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return outputImage;
}

- (void)drawBackgroundLayer
{
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    if( backgroundLayer)
    {
        [backgroundLayer removeFromSuperlayer];
    }
    
    backgroundLayer = [self createBackGroundGradient];
    [shapeLayer addSublayer:backgroundLayer];
    [backgroundLayer setMask:maskLayer];
    [backgroundLayer setNeedsDisplay];
	
//	UIImage *bk = [self imageFromLayer:backgroundLayer];
//	[shapeLayer setContents:bk];
	
}

- (void)drawHighlightBackgroundLayer
{
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    if( highlightBackgroundLayer)
    {
        [highlightBackgroundLayer removeFromSuperlayer];
    }
    
    highlightBackgroundLayer = [CAShapeLayer layer];//[self createhightlightGradient];
    UIColor *hlS = [UIColor colorWithHexString:@"0xdcbe0e"];
    highlightBackgroundLayer.fillColor = hlS.CGColor;
    highlightBackgroundLayer.contentsScale = [UIScreen mainScreen].scale;
    highlightBackgroundLayer.lineJoin = kCALineJoinMiter;
    highlightBackgroundLayer.opacity = 1.0;
    highlightBackgroundLayer.lineWidth = 0;//self.lineWidth;
    highlightBackgroundLayer.path = containerPath;
}


- (void) commit
{
    [self drawButton];
    if( self.shouldCreateGradient)
    {
        [self drawBackgroundLayer];
        [self drawHighlightBackgroundLayer];
        //highlightBackgroundLayer.hidden = YES;
    }
    else
    {
        maskLayer.fillColor = self.fillColor.CGColor;
        [shapeLayer setNeedsDisplay];
    }
    
    if( self.addShadow )
    {
        shapeLayer.shadowColor = self.shadowColor.CGColor;
        shapeLayer.shadowOpacity = self.shadowAlpha;
        shapeLayer.shadowOffset = self.shadowOffset;
        shapeLayer.shadowRadius = self.shadowRadius;
        shapeLayer.shadowPath = containerPath;
        
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
	[self bringSubviewToFront:self.titleLabel];
	
	[self bringSubviewToFront:self.subTitle];
	
	[self bringSubviewToFront:self.normalIcon];
	[self bringSubviewToFront:self.selectedIcon];
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
