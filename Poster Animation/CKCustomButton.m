//
//  GHCustomButton.m
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CKCustomButton.h"
#import <QuartzCore/QuartzCore.h>


@interface CKCustomButton()
{
    UIEdgeInsets           _contentEdgeInsets;

    void (^_touchCallback)(void);
}
@property(nonatomic)  CKButtonType buttonType;
-(void)setLocalTitle:(NSString *)title;
-(void)setLocalTitleColor:(UIColor *)color;
-(void)setLocalSubTitle:(NSString *)title;
-(void)setLocalSubTitleColor:(UIColor *)color;

@end

@implementation CKCustomButton

-(id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andTouchCallback:NULL];
}

-(id)initWithFrame:(CGRect)frame
  andTouchCallback:(void(^)(void))touchCallback
{
    if(self = [super initWithFrame:frame])
    {
        if(touchCallback)
        {
            _touchCallback = touchCallback;
            
            [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents: UIControlEventTouchUpInside];
        }
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
		buttonType:(CKButtonType)btnType
  andTouchCallback:(void(^)(void))touchCallback
{
    if(self = [super initWithFrame:frame buttontype:(CBButtonType)btnType])
    {
        if(touchCallback)
        {
            _touchCallback = touchCallback;
            
            [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents: UIControlEventTouchUpInside];
        }
		self.buttonType = btnType;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		buttonType:(CKButtonType)btnType
		appearance:(int)look
{
	if(self = [super initWithFrame:frame Title:title andSubTitle:subTitle])
	{
		self.buttonType = btnType;
		if( title)
			[self setLocalTitle:title];
		
		if( subTitle )
			[self setLocalSubTitle:subTitle];
		
		[self setButtonApperance:look];
	}
    return self;
}


-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		buttonType:(CKButtonType)btnType
		appearance:(int)look
  andTouchCallback:(void(^)(void))touchCallback
{
	if(self = [super initWithFrame:frame Title:title andSubTitle:subTitle])
	{
        if(touchCallback)
        {
            _touchCallback = touchCallback;
            
            [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents: UIControlEventTouchUpInside];
        }
		self.buttonType = btnType;
		if( title)
			[self setLocalTitle:title];
		
		if( subTitle )
			[self setLocalSubTitle:subTitle];
		
		[self setButtonApperance:look];
	}
    return self;
}


-(void)onTouchUpInside:(UIButton *)button
{
    _touchCallback();
}


- (void)setLocalTitle:(NSString *)title;
{
    CGRect frame = self.frame;
    if( !self.titleLabel )
    {
        [self setUpTitle:frame title:title];
    }
    else
	{
        [self updateLabel:title option:kTitle];
    }
}

-(void)setLocalTitleColor:(UIColor *)color
{
    self.titleLabel.textColor = color;
}

- (void)setLocalSubTitle:(NSString *)title;
{
    CGRect frame = self.frame;
    if( !self.titleLabel )
    {
		[self setUpSubTitle:frame subTitle:title];
    }
    else
	{
        [self updateLabel:title option:kSubtitle];
    }
}

-(void)setLocalSubTitleColor:(UIColor *)color
{
    self.subTitle.textColor = color;
}


-(void)setButtonApperance:(int)apperance
{
	[super setButtonApperance:apperance];
	[self update];
}

-(void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    CGFloat top = contentEdgeInsets.top;
    CGFloat left = contentEdgeInsets.left;
    CGFloat bottom = contentEdgeInsets.bottom;
    CGFloat right = contentEdgeInsets.right;
    
    if( UIEdgeInsetsEqualToEdgeInsets(contentEdgeInsets, UIEdgeInsetsZero) )
        return;
    
    if( top > 0 )
    {
        self.height += top;
        self.offSetLabel_Y += top;
        self.offSetIcon_Y += top;
    }
    else if ( top < 0 )
    {
        self.height -= abs(top);
        self.offSetLabel_Y -= abs(top);
        self.offSetIcon_Y -= abs(top);
    }
    
    if( bottom > 0 )
    {
        self.height += bottom;
        self.offSetLabel_Y -= bottom;
        self.offSetIcon_Y -= bottom;
    }
    else if ( bottom < 0 )
    {
        self.height -= abs(bottom);
        self.offSetLabel_Y += abs(bottom);
        self.offSetIcon_Y += abs(bottom);
    }
    
    if( left > 0 )
    {
        self.width += left;
        self.offSetLabel_X += left;
        self.offSetIcon_X += left;
    }
    else if ( left < 0 )
    {
        self.width -= left;
        self.offSetLabel_X += abs(left);
        self.offSetIcon_X += abs(left);
    }
    if( right > 0 )
    {
        self.width += right;
        self.offSetLabel_X -= right;
        self.offSetIcon_X -= right;
    }
    else if ( right < 0 )
    {
        self.width -= abs(right);
        self.offSetLabel_X += abs(right);
        self.offSetIcon_X += abs(right);
    }
    [self update];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
{
    CGRect frame = self.frame;
    if( !self.titleLabel )
    {
        [self setUpTitle:frame title:title];
    }
    else
	{
        [self updateLabel:title option:kTitle];
    }
    [self update];
}

-(void)setSubTitleColor:(UIColor *)color forState:(UIControlState)state
{
    self.subTitle.textColor = color;
    [self update];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if( state == UIControlStateNormal)
    {
        [self addImage:CGRectZero icon:image selectedIcon:nil];
    }
    else
    {
        [self addImage:CGRectZero icon:nil selectedIcon:image];
    }
    [self update];
}

-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    self.titleLabel.textColor = color;
    [self update];
}

- (void)setSubTitle:(NSString *)title forState:(UIControlState)state;
{
    CGRect frame = self.frame;
    if( !self.titleLabel )
    {
		[self setUpSubTitle:frame subTitle:title];
    }
    else
	{
        [self updateLabel:title option:kSubtitle];
    }
    [self update];
}


@end
