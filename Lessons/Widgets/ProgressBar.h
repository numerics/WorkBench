//
//  ProgressBar.h
//  WorkBench
//
//  Created by John Basile on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTLabel.h"
#import "BarberPole.h"

@interface ProgressBar : UIView
{
    CTLabel             *messageLabel;
    CTLabel             *statusLabel;
    CAGradientLayer     *barLayer;
    CAGradientLayer     *progressLayer;
	BarberPole			*barberPole;
    CGFloat             _progress;                   //ratio from 0 to 1
    NSUInteger          countOfSpheresToGenerate;
    CGFloat             _velocity;
    CGFloat             _time;
}
@property(nonatomic, strong)    CAGradientLayer     *barLayer;
@property(nonatomic, strong)    CAGradientLayer     *progressLayer;
@property(nonatomic, strong)    BarberPole			*barberPole;
@property(nonatomic, strong)    CTLabel             *messageLabel;
@property(nonatomic, strong)    CTLabel             *statusLabel;

@property(nonatomic) CGFloat progress;
@property(nonatomic) CGFloat velocity;
@property(nonatomic) CGFloat time;
@property NSUInteger countOfSpheresToGenerate;

- (void)drawBar;
- (void)drawProgress;

@end
