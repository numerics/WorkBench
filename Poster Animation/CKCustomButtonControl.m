//
//  CKCustomButtonLayer.m
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CKCustomButtonControl.h"

@interface CKCustomButtonControl ()
{
    BOOL    isHighlighting;  // for drawRect
	int		numberTextLines;
    CGRect  titleFrame;
    CGRect  subTitleFrame;
    
}
@property (nonatomic, assign) CGFloat titleShrink;

@property (nonatomic, assign) CGRect  titleFrame;
@property (nonatomic, assign) CGRect  subTitleFrame;
@property (nonatomic, assign) BOOL usingLabelRects;
@property (nonatomic, assign) BOOL created;

-(CGMutablePathRef)createFrame:(CGRect)rect;
-(CGMutablePathRef)createSelectionPath:(CGRect)rect;
-(CGMutablePathRef)createRoundedFrame:(CGRect)rect;
-(CGMutablePathRef)createCircledFrame:(CGRect)rect;


@end


@implementation CKCustomButtonControl
@synthesize titleFrame,subTitleFrame;

#pragma mark - init methods

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.frame = frame;
		self.layer.shouldRasterize = YES;
		[self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
        self.created = NO;
        self.titleShrink = 0.0;
        numberTextLines = 1;
        isHighlighting = NO;
        self.usingLabelRects = NO;
		self.btnType = kCBRectangleButton;
		[self defaultInit:frame];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame buttontype:(CBButtonType)type
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.frame = frame;
		self.layer.shouldRasterize = YES;
		[self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
        self.created = NO;
        self.titleShrink = 0.0;
        numberTextLines = 1;
        isHighlighting = NO;
        self.usingLabelRects = NO;
		self.btnType = type;
		[self defaultInit:frame];
	}
	return self;
}

-(void)defaultInit:(CGRect)frame
{
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	self.contentMode = UIViewContentModeRedraw;
    self.commitManagedByParent = NO;                // if a superclass overrides the Commit Method
    
	// we need to know
	self.lineAlpha = 1.0;
	self.fillAlpha = 1.0;
	
	self.centerTitleIfSubEmpty = NO;
	self.offSetLabel_X = 0.0;
	self.offSetLabel_Y = 0.0;
	
	self.offSetIcon_X = 0.0;
	self.offSetIcon_Y = 0.0;
	self.alignIcon = kIconRight;
	
	[self setColorApperance:kFillColor   WithHexString:@"0x222222" withAlpha:self.fillAlpha];
	[self setColorApperance:kStartColor  WithHexString:@"0x222222" withAlpha:self.fillAlpha];
	[self setColorApperance:kEndColor    WithHexString:@"0x000000" withAlpha:self.fillAlpha];
	[self setColorApperance:kBorderColor WithHexString:@"0x666666" withAlpha:self.lineAlpha];
	
	self.highlightFillColor = [[UIFactory sharedInstance] defaultColorHighlight];

	if (!self.shadowColor)
		self.shadowColor = [UIColor blackColor];
	
	pathRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
	
	if( self.btnType == kCBNotchedButton)
		self.unitSize = 10;
	else
		self.unitSize = 3;
		
	self.alpha = 1.0;
	self.glowRadius = 10.0;
	self.glowAlpha = 0.8;
	
	self.shadowAlpha = 0.8;
	self.shadowRadius = 6.0;
	self.shadowOffset = CGSizeMake(0.0, 0.0);
	
	if( self.btnType == kCBCircleButton)
		self.gradientButton = YES;
	
	self.layoutLabels = kVerticalLabels;
	self.lineWidth = 1.0;
    self.animateSelection = NO;
	self.hasSelectedGradient = self.gradientButton;
}

