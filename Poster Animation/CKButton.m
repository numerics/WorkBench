//
//  CKButton.m
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKButton.h"


@interface CKButton()
{
    void (^_touchCallback)(void);
}

@end

@implementation CKButton



-(id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andTouchCallback:NULL];
}

-(id)initWithFrame:(CGRect)frame andTouchCallback:(void(^)(void))touchCallback
{
    if(self = [super initWithFrame:frame])
    {
		if(touchCallback)
        {
            _touchCallback = touchCallback;
            
            [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents: UIControlEventTouchUpInside];
        }
        
    }
    
    return self;
}

-(void)addTouchCallback:(void(^)(void))touchCallback
{
	_touchCallback = touchCallback;
}

-(void)onTouchUpInside:(UIButton *)button
{
    _touchCallback();
}

- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state
{
    if (backgroundStates == nil)
        backgroundStates = [[NSMutableDictionary alloc] init];
    
    [backgroundStates setObject:_backgroundColor forKey:[NSNumber numberWithInt:_state]];
    
    if (self.backgroundColor == nil)
        [self setBackgroundColor:_backgroundColor];
}

- (UIColor*) backgroundColorForState:(UIControlState) _state
{
    return [backgroundStates objectForKey:[NSNumber numberWithInt:_state]];
}

#pragma mark -
#pragma mark Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
    
    UIColor *selectedColor = [backgroundStates objectForKey:[NSNumber numberWithInt:UIControlStateHighlighted]];
    if (selectedColor)
    {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.layer addAnimation:animation forKey:@"EaseOut"];
        self.backgroundColor = selectedColor;
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
    
    UIColor *normalColor = [backgroundStates objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    if (normalColor)
    {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.layer addAnimation:animation forKey:@"EaseOut"];
        self.backgroundColor = normalColor;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UIColor *normalColor = [backgroundStates objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    if (normalColor)
    {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.layer addAnimation:animation forKey:@"EaseOut"];
        self.backgroundColor = normalColor;
    }
}
@end
