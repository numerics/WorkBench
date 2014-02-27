//
//  BasicAnimation.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
// 


#import <UIKit/UIKit.h>
#import "AccordianViewController.h"

@interface AccordianDemo : UIView
{
	AccordianViewController	*accordian;
}
@property (nonatomic, strong) AccordianViewController *accordian;

- (void)setUpView; 

@end