- (id)initWithFrame:(CGRect)frame attrTitle:(NSMutableAttributedString *)aTitle
{
    self = [self initWithFrame:frame];
	self.lineWidth = 1.0;
	self.hasSubTitle = NO;
    
    self.titleLabel.attributedText = aTitle;
    [self.titleLabel setNumberOfLines:0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
	
    [self bringSubviewToFront:self.titleLabel];
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title andSubTitle:(NSString *)subTitle layout:(LabelLayout)layoutLabel
{
    self = [self initWithFrame:frame];
	if(subTitle)									// Make room for subtitles... even if empty
		self.hasSubTitle = YES;
    [self setUpTitle:frame title:title];
	[self setUpSubTitle:frame subTitle:subTitle];
    [self changeLabelLayout:layoutLabel];
    return self;
}

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title andSubTitle:(NSString *)subTitle
{
    self = [self initWithFrame:frame];
	if(subTitle)									// Make room for subtitles... even if empty
		self.hasSubTitle = YES;
    [self setUpTitle:frame title:title];
	[self setUpSubTitle:frame subTitle:subTitle];
	
	return self;
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    self = [self initWithFrame:frame];
	self.hasSubTitle = NO;
	[self setUpTitle:frame title:title];
	
    return self;
}


#pragma mark - Apperance

- (void) setButtonApperance:(int)apperance
{
    if( self.btnType == kCBRectangleButton || self.btnType == kCBCustomButton )
	{
		self.unitSize = [MZStyleManager getCornerRadiusForButtonType:apperance];
	}
	
	UIColor *aa = getTextColorForButton(apperance);
	self.titleLabel.textColor = aa;
    self.titleLabel.highlightedTextColor = [UIColor blackColor];
	
    NSString *face = getFontTypeForButton(apperance) ;
    UIFont *avenLight = [UIFont fontWithName:face size:getTextSizeForButton(apperance)];
    self.titleLabel.font = avenLight;
    
	CGFloat lw = [MZStyleManager getLineWidthForButtonType:apperance];
	self.lineWidth = lw;
	if( lw > 0.0)
	{
		CGFloat la = [MZStyleManager getLineOpacityForButtonType:apperance];
		if( la > 0.0 && la <= 1.0 )
			self.lineAlpha = la;
		
		NSString *bString = [MZStyleManager getBorderColorForButtonType:apperance];
		if( bString )
		{
			self.borderColor = [UIColor colorWithHexString:bString withAlpha:self.lineAlpha];
		}
	}
	
    NSTextAlignment align = getTextAlignmentForButton(apperance);
    if ( align == NSTextAlignmentLeft)
        self.alignLabel = kLabelLeft;
    if ( align == NSTextAlignmentRight)
        self.alignLabel = kLabelRight;
    
    self.fillAlpha = [MZStyleManager getOpacityForButtonType:apperance];
    
    NSString *grad = [MZStyleManager getGradientForButtonType:apperance];
    if( [grad isEqualToString:@"YES"])
    {
        self.gradientButton = YES;
        self.startColor = [UIColor colorWithHexString:[MZStyleManager getStartColorForButtonType:apperance] withAlpha:self.fillAlpha];
        self.endColor = [UIColor colorWithHexString:[MZStyleManager getEndColorForButtonType:apperance] withAlpha:self.fillAlpha];
    }
    else
    {
        self.gradientButton = NO;
		NSString *cString = [MZStyleManager getFillColorForButtonType:apperance];
		if( cString )
		{
			if([cString isEqualToString:@"clear"])
				self.fillColor = [UIColor clearColor];
			else
				self.fillColor = [UIColor colorWithHexString:cString withAlpha:self.fillAlpha];
		}
    }
    
    NSString *invGrad = [MZStyleManager getInvGradientForButtonType:apperance];
    if( [invGrad isEqualToString:@"YES"])
    {
        self.hasSelectedGradient = YES;
        self.grad1Color = [UIColor colorWithHexString:[MZStyleManager getPoint1ColorForButtonType:apperance] withAlpha:self.fillAlpha];
        self.grad2Color = [UIColor colorWithHexString:[MZStyleManager getPoint2ColorForButtonType:apperance] withAlpha:self.fillAlpha];
    }
    else
    {
        self.hasSelectedGradient = NO;
		NSString *cString = [MZStyleManager getHighliteColorForButtonType:apperance];
		if( cString )
		{
			if([cString isEqualToString:@"clear"])
				self.highlightFillColor = [UIColor clearColor];
			else
				self.highlightFillColor = [UIColor colorWithHexString:cString withAlpha:self.fillAlpha];
		}
		else
			self.highlightFillColor = [[UIFactory sharedInstance] defaultColorHighlight];
    }
	
	
    NSString *drop = [MZStyleManager getDropShadowForButtonType:apperance];
    if( [drop isEqualToString:@"YES"])
    {
        self.addShadow = YES;
        self.shadowAlpha = [MZStyleManager getShadowOpacityForButtonType:apperance];
        self.shadowRadius = [MZStyleManager getShadowRadiusForButtonType:apperance];
		NSString *shColor = [MZStyleManager getShadowColorForButtonType:apperance];
		if( shColor )
		{
			self.shadowColor = [UIColor colorWithHexString:shColor];
		}
			
        CGFloat off = [MZStyleManager getShadowOffsetForButtonType:apperance];
        self.shadowOffset = CGSizeMake(0.0, off);
    }
    else
    {
        self.addShadow = NO;
    }
    
	//    NSString *link = [MZStyleManager getLinkForButtonType:apperance];
	//    if( [link isEqualToString:@"YES"])
	//    {
	//		[self addImage:CGRectMake(0, 0, 12, 12) icon:[UIImage imageNamed:@"little_arrow_white"] selectedIcon:[UIImage imageNamed:@"little_arrow_black"] align:kIconRight];
	//        self.titleShrink = 12.0;
	//    }
	//    else
	//    {
	//        if( self.normalIcon )
	//            [self.normalIcon removeFromSuperview];
	//        self.normalIcon = nil;
	//
	//        if( self.selectedIcon )
	//            [self.selectedIcon removeFromSuperview];
	//        self.selectedIcon = nil;
	//    }
}

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

- (void)showButtonActivity
{
    self.activityIndicator = [[CKCustomActivityIndicator alloc] initWithActivityIndicatorType:MZCustomActivityIndicatorTypeSmall];
    [self addSubview:self.activityIndicator];
    [self bringSubviewToFront:self.activityIndicator];
    [self.titleLabel setHidden:YES];
    [self.activityIndicator startAnimating];
}

- (void)hideButtonActivity
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    self.activityIndicator = nil;
    [self.titleLabel setHidden:NO];
}

#pragma mark - Labels
-(void)setUpTitle:(CGRect)frame title:(NSString *)title
{
	CGFloat titleHeight = 20.0;
    if(self.hasSubTitle == NO)
    {
        if( frame.size.height > 50)						// Large Button... just a title, should be Multy line text for a label
        {
            titleHeight = frame.size.height;
            numberTextLines = 0;		// allows for multiple lines
        }
	}
	CGFloat shrink = 10 + self.titleShrink + self.offSetLabel_X;            // To fit Labels in the Button
	
	self.titleLabel = [[CKLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - shrink, titleHeight)];
	[self addSubview:self.titleLabel];
	self.titleLabel.text = title;
	self.titleLabel.hidden = NO;
	self.titleLabel.userInteractionEnabled = NO;
    
	[self.titleLabel setLabelApperance:@"AR16FFC"];
	
    self.titleLabel.highlightedTextColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = numberTextLines;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	[self bringSubviewToFront:self.titleLabel];
}

-(void)setUpSubTitle:(CGRect)frame subTitle:(NSString *)subTitle
{
	CGFloat subTitleHeight;
    numberTextLines = 1;
    subTitleHeight = 16.0;
	CGFloat shrink = 10 + self.titleShrink + self.offSetLabel_X;            // To fit Labels in the Button
    
	self.subTitle = [[CKLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - shrink, subTitleHeight)];
	[self addSubview:self.subTitle];
	self.subTitle.hidden = NO;
    self.subTitle.userInteractionEnabled = NO;
	[self.subTitle setLabelApperance:@"AR16FFC"];
	
	self.subTitle.text = subTitle;
    self.subTitle.highlightedTextColor = [UIColor blackColor];
    self.subTitle.numberOfLines = numberTextLines;
	
    self.subTitle.lineBreakMode = self.titleLabel.lineBreakMode;
	[self bringSubviewToFront:self.subTitle];
	
	self.titleLabel.height = 18;
	
}

-(void)updateLabels:(NSString *)title subTitle:(NSString *)subTitle
{
	[self updateLabel:title option:kTitle];
	[self updateLabel:subTitle option:kSubtitle];
    [self.titleLabel setNeedsDisplay];
    [self.subTitle setNeedsDisplay];
}

-(void)updateLabel:(NSString *)atitle option:(int)TitleUpdate
{
    if( TitleUpdate == kTitle)
    {
        if( !atitle )
        {
            [self.titleLabel removeFromSuperview];
            self.titleLabel = nil;
        }
        else
        {
            if( !self.titleLabel )
            {
                [self setUpTitle:self.bounds title:atitle];
            }
            else
            {
                self.titleLabel.text = atitle;
            }
        }
    }
    else
    {
        if( !atitle )
        {
            [self.subTitle removeFromSuperview];
            self.subTitle = nil;
        }
        else
        {
            if( !self.subTitle )
            {
                [self setUpSubTitle:self.bounds subTitle:atitle];
            }
            else
            {
                self.subTitle.text = atitle;
            }
        }
    }
}

-(void)setAlignLabel:(LabelAlignment)alignLabel
{
    _alignLabel = alignLabel;
    if( alignLabel == kLabelLeft)
    {
		self.titleLabel.textAlignment = NSTextAlignmentLeft;
		self.subTitle.textAlignment = NSTextAlignmentLeft;
    }
    else if( alignLabel == kLabelRight)
    {
		self.titleLabel.textAlignment = NSTextAlignmentRight;
		self.subTitle.textAlignment = NSTextAlignmentRight;
    }
    else
	{
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		self.subTitle.textAlignment = NSTextAlignmentCenter;
	}
}

#pragma mark - Images
-(void)addImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon
{
	if( icon )
	{
		if (CGRectIsEmpty(frame))
        {
            self.normalIcon = [[UIImageView alloc] initWithImage:icon];
        }
        else
        {
            self.normalIcon = [[UIImageView alloc] initWithFrame:frame];
            self.normalIcon.image =icon;
        }
		[self addSubview:self.normalIcon];
		self.normalIcon.hidden = NO;
        self.normalIcon.userInteractionEnabled = NO;
	}
	
	if( selectedIcon )
	{
		if (CGRectIsEmpty(frame))
        {
            self.selectedIcon = [[UIImageView alloc] initWithImage:selectedIcon];
        }
        else
        {
            self.selectedIcon = [[UIImageView alloc] initWithFrame:frame];
            self.selectedIcon.image = selectedIcon;
        }
		[self addSubview:self.selectedIcon];
		self.selectedIcon.hidden = YES;
        self.selectedIcon.userInteractionEnabled = NO;
	}
    else    // use icon for the selection mode
    {
		if (CGRectIsEmpty(frame))
        {
            self.selectedIcon = [[UIImageView alloc] initWithImage:icon];
        }
        else
        {
            self.selectedIcon = [[UIImageView alloc] initWithFrame:frame];
            self.selectedIcon.image =icon;
        }
		[self addSubview:self.selectedIcon];
		self.selectedIcon.hidden = YES;
        self.selectedIcon.userInteractionEnabled = NO;
    }
	
	self.alignIcon = kIconRight;
}

-(void)updateImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon
{
	BOOL selectedDone = NO;
    if( icon )
	{
        if(!self.normalIcon)
        {
            [self addImage:frame icon:icon selectedIcon:selectedIcon];// this will take care of the selected version
            selectedDone = YES;
        }
        else
        {
            self.normalIcon.image = icon;
        }
	}
    if(selectedDone)
        return;
    
	if( selectedIcon )
	{
        if(!self.selectedIcon)
        {
            [self addImage:frame icon:nil selectedIcon:selectedIcon];
        }
        else
        {
            self.selectedIcon.image = selectedIcon;
        }
	}
}

-(void)addImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon align:(IconAlignment)align
{
	[self addImage:frame icon:icon selectedIcon:selectedIcon];
	self.alignIcon = align;
}

#pragma mark - Layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    if(self.hasSubTitle == YES)
    {
        if( self.layoutLabels == kHorizontalLabels)                                             // side by side
        {
            if( self.centerTitleIfSubEmpty && (!self.subTitle || [self.subTitle.text length] < 1))
			{
				self.titleLabel.verticalCenter = floorf((0.5 * self.height) + self.offSetLabel_Y);			// the default to center the label
				self.titleLabel.left = self.offSetLabel_X;
			}
			else
			{
				self.titleLabel.left	= self.offSetLabel_X;
				self.subTitle.left		= self.titleLabel.right + 10;
				self.titleLabel.verticalCenter = floorf((0.5 * self.height) + self.offSetLabel_Y);			// the default to center the label
				self.subTitle.top		= self.titleLabel.top;
			}
        }
        else                                                                                    // vertical Labels, default is centered Vert in frame
        {
            if( self.centerTitleIfSubEmpty && (!self.subTitle || [self.subTitle.text length] < 1))
			{
				self.titleLabel.verticalCenter = floorf((0.5 * self.height) + self.offSetLabel_Y);			// the default to center the label
				self.titleLabel.left = self.offSetLabel_X;
			}
			else
			{
				CGRect frame = self.bounds;
				CGRect tRect = self.titleLabel.frame;
				CGRect sRect = self.subTitle.frame;
				
				if(frame.size.height >= (tRect.size.height + sRect.size.height) )
				{
					CGFloat sp = frame.size.height - (tRect.size.height + sRect.size.height);
					self.titleLabel.top = floorf(sp / 2.0  + self.offSetLabel_Y);
				}
				else        // we need to shrink the rects accordingly
				{
					CGFloat fr = (tRect.size.height + sRect.size.height) / frame.size.height;
					titleFrame = tRect;
					subTitleFrame = sRect;
					titleFrame.size.height = tRect.size.height * fr;
					subTitleFrame.size.height = sRect.size.height * fr;
					self.titleLabel.frame = titleFrame;
					self.subTitle.frame = subTitleFrame;
					self.titleLabel.top = 0;
				}
                
				self.titleLabel.left	= self.offSetLabel_X;
				self.subTitle.left		= self.titleLabel.left;
				self.subTitle.top		= self.titleLabel.bottom;
			}
        }
    }
	else		// by design No Subtitles
	{
		self.titleLabel.verticalCenter = floorf((0.5 * self.height) + self.offSetLabel_Y);			// the default to center the label
		self.titleLabel.left = self.offSetLabel_X;
	}
	
	if( self.normalIcon)
	{
		self.normalIcon.verticalCenter = floorf(self.frame.size.height / 2);
		
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
			self.normalIcon.horizontalCenter = floorf(self.frame.size.width / 2);
			self.normalIcon.left += self.offSetIcon_X;
			self.normalIcon.top += self.offSetIcon_Y;
		}
		self.selectedIcon.top = self.normalIcon.top;
		self.selectedIcon.left = self.normalIcon.left;
	}
    self.activityIndicator.center = self.titleLabel.center;
}


