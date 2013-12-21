//
//  UIView+EliteKit.h
//  EliteKit
//
//  Created by Cameron Warnock on 5/2/13.
//  Copyright (c) 2013 Beachhead. All rights reserved.
//

#import <UIKit/UIKit.h>


#define deg2rad(degree) degree * M_PI / 180.0f
#define rad2deg(rad) rad * 180.0f / M_PI

@interface UIView (EKPositioning)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

-(void)move:(CGPoint)amount;

-(void)centerToView:(UIView *)view;

@end


@interface UIView(EKLayout)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat verticalCenter;
@property (nonatomic) CGFloat horizontalCenter;

@end


@interface UIView(EKTransform)

@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGFloat scaleX;
@property (nonatomic) CGFloat scaleY;

-(void)rotate:(CGFloat)amount;
-(void)scale:(CGFloat) amount;

@end


@interface UIView (Gradients)

-(void)setBackgroundGradientWithColors:(NSArray *) colors inRect:(CGRect) rectFrame atLocations:(NSArray *) locationsArray;

@end