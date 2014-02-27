//
//  ProgressInd.h
//  WorkBench
//
//  Created by John Basile on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>

extern const CGFloat kProgessLayerWidth;
extern const CGFloat kProgessLayerHeight;

@interface ProgressInd : CALayer
{
    CGFloat             _progress;                   //ratio from 0 to 1
    CAGradientLayer     *barLayerl;
    CAGradientLayer     *progressLayer;
}
@property(nonatomic) CGFloat progress;
@end