-(void)changeLabelLayout:(LabelLayout)layoutLabel titleRect:(CGRect)tRect subTitleRect:(CGRect)sRect
{
    self.layoutLabels = layoutLabel;
    CGRect frame = self.bounds;
    self.usingLabelRects = YES;
    if(!self.hasSubTitle)			// only one label, just check/set the requested frame rect
	{
        if( frame.size.height > tRect.size.height && frame.size.width > tRect.size.width)
		{
            titleFrame = tRect;
		}
		else if (frame.size.height < tRect.size.height)
			tRect.size.height = frame.size.height;
		else if (frame.size.width < tRect.size.width)
			tRect.size.width = frame.size.width;
		
		self.titleLabel.frame = tRect;
		return;
    }
	
    if(layoutLabel == kVerticalLabels)
    {
        //        CGFloat titleHeight,subTitleHeight;
        if(frame.size.height > (tRect.size.height + sRect.size.height) )
        {
            CGFloat sp = frame.size.height - (tRect.size.height + sRect.size.height);
            self.offSetLabel_Y = 0.25 * sp;
            titleFrame = tRect;
            subTitleFrame = sRect;
        }
        else        // we need to shrink the rects accordingly
        {
            CGFloat fr = (tRect.size.height + sRect.size.height) / frame.size.height;
            titleFrame = tRect;
            subTitleFrame = sRect;
            titleFrame.size.height = tRect.size.height * fr;
            subTitleFrame.size.height = sRect.size.height * fr;
        }
    }
    else                                                                   // Horizontal
    {
        //        CGFloat titleWidth,subTitleWidth;
        //        CGFloat titleHeight,subTitleHeight;
        if(frame.size.width > (tRect.size.width + sRect.size.width) )
        {
            CGFloat sp = frame.size.width - (tRect.size.width + sRect.size.width);
            self.offSetLabel_X = 0.25 * sp;
            titleFrame = tRect;
            subTitleFrame = sRect;
        }
        else
        {
            CGFloat fr = (tRect.size.width + sRect.size.width) / frame.size.width;
            titleFrame = tRect;
            subTitleFrame = sRect;
            titleFrame.size.width = tRect.size.width * fr;
            subTitleFrame.size.width = sRect.size.width * fr;
        }
    }
    self.titleLabel.frame = titleFrame;
    
    self.subTitle.frame = subTitleFrame;
}

