//
//  GHButton.m
//  GhostKit
//
//  Created by Sota, Karan on 6/17/13.
//  Copyright (c) 2013 Sota, Karan. All rights reserved.
//

#import "GHButton.h"

@interface GHButton()
{
    void (^_touchCallback)(void);
}

@end

@implementation GHButton

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

-(void)onTouchUpInside:(UIButton *)button
{
    _touchCallback();
}


@end
