//
//  UIButton+Additions.h
//  Mozart
//
//  Created by John Basile on 4/28/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Additions)

+(UIButton *)buttonWithImageNamed:(NSString *)imageName;

@property(nonatomic,assign) UIEdgeInsets hitTestEdgeInsets;

@end

@interface UIButton (Badge)
- (BOOL) addBadgeWithValue: (int) badgeValue andBackground: (NSString *) background;
- (void) removeBadge;
- (void) enableBadge: (BOOL) showIt;

- (int)  badgeValue;
- (void) setBadgeValue: (int) value;

- (BOOL) hasBadge;
- (void) adjustBadgeCenter: (CGPoint) vector;

@end