-(void)changeLabelLayout:(LabelLayout)layoutLabel
{
    self.layoutLabels = layoutLabel;
    CGRect frame = self.bounds;
    if(!self.hasSubTitle)
    {
        CGFloat shrink = 10 + self.titleShrink + self.offSetLabel_X;            // To fit Labels in the Button
        self.titleLabel.width = frame.size.width - shrink;
        self.subTitle.width = frame.size.width - shrink;
        return;
    }
    
    if(layoutLabel == kVerticalLabels)
    {
        CGFloat titleHeight,subTitleHeight;
        if(frame.size.height > 36)                                          // Large Button...
        {
            titleHeight = 20;
            subTitleHeight = 16.0;
            numberTextLines = 1;
        }
        else
        {
            titleHeight = 0.5*frame.size.height;
            subTitleHeight = titleHeight;
        }
        
        CGFloat shrink = 10 + self.titleShrink + self.offSetLabel_X;            // To fit Labels in the Button
        titleFrame    = CGRectMake(0, 0, frame.size.width - shrink, titleHeight);
        subTitleFrame = CGRectMake(0, 0, frame.size.width - shrink, subTitleHeight);
    }
    else                                                                   // Horizontal
    {
        CGFloat titleWidth,subTitleWidth;
        CGFloat titleHeight,subTitleHeight;
        if( frame.size.height > 40)                                         // Large Button... just a title, should be Multi line text for a label
        {
            numberTextLines = 0;                                            // allows for multiple lines... should already be set
            CGFloat shrink = 10 + self.titleShrink + self.offSetLabel_X;
            titleWidth = (0.5* (frame.size.width-shrink) );
            subTitleWidth = titleWidth;
            titleHeight = frame.size.height - 10.0;
            subTitleHeight = titleHeight;
        }
        else
        {
            numberTextLines = 1;                                            // only one line allowed
            CGFloat shrink = 10 + self.titleShrink + self.offSetLabel_X;
            titleWidth = (0.5* (frame.size.width-shrink) );
            subTitleWidth = titleWidth;
            titleHeight = 20.0;
            subTitleHeight = 16.0;
        }
        titleFrame    = CGRectMake(0, 0, titleWidth, titleHeight);
        subTitleFrame = CGRectMake(0, 0, subTitleWidth, subTitleHeight);
    }
    self.titleLabel.frame = titleFrame;
    
    self.subTitle.frame = subTitleFrame;
}


