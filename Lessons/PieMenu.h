//
//  PieMenu.h
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 27/11/08.
//  Modified by John Basile on 6/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "PieMenuItem.h"

#define kMaxNumberOfItems   7

#define kLimitPieMenu //Tanoi-010810

@class PieView;

typedef enum {
	PieMenuFingerSizeTiny,
	PieMenuFingerSizeNormal,
	PieMenuFingerSizeBig,
} PieMenuFingerSize;

@interface PieMenu : NSObject
{
  @private
	BOOL leftHanded;
	PieMenuFingerSize fingerSize;
	PieView *pieView;
	UIView *__weak parentView;
	NSArray *items;
	NSMutableArray *path;
	BOOL on;
	
	UIImage *centerImage;									//Tanoi-011910
	UIColor *centerWheelColor;								//Tanoi-011910
}

@property (nonatomic) BOOL				on;
@property (nonatomic) BOOL				leftHanded;
@property (nonatomic) PieMenuFingerSize fingerSize;

@property (nonatomic, strong) UIImage *centerImage;			//Tanoi-011910
@property (nonatomic, strong) UIColor *centerWheelColor;	//Tanoi-011910

- (void) showInView:(UIView *)theView atPoint:(CGPoint)thePoint;
- (void) itemSelected:(PieMenuItem *)item;
- (void) addItem:(PieMenuItem *)item;
- (UIView *) view;
- (void) itemWithSubitemsSelected:(PieMenuItem *)theItem withIndex:(NSInteger)theIndex atPoint:(CGPoint)thePoint;
- (void) parentItemSelected:(PieMenuItem *)theItem withIndex:(NSInteger)theIndex atPoint:(CGPoint)thePoint;
@end
