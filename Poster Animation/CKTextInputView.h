//
//  CKTextInputView.h
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTextInputField.h"

@class AngledPaddedView;

@interface CKTextInputView : UIView
{
	CKTextInputField	*textfield;
	AngledPaddedView	*aPadView;
}
@property(nonatomic,strong) AngledPaddedView *aPadView;
@property(nonatomic,strong) CKTextInputField *textfield;


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