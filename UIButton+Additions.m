//
//  UIButton+Additions.m
//  Mozart
//
//  Created by John Basile on 4/28/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "UIButton+Additions.h"
#import <objc/runtime.h>

@implementation UIButton (Additions)

@dynamic hitTestEdgeInsets;

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

-(void) setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if (value)
	{
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }
	else
	{
        return UIEdgeInsetsZero;
    }
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||  !self.enabled || self.hidden)
	{
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

+(UIButton *)buttonWithImageNamed:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.width = image.size.width;
    button.height = image.size.height;
    
    return button;
}
@end

#define kBadgeView     1234
#define kBadgeLabel    5678

@implementation UIButton (Badge)

-(void) enableBadge: (BOOL) showIt
{
    UIImageView *badgeView =  (UIImageView *) [self viewWithTag: kBadgeView];
    if (badgeView)
        badgeView.alpha = showIt;
}

-(BOOL) hasBadge
{
    return [self viewWithTag: kBadgeLabel] != nil;
}

- (void) adjustBadgeCenter: (CGPoint) vector
{
    UIImageView *badgeView = (UIImageView *) [self viewWithTag: kBadgeView];
    
    if (badgeView)
	{
        CGPoint center = badgeView.center;
        
        center.x += vector.x;
        center.y += vector.y;
        
        badgeView.center = center;
    }
}

-(BOOL) addBadgeWithValue: (int) badgeValue andBackground: (NSString *) background
{
    UIImage *badge = [UIImage imageNamed: background];
    
    if (!badge)
        return NO;
	
    UIImageView *badgeView = (UIImageView *) [self viewWithTag: kBadgeView];
    
    if (badgeView)
	{
        [self setBadgeValue: badgeValue];
        return 0;
    }
    
    badgeView = [[UIImageView alloc] initWithImage: badge];
    
    if (!badgeView)
        return NO;
    
    // Add the badge image
    
    NSLog (@"button = %@, badgeView = %@", [NSValue valueWithCGRect:self.bounds],
           [NSValue valueWithCGRect: badgeView.bounds]);
	
    CGPoint badgeCenter = CGPointMake (self.bounds.size.width -  badgeView.bounds.size.width / 2 - 5, 15);
    
    badgeView.center = badgeCenter;
    badgeView.tag = kBadgeView;
    badgeView.clipsToBounds = YES;
    [self addSubview: badgeView];
    
    // Add the label and set to the badgeValue
    
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame: badgeView.bounds];
    
    CGPoint labelCenter = badgeLabel.center;
    labelCenter.x -= .5;
    labelCenter.y += 1;
    badgeLabel.center = labelCenter;
    
    badgeLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size:11];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.backgroundColor = [UIColor clearColor];
    badgeLabel.adjustsFontSizeToFitWidth = YES;
    badgeLabel.textColor =  [UIColor blackColor];
    badgeLabel.shadowColor = [UIColor whiteColor];
    badgeLabel.shadowOffset = CGSizeMake (0, .1f);
    badgeLabel.tag = kBadgeLabel;
    
    [badgeView addSubview: badgeLabel];
    [self setBadgeValue: badgeValue];
    
    return YES;
}

-(void) removeBadge
{
    UIImageView *badgeView = (UIImageView *) [self viewWithTag: kBadgeView];
    [badgeView removeFromSuperview];
}

-(int) badgeValue
{
    UILabel *badgeLabel = (UILabel *) [self viewWithTag: kBadgeLabel];
    
    if (badgeLabel)
        return [badgeLabel.text intValue];
    else
        return 0;
}

-(void) setBadgeValue: (int) value
{
    UILabel *badgeLabel = (UILabel *) [self viewWithTag: kBadgeLabel];
    
    if (badgeLabel)
        badgeLabel.text = [NSString stringWithFormat: @"%i", value];
}
@end
