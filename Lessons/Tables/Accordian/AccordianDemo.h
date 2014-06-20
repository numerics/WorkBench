//
//  BasicAnimation.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
// 


#import <UIKit/UIKit.h>
#import "AccordianTableView.h"

@interface AccordianDemo : UIView
{
	AccordianTableView	*accordian;
}
@property (nonatomic, strong) AccordianTableView *accordian;

- (void)setUpView; 

@end
