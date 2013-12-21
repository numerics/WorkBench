//
//  GHTextInputView.h
//  GhostKit
//
//  Created by John Basile on 9/1/13.
//  Copyright (c) 2013 John Basile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+EliteKit.h"
#import "UIColor+EliteKit.h"
#import "GHTextInputField.h"

@class AngledPaddedView;

@interface GHTextInputView : UIView
{
	GHTextInputField	*textfield;
	AngledPaddedView	*aPadView;
}
@property(nonatomic,strong) AngledPaddedView *aPadView;
@property(nonatomic,strong) GHTextInputField *textfield;


- (id)initWithFrame:(CGRect)frame withAnglePadding:(UIColor *)fillColor;

@end


@interface AngledPaddedView : UIView
{
	
}
@property(nonatomic,strong) UIColor *fillColor;

// properties to controll the angle intercept
// the leftInset is how many pixels to the right to intercept the top line
// the topInset is how many pixels from the top to intercept the left line
// The defaults are topInset = 9.0, leftInset = 10.0

@property(nonatomic,assign) CGFloat topInset;	
@property(nonatomic,assign) CGFloat leftInset;


- (id)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor;

@end