#pragma mark - Touches

- (void) setHighlighted: (BOOL) highlighted
{
    if( highlighted )
    {
        if(!self.animateSelection)
        {
            [CATransaction begin];      // this stops the implicit aniamtions of layers
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			
			if( self.gradientButton )
			{
				if( self.hasSelectedGradient )
				{
					normalStateGradientLayer.hidden = YES;
					selectedStateGradientLayer.hidden = NO;
				}
				else
					selectedStateBackgroundLayer.hidden = NO;
			}
			else
			{
				shapeLayer.fillColor = self.highlightFillColor.CGColor;
			}
            [CATransaction commit];
        }
        else
		{
			if( self.gradientButton )
			{
				if( self.hasSelectedGradient )
				{
					normalStateGradientLayer.hidden = YES;
					selectedStateGradientLayer.hidden = NO;
				}
				else
					selectedStateBackgroundLayer.hidden = NO;
			}
			else
			{
				shapeLayer.fillColor = self.highlightFillColor.CGColor;
			}
        }
        [self bringSubviewToFront:self.titleLabel];
        self.titleLabel.highlighted = YES;
        if( self.subTitle)
        {
            [self bringSubviewToFront:self.subTitle];
            self.subTitle.highlighted = YES;
        }
        if( self.normalIcon && self.selectedIcon)
        {
            self.normalIcon.hidden = YES;
            self.selectedIcon.hidden = NO;
            [self bringSubviewToFront:self.selectedIcon];
        }
    }
    else
    {
        self.titleLabel.highlighted = NO;
        if( self.subTitle)
        {
            self.subTitle.highlighted = NO;
        }
        if( self.normalIcon && self.selectedIcon)
        {
            self.normalIcon.hidden = NO;
            self.selectedIcon.hidden = YES;
        }
        if(!self.animateSelection)
        {
            [CATransaction begin];      // this stops the implicit aniamtions of layers
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			
			if( self.gradientButton )
			{
				if( self.hasSelectedGradient )
				{
					normalStateGradientLayer.hidden = NO;
					selectedStateGradientLayer.hidden = YES;
				}
				else
					selectedStateBackgroundLayer.hidden = YES;
			}
			else
			{
				shapeLayer.fillColor = self.fillColor.CGColor;
			}
            [CATransaction commit];
        }
        else
		{
			if( self.gradientButton )
			{
				if( self.hasSelectedGradient )
				{
					normalStateGradientLayer.hidden = NO;
					selectedStateGradientLayer.hidden = YES;
				}
				else
					selectedStateBackgroundLayer.hidden = YES;
			}
			else
			{
				shapeLayer.fillColor = self.fillColor.CGColor;
			}
		}
    }
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}


- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHighlighted:NO];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHighlighted:NO];
    [super touchesEnded:touches withEvent:event];
    //[self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

// *** FOR TESTING
/*
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [super addTarget:target action:action forControlEvents:controlEvents];
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
}
*/


#pragma mark - Drawing Methods

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
    
    return gr;
    
}

-(CAGradientLayer *)createInverseGradient
{
    CAGradientLayer *gr = [CAGradientLayer layer];
    gr.contentsScale = [UIScreen mainScreen].scale;
    
    gr.frame = self.bounds;
    gr.startPoint = CGPointMake(0.5, 0.0);
    gr.endPoint   = CGPointMake(0.5, 1.0);
    
    gr.colors = [NSArray arrayWithObjects:
                 (id)self.grad1Color.CGColor,
                 (id)self.grad2Color.CGColor,
                 nil];
    
    return gr;
}


-(CGMutablePathRef)createCircledFrame:(CGRect)rect
{
	
	CGPathRef path = CGPathCreateWithEllipseInRect(rect, nil);
	
	return (CGMutablePathRef)path;
}

-(CGMutablePathRef)createRoundedFrame:(CGRect)rect
{
	//CGAffineTransform *t;
    //CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathRef path = CGPathCreateWithRoundedRect(rect, self.unitSize, self.unitSize, nil);
	
	return (CGMutablePathRef)path;
}

