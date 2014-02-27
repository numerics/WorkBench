//
//  GHCustomContainerLayer.h
//  layers
//
//  Created by John Basile on 8/26/13.
//  Copyright 2013 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GHCustomContainerLayer : UIView
{
    CGRect pathRect;
    
    CGMutablePathRef containerPath;
    
    CAShapeLayer        *pathLayer;
    CAShapeLayer        *maskLayer;
    CAShapeLayer        *shapeLayer;
    CAShapeLayer        *shadowLayer;
    CAGradientLayer     *gradientLayer;
    
}


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

- (void) select;
- (void) highlight;
- (void) resetColor;

- (id)initWithFrame: (CGRect) frame andAlpha:(CGFloat)alpha;

- (CGMutablePathRef)createFrame:(CGRect)rect;

- (void) setColorApperance:(int)apperance WithHexString:(NSString *) stringToConvert withAlpha:(CGFloat)alpha;
//- (void) setContainerApperance:(int)apperance;

- (void) commit;

@end
