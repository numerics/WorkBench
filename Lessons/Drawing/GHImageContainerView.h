//
//  GHImageContainerView.h
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GHImageContainerView : UIView
{
    CALayer             *imageLayer;
	CAShapeLayer		*maskLayer;
    UIImage             *containedImage;

}
- (void)setUpView:(CGRect)rect;
@property (nonatomic, strong) UIImage *containedImage;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) BOOL addTopLeftNotch;
@property (nonatomic, assign) BOOL addTopRightNotch;
@property (nonatomic, assign) BOOL addBottomLeftNotch;
@property (nonatomic, assign) BOOL addBottomRightNotch;

@property (nonatomic, assign) CGFloat notchSize;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;       //
@end
