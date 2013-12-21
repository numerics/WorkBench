//
//  GHButton.h
//  GhostKit
//
//  Created by Sota, Karan on 6/17/13.
//  Copyright (c) 2013 Sota, Karan. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GHButton : UIButton

-(id)initWithFrame:(CGRect)frame andTouchCallback:(void(^)(void))touchCallback;

@end
