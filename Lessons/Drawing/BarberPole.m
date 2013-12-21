//
//  BarberPole.m
//  WorkBench
//
//  Created by John Basile on 5/12/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "BarberPole.h"
#import "StripeLayer.h"


@implementation BarberPole

- (id)init
{
	if((self = [super init]))
	{
		[self setOpaque:NO];
		int cnt = 300/5;//self.bounds.size.width/5;
		for( int i = 0; i < cnt; i++)
		{
			StripeLayer *strp1 = [[StripeLayer alloc] init];
			strp1.anchorPoint = CGPointMake(0.5, 0.5);
			strp1.bounds = CGRectMake(0.00, 0.00, 5.0, 200.0);
			strp1.position = CGPointMake(15.0 *(i), 0.5*200.0);
			CATransform3D currentTransform = strp1.transform;
			CATransform3D rotated = CATransform3DRotate(currentTransform, .262, 0., 0., 1.);
			strp1.transform = rotated;
			[self addSublayer:strp1];
			[strp1 setNeedsDisplay];
		}
	}
	return self;
}

//- (void)drawInContext:(CGContextRef)context 
//{
////	NSArray* sublayers = self.sublayers;
////    if( [sublayers count] > 0 )
////	{
////		for( int i = [sublayers count]-1; i==0; i--)
////		{
////			StripeLayer* layer = [sublayers objectAtIndex:i];
////			[layer removeFromSuperlayer];
////			[layer release];
////		}
////	}
//	
//	int cnt = self.bounds.size.width/5;
//	for( int i = 0; i < cnt; i++)
//	{
//		StripeLayer *strp1 = [[StripeLayer alloc] init];
//		strp1.anchorPoint = CGPointMake(0.5, 0.5);
//		strp1.bounds = CGRectMake(0.00, 0.00, 5.0, 200.0);
//		strp1.position = CGPointMake(15.0 *(i), 0.5*200.0);
//		CATransform3D currentTransform = strp1.transform;
//		CATransform3D rotated = CATransform3DRotate(currentTransform, .262, 0., 0., 1.);
//		strp1.transform = rotated;
//		[self addSublayer:strp1];
//		[strp1 setNeedsDisplay];
//	}
//}

@end
