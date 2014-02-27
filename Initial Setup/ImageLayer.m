//
//  ImageLayer.m
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "ImageLayer.h"


@implementation ImageLayer


- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event 
{
	CATransition *anim = nil;
	if ([event isEqualToString:@"contents"]) 
	{
		anim = [CATransition animation];
		anim.duration = .33;
		anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		anim.type = kCATransitionPush;
		anim.subtype = kCATransitionFromRight;
	}
	return anim;
}

- (void)drawInContext:(CGContextRef)context
{
	if([[self valueForKey:@"moneyImageIsBen"] boolValue]) 
	{
		self.contents = (id)[[UIImage imageNamed:@"Ben.png"] CGImage];
	} 
	else 
	{
		self.contents = (id)[[UIImage imageNamed:@"Ben.png"] CGImage];
		//self.contents = (id)[[UIImage imageNamed:@"Steve.png"] CGImage];
	}
}

@end
