//
//  GHBackgroundView.h
//
//  Created by Steve Kochan on 6/15/13
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GHCustomContainerView : UIView
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, assign) BOOL addTopLeftNotch;
@property (nonatomic, assign) BOOL addTopRightNotch;
@property (nonatomic, assign) BOOL addBottomLeftNotch;
@property (nonatomic, assign) BOOL addBottomRightNotch;

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, strong) UIColor *shadowColor;

@property (nonatomic, assign) BOOL shouldCreateGradient;
@property (nonatomic, assign) BOOL addShadow;
@property (nonatomic, assign) CGFloat notchSize;

@property (nonatomic, assign) CGFloat lineWidth;       // default = 1.0
@property (nonatomic, assign) CGFloat lineAlpha;       // default = 1.0

@property (nonatomic, strong) CAGradientLayer *fillGrad;
@property (nonatomic, strong) CAShapeLayer *shape;
@property (nonatomic, strong) CAShapeLayer *maskLayer;


- (void) select;
- (void) highlight;
- (void) resetColor;
- (id)initWithFrame: (CGRect) frame andAlpha:(CGFloat)alpha;
@end
