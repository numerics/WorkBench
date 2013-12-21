//
// File:       MotionAlongAPathViewController.h
//
// Version:    1.0

#import <UIKit/UIKit.h>

@interface MotionAlongAPathView : UIView
{
	BOOL			drawPath;
    UIView			*_thumbnail;
    UIView			*_trash;
    CGPathRef		_path;
	UISwitch		*pathSwitch;
}
@property(assign) BOOL drawPath;

- (void)setPath:(CGPathRef)path;
- (void)setUpView;

@end

