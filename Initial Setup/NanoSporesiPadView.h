//
//  NanoSporesiPadViewController.h
//  NanoSporesiPad
//
//  Created by Brad Larson on 4/29/2010.
//
//  This is a rough port of the Mac sample application NanoSpores ( http://groups.google.com/group/des-moines-cocoaheads/browse_thread/thread/f0fd4863b03793d4?pli=1 ) by Hari Wiguna
//  which was based on Scott Stevenson's NanoLife sample application ( http://theocacao.com/document.page/555/ )

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NanoSporesiPadView : UIView <UIGestureRecognizerDelegate>
{
    NSUInteger countOfSpheresToGenerate;
    CGPoint touchDownPoint;
    CALayer* containerLayerForSpheres;
    UIColor* sphereCoreColor;
    UIColor* sphereGlowColor;
}

@property NSUInteger countOfSpheresToGenerate;

@property (strong) UIColor* sphereCoreColor;
@property (strong) UIColor* sphereGlowColor;
- (void)setUpView; 

@end

