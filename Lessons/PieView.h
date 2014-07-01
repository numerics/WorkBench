//
//  PieView.h
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 19/11/08.
//  Modified by John Basile on 6/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieMenu.h"

@interface PieView : UIView {
  @private	
	BOOL leftHanded;
	PieMenu *__weak menu;
	PieMenuItem *items[kMaxNumberOfItems];
	NSInteger selectedItem;
	NSInteger n_items;
	CGGradientRef bggradient;
	CGGradientRef selgradient;
	CGFloat initAngle;
	CGFloat endAngle;
	PieMenuFingerSize fingerSize;
	NSTimer *timer;
	
	UIImage *centerImage;		//Tanoi-011210
	UIColor *innerWheelColor;	//Tanoi-011910 , Passed color of the inner circle
}

@property (nonatomic) BOOL leftHanded;
@property (nonatomic) PieMenuFingerSize fingerSize;
@property (nonatomic, weak) PieMenu *menu;


// TW: this must be retain for standard practices to work properly.
@property (nonatomic, strong) UIImage *centerImage;		//Tanoi-011210
@property (nonatomic, strong) UIColor *innerWheelColor;	//Tanoi-011910


- (void) addItem:(PieMenuItem *)item;
- (void) clearItems;
- (CGFloat) minimumSize;

//- (void) loadCenterImage:(NSString *)imageName;//Tanoi-011210
@end
