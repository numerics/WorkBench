//
//  CKTextFieldView.h
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaddedAngledView;

@interface CKTextFieldView : UIView<UITextViewDelegate>
{
	
}
@property(nonatomic,strong) PaddedAngledView    *aPadView;
@property(nonatomic,strong) UITextField         *textField;



- (id)initWithFrame:(CGRect)frame withAnglePadding:(UIColor *)fillColor;

@end


@interface PaddedAngledView : UIView
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