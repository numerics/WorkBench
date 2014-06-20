//
//  GHCustomButton.h
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CKCustomButtonControl.h"
typedef enum
{
    kCustomButton,			// provide Custom Path by overiding -(CGMutablePathRef)createFrame:(CGRect)rect;
    kNotchedButton,			// Set the self.notchSize, and addTopLeftNotch,addTopRightNotch,addBottomLeftNotch,addBottomRightNotch
    kCircleButton,			// The self.notchSize will be used as the radius, ... can add special gradient hilight
    kRectangleButton		// The self.notchSize will be used as the corner radius
} CKButtonType;

@interface CKCustomButton : CKCustomButtonControl
{
@private
    NSMutableDictionary *backgroundStates;  ///** TODO ** AND ALL THE DIFF STATES, COLOR, TITLE, SHADOW, ETC...
@public
    
}
@property(nonatomic)          UIEdgeInsets contentEdgeInsets; // default is UIEdgeInsetsZero



-(id)initWithFrame:(CGRect)frame
  andTouchCallback:(void(^)(void))touchCallback;

-(id)initWithFrame:(CGRect)frame
		buttonType:(CKButtonType)btnType
  andTouchCallback:(void(^)(void))touchCallback;

-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		buttonType:(CKButtonType)btnType
		appearance:(int)look;


-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		buttonType:(CKButtonType)btnType
		appearance:(int)look
  andTouchCallback:(void(^)(void))touchCallback;



-(void)setTitle:(NSString *)title forState:(UIControlState)state;
-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state;   // default if nil. use opaque white
-(void)setImage:(UIImage *)image forState:(UIControlState)state;        // default is nil. should be same size if different for different states
-(void)setSubTitle:(NSString *)title forState:(UIControlState)state;
-(void)setSubTitleColor:(UIColor *)color forState:(UIControlState)state;   // default if nil. use opaque white
-(void)setButtonApperance:(int)apperance;

@end