-(CGMutablePathRef)createFrame:(CGRect)rect
{
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y + rect.size.height;
    
    CGFloat topLeftEdgeInset = 0.0, topRightEdgeInset = 0.0, bottomLeftEdgeInset = 0.0, bottomRightEdgeInset = 0.0;
    
    if (self.addTopLeftNotch)
        topLeftEdgeInset = self.unitSize;
    
    if (self.addTopRightNotch)
        topRightEdgeInset = self.unitSize;
    
    if (self.addBottomRightNotch)
        bottomRightEdgeInset = self.unitSize;
    
    if (self.addBottomLeftNotch)
        bottomLeftEdgeInset = self.unitSize;
    
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

-(CGMutablePathRef)createSelectionPath:(CGRect)rect
{
    CGMutablePathRef path = nil;
	
	if( self.btnType == kCBNotchedButton)
		path = [self createFrame:CGRectInset(rect,self.lineWidth+1,self.lineWidth+1)];
	else if( self.btnType == kCBRectangleButton)
		path = [self createRoundedFrame:CGRectInset(rect,self.lineWidth+1,self.lineWidth+1)];
	else if( self.btnType == kCBCircleButton)
		path = [self createCircledFrame:CGRectInset(rect,self.lineWidth+1,self.lineWidth+1)];
		
	return path;
}

-(CGMutablePathRef)createNormalPath:(CGRect)rect
{
    CGMutablePathRef path = nil;
	
	if( self.btnType == kCBNotchedButton)
		path = [self createFrame:rect];
	else if( self.btnType == kCBRectangleButton)
		path = [self createRoundedFrame:rect];
	else if( self.btnType == kCBCircleButton)
		path = [self createCircledFrame:rect];
	
	return path;
}

- (void)makeButton
{
    pathRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	
    containerPath = [self createNormalPath:pathRect];
    selectionPath = [self createSelectionPath:pathRect];
	
    if( !shapeLayer )
    {
        shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:shapeLayer];
    }
	
    shapeLayer.contentsScale = [UIScreen mainScreen].scale;
	shapeLayer.fillColor = [UIColor clearColor].CGColor;
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
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.path = containerPath;
	
    if( self.hasSelectedGradient)
	{
		if(!selGradMaskLayer)
		{
			selGradMaskLayer = [CAShapeLayer layer];
		}
		selGradMaskLayer.lineWidth = 0;//self.lineWidth;
		selGradMaskLayer.path = containerPath;
	}
	
    if(!maskLayer)
    {
        maskLayer = [CAShapeLayer layer];
        [shapeLayer addSublayer:pathLayer];
    }
    maskLayer.lineWidth = 0;//self.lineWidth;
    maskLayer.path = containerPath;
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

- (void)addNormalStateGradientLayer
{
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    if( !normalStateGradientLayer)
    {
        normalStateGradientLayer = [self createBackGroundGradient];
        
        [shapeLayer addSublayer:normalStateGradientLayer];
        [normalStateGradientLayer setMask:maskLayer];
    }
}

- (void)addSelectedStateGradientLayer
{
    selGradMaskLayer.fillColor = [UIColor blackColor].CGColor;
    if( !selectedStateGradientLayer)
    {
        selectedStateGradientLayer = [self createInverseGradient];
        [shapeLayer addSublayer:selectedStateGradientLayer];
        [selectedStateGradientLayer setMask:selGradMaskLayer];
        
		selectedStateGradientLayer.hidden = YES;
    }
}

- (void)addSelectedStateBackgroundLayer
{
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    if( !selectedStateBackgroundLayer)
    {
        selectedStateBackgroundLayer = [CAShapeLayer layer];
        [self.layer addSublayer:selectedStateBackgroundLayer];
        selectedStateBackgroundLayer.hidden = YES;
    }
    
    selectedStateBackgroundLayer.fillColor = self.highlightFillColor.CGColor;
    selectedStateBackgroundLayer.contentsScale = [UIScreen mainScreen].scale;
    selectedStateBackgroundLayer.lineJoin = kCALineJoinMiter;
    selectedStateBackgroundLayer.opacity = 1.0;
    selectedStateBackgroundLayer.lineWidth = 0;//self.lineWidth;
    selectedStateBackgroundLayer.path = selectionPath;
}

-(void)doShadow
{
    CGPathRef shadowPath;
    CGSize sOffSet;
	
	if( self.btnType == kCBNotchedButton)
	{
		if (self.addBottomRightNotch || self.addBottomLeftNotch ||self.addTopRightNotch || self.addTopLeftNotch)
		{
			shadowPath = [self createFrame:CGRectMake(0, 0, self.frame.size.width, self.unitSize + self.shadowRadius)];
			sOffSet = CGSizeMake(self.shadowOffset.width, self.frame.size.height + self.shadowOffset.height - self.unitSize);
		}
		else
		{
			CGRect shadowRect = CGRectMake(0, 0, self.frame.size.width, self.shadowRadius);
			shadowPath = CGPathCreateWithRect(shadowRect, NULL);
			sOffSet = CGSizeMake(self.shadowOffset.width, self.frame.size.height + self.shadowOffset.height);
		}
	}
	else if( self.btnType == kCBRectangleButton)
	{
		CGRect shadowRect = CGRectMake(0, 0, self.frame.size.width, self.shadowRadius);
		shadowPath = CGPathCreateWithRect(shadowRect, NULL);
		sOffSet = CGSizeMake(self.shadowOffset.width, self.frame.size.height + self.shadowOffset.height);
	}
	else if( self.btnType == kCBCircleButton)
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

-(BOOL)createAllButtonLayers
{
    [self makeButton];
		
	if( !self.hasSelectedGradient)
	{
		[self addSelectedStateBackgroundLayer];
	}
    if( self.gradientButton)
    {
        [self addNormalStateGradientLayer];
		[self addSelectedStateGradientLayer];
    }
    else
    {
		shapeLayer.fillColor = self.fillColor.CGColor;
		shapeLayer.lineWidth = self.lineWidth;
		shapeLayer.borderColor = self.borderColor.CGColor;
		shapeLayer.opacity = self.fillAlpha;
		
		maskLayer.fillColor = self.fillColor.CGColor;
    }
	
    if( self.addShadow )
    {
        [self doShadow];
    }
	
    if( self.addOuterGlow )
    {
        shapeLayer.shadowColor = self.shadowColor.CGColor;
        shapeLayer.shadowOpacity = self.glowAlpha;
        shapeLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        shapeLayer.shadowRadius = self.glowRadius;
        shapeLayer.shadowPath = containerPath;
    }
    CGPathRelease (containerPath);
    CGPathRelease (selectionPath);
    return YES;
}

- (void) commit
{
	if( !self.created)
        self.created = [self createAllButtonLayers];
    
    if(self.usingLabelRects == NO)                          // if we're using changeLabelLayout with rect's ... this is absolute
        [self changeLabelLayout:self.layoutLabels];         // so no need to update with this...
    
	[self bringSubviewToFront:self.titleLabel];
	[self bringSubviewToFront:self.subTitle];
	
	[self bringSubviewToFront:self.normalIcon];
	[self bringSubviewToFront:self.selectedIcon];
    [self.layer setNeedsDisplay];
}

- (void) update
{
	if( pathLayer)
	{
		[pathLayer removeFromSuperlayer];
		pathLayer = nil;
	}
	if( maskLayer)
	{
		[maskLayer removeFromSuperlayer];
		maskLayer = nil;
	}
	if( normalStateGradientLayer)
	{
		[normalStateGradientLayer removeFromSuperlayer];
		normalStateGradientLayer = nil;
	}
	if( selectedStateGradientLayer)
	{
		[selectedStateGradientLayer removeFromSuperlayer];
		selectedStateGradientLayer = nil;
	}
	if( selectedStateBackgroundLayer)
	{
		[selectedStateBackgroundLayer removeFromSuperlayer];
		selectedStateBackgroundLayer = nil;
	}
	if( shapeLayer)
	{
		[shapeLayer removeFromSuperlayer];
		shapeLayer = nil;
	}
	[self createAllButtonLayers];
	[self bringSubviewToFront:self.titleLabel];
	[self bringSubviewToFront:self.subTitle];
	
	[self bringSubviewToFront:self.normalIcon];
	[self bringSubviewToFront:self.selectedIcon];
    [self.layer setNeedsDisplay];
}

@end
