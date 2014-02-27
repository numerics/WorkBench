//
//  AnimationGroups.h
//  WorkBench
//
//  Created by John Basile on 1/10/11.
//  Copyright 2011 Numerics. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DetailedLayer.h"
#import "CTextField.h"

@interface AnimationGroups : UIView 
{
	DetailedLayer *pulseLayer;
    CTextField      *tName;
}

- (void)setUpView; 

@end
