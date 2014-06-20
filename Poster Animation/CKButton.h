//
//  CKButton.h
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKButton : UIButton
{
@private
    NSMutableDictionary *backgroundStates;
@public
    
}

-(id)initWithFrame:(CGRect)frame andTouchCallback:(void(^)(void))touchCallback;
- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state;
- (UIColor*) backgroundColorForState:(UIControlState) _state;
- (void)addTouchCallback:(void(^)(void))touchCallback;
@end
