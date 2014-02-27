//
//  GHCustomImageContainerView.h
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GHCustomImageContainerView : UIView

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) UIImageView *containedImage;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) BOOL addTopLeftNotch;
@property (nonatomic, assign) BOOL addTopRightNotch;
@property (nonatomic, assign) BOOL addBottomLeftNotch;
@property (nonatomic, assign) BOOL addBottomRightNotch;

@property (nonatomic, assign) CGFloat notchSize;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;

@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) BOOL sizeImageToFrame;

- (id)initWithImage:(UIImageView *)containedImage;
- (id)initWithFrame:(CGRect)frame withImage:(UIImageView *)containedImage;
- (id)initWithFrame:(CGRect)frame withImage:(UIImageView *)containedImage andImageFrame:(CGRect)iFrame;

@end
