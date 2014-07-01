//
//  CKCustomButtonControl.h
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CKLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "MZStyleManager.h"
#import "CKCustomActivityIndicator.h"

typedef enum
{
    kLabelLeft = -1,
    kLabelCenter,
    kLabelRight,
} LabelAlignment;

typedef enum
{
    kVerticalLabels = 0,
    kHorizontalLabels,
} LabelLayout;

typedef enum
{
    kIconLeft = -1,
    kIconCenter,
    kIconRight,
} IconAlignment;

typedef enum
{
    kTitle = 0,
    kSubtitle,
} TitleUpdate;

typedef enum
{
    kCBCustomButton,			// provide Custom Path by overiding -(CGMutablePathRef)createFrame:(CGRect)rect;
    kCBNotchedButton,			// Set the self.notchSize, and addTopLeftNotch,addTopRightNotch,addBottomLeftNotch,addBottomRightNotch
    kCBCircleButton,			// The self.notchSize will be used as the radius, ... can add special gradient hilight
    kCBRectangleButton		// The self.notchSize will be used as the corner radius
} CBButtonType;

@interface CKDynamicButton : UIControl
{
	CAShapeLayer        *shapeLayer;
	CAShapeLayer        *selectedStateBackgroundLayer;
}
@property (strong, nonatomic) CKLabel *titleLabel;
@property (strong, nonatomic) CKLabel *subTitle;
@property (nonatomic, assign) BOOL commitManagedByParent;
@property (nonatomic, assign) BOOL animateSelection;
@property (nonatomic, assign) BOOL delaysContentTouches; // default is NO, shoule be set if button is in a scrollview, to make sure its a touch vs a panGesture
@property (nonatomic, assign) BOOL hasSubTitle;
/// If Button has subtitle, but its state is empty, i.e [subtitle length]==0,
/// then if centerTitleIfSubEmpty = YES, will for Title to be centered,
/// (vertically if kVerticalLabels, or horizontally if kHorizontalLabels
@property (nonatomic, assign) BOOL centerTitleIfSubEmpty;		// default is NO

@property (strong, nonatomic) UIImageView *normalIcon;
@property (strong, nonatomic) UIImageView *selectedIcon;

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, strong) UIColor *grad1Color;
@property (nonatomic, strong) UIColor *grad2Color;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *highlightFillColor;

@property (nonatomic, assign) BOOL gradientButton;
@property (nonatomic, assign) BOOL hasSelectedGradient;		// Gradient Button generally will inverse on selection

@property (nonatomic, assign) BOOL addOuterGlow;
@property (nonatomic, assign) CGFloat glowAlpha;            // default = 0.4
@property (nonatomic, assign) CGFloat glowRadius;           // default = 12.0

@property (nonatomic, assign) BOOL addShadow;
@property (nonatomic, assign) CGFloat shadowAlpha;          // default = 0.8
@property (nonatomic, assign) CGSize  shadowOffset;         // default = CGSizeMake(0.0f, 4.0f)
@property (nonatomic, assign) CGFloat shadowRadius;         // default = 6.0

@property (nonatomic, assign) BOOL addTopLeftNotch;
@property (nonatomic, assign) BOOL addTopRightNotch;
@property (nonatomic, assign) BOOL addBottomLeftNotch;
@property (nonatomic, assign) BOOL addBottomRightNotch;

@property (nonatomic, assign) CGFloat unitSize;             // default = depends on Button Type
@property (nonatomic, assign) CGFloat lineWidth;            // default = 1.0
@property (nonatomic, assign) CGFloat lineAlpha;            // default = 1.0
@property (nonatomic, assign) CGFloat fillAlpha;            // default = 1.0

@property (nonatomic, assign) CGFloat offSetLabel_X;        // default = 0.0, spacing is 10 from ends
@property (nonatomic, assign) CGFloat offSetLabel_Y;        // default = 0.0, spacing is 4 from top
@property (nonatomic, assign) CGFloat labelOffset;          // default = 1.0
@property (nonatomic, assign) LabelAlignment alignLabel;    // default = kIconCenter
@property (nonatomic, assign) LabelLayout layoutLabels;     // default = kVerticalLabels

@property (nonatomic, assign) IconAlignment alignIcon;      // default = kIconRight
@property (nonatomic, assign) CGFloat offSetIcon_X;         // from the center, defaults = 0
@property (nonatomic, assign) CGFloat offSetIcon_Y;         // from the center, defaults = 0

@property (nonatomic, assign) CBButtonType btnType;

// Button Activity Indicator
@property (nonatomic, strong) CKCustomActivityIndicator *activityIndicator;
- (void)showButtonActivity;
- (void)hideButtonActivity;

-(id)initWithFrame:(CGRect)frame buttontype:(CBButtonType)type;

-(void)setColorApperance:(int)apperance WithHexString:(NSString *) stringToConvert withAlpha:(CGFloat)alpha;
-(void)setButtonApperance:(int)apperance;
-(void)changeLabelLayout:(LabelLayout)layoutLabel;
-(void)changeLabelLayout:(LabelLayout)layoutLabel titleRect:(CGRect)tRect subTitleRect:(CGRect)sRect;

-(void)commit;
-(void)update;

-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
-(id)initWithFrame:(CGRect)frame attrTitle:(NSMutableAttributedString *)aTitle;
-(id)initWithFrame:(CGRect)frame Title:(NSString *)title andSubTitle:(NSString *)subTitle;
-(id)initWithFrame:(CGRect)frame Title:(NSString *)title andSubTitle:(NSString *)subTitle layout:(LabelLayout)layoutLabel;

-(void)addImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon;
-(void)addImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon align:(IconAlignment)align;
-(void)updateImage:(CGRect)frame icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon;

-(void)updateLabels:(NSString *)title subTitle:(NSString *)subTitle;
-(void)updateLabel:(NSString *)atitle option:(int)TitleUpdate;

-(void)setUpTitle:(CGRect)frame title:(NSString *)title;
-(void)setUpSubTitle:(CGRect)frame subTitle:(NSString *)subTitle;

@end
