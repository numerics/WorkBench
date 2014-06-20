//
//  CKScrollView.m
//  Mozart
//
//  Created by John Basile on 5/2/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKScrollView.h"

@implementation CKScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
    }
    return self;
}

- (id)initOnTopOfParent:(UIView*)pView
{
    
	self = [super initWithFrame:pView.bounds];
    if (self)
	{
        [pView addSubview:self];
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
	
}

@end
