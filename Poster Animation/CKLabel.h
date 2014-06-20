//
//  MZLabel.h
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZStyleManager.h"

@interface CKLabel : UILabel

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title andSize:(int)fontSize andGray:(CGFloat)grayValue;

- (void) setLabelApperance:(NSString *)apperance;
- (void) setLabelApperance:(NSString *)apperance withShadow:(int)shadowType;

@end
