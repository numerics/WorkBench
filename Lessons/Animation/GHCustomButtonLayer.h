//
//  GHCustomButtonLayer.h
//  GhostKit
//
//  Created by Basile, John on 8/28/13.
//  Copyright (c) 2013 Sota, Karan. All rights reserved.
//

#import "GHButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+EliteKit.h"
#import "UIView+EliteKit.h"
//#import "GHStyleManager.h"

typedef enum
{
    kLabelLeft = -1,
    kLabelCenter,
    kLabelRight,
} LabeAlignment;

typedef enum
{
    kIconLeft = -1,
    kIconCenter,
    kIconRight,
} IconAlignment;

@interface GHCustomButtonLayer : UIControl
{
    CGRect pathRect;
    
    CGMutablePathRef containerPath;
    
    CAShapeLayer        *pathLayer;
    CAShapeLayer        *maskLayer;
    CAShapeLayer        *shapeLayer;
    CAShapeLayer        *shadowLayer;
    CAGradientLayer     *backgroundLayer;
    CAShapeLayer        *highlightBackgroundLayer;
    
}
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitle;
@property (strong, nonatomic) UIImageView *normalIcon;
@property (strong, nonatomic) UIImageView *selectedIcon;


@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, assign) BOOL shouldCreateGradient;
@property (nonatomic, assign) BOOL addOuterGlow;
@property (nonatomic, assign) CGFloat glowAlpha;       // default = 0.4
@property (nonatomic, assign) CGFloat glowRadius;      // default = 12.0

@property (nonatomic, assign) BOOL addShadow;
@property (nonatomic, assign) CGFloat shadowAlpha;       // default = 0.8
@property (nonatomic, assign) CGSize  shadowOffset;      // default = CGSizeMake(0.0f, 4.0f)
@property (nonatomic, assign) CGFloat shadowRadius;      // default = 6.0

@property (nonatomic, assign) CGFloat fillAlpha;        // default = 0.8


@property (nonatomic, assign) BOOL addTopLeftNotch;
@property (nonatomic, assign) BOOL addTopRightNotch;
@property (nonatomic, assign) BOOL addBottomLeftNotch;
@property (nonatomic, assign) BOOL addBottomRightNotch;

@property (nonatomic, assign) CGFloat notchSize;        // default = 10.0
@property (nonatomic, assign) CGFloat lineWidth;        // default = 1.0
@property (nonatomic, assign) CGFloat lineAlpha;        // default = 1.0

@property (nonatomic, assign) CGFloat labelOffset;        // default = 1.0
@property (nonatomic, assign) LabeAlignment alignLabel;   // default = kIconCenter
@property (nonatomic, assign) IconAlignment alignIcon;    // default = kIconRight

@property (nonatomic, assign) CGFloat offSetLabel_X;	 // default = 10.0
@property (nonatomic, assign) CGFloat offSetLabel_Y;	 // default = 4.0
@property (nonatomic, assign) CGFloat offSetIcon_X;		 // from the center, defaults = 0
@property (nonatomic, assign) CGFloat offSetIcon_Y;		 // from the center, defaults = 0

- (void) btnHighlighted;
- (void) resetBtnColor;
- (void) btnSelected;


- (CGMutablePathRef)createFrame:(CGRect)rect;

- (void) setColorApperance:(int)apperance WithHexString:(NSString *) stringToConvert withAlpha:(CGFloat)alpha;
//- (void) setButtonApperance:(int)apperance;

- (void) commit;

-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
-(id)initWithFrame:(CGRect)frame attrTitle:(NSMutableAttributedString *)aTitle;
-(id)initWithFrame:(CGRect)frame Title:(NSString *)title andSubTitle:(NSString *)subTitle;
-(void)addImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon;
-(void)addImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon align:(int)align;

@end
