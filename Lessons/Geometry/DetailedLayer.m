//
//  SimpleLayer.m
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "DetailedLayer.h"


@implementation DetailedLayer
@synthesize showAnchor,smallAnchor,brownAnchor;

#define smAnchor	6.0
#define lgAnchor	8.0

- (id)init
{
	if((self = [super init]))
	{
		self.showAnchor = NO;
		self.smallAnchor = NO;
		self.brownAnchor = NO;
	}

	return self;
}


- (void)drawInContext:(CGContextRef)context
{
	
	if( self.showAnchor )
	{
		CGRect rect;
		CGRect bounds = self.bounds;
		CGSize layerSize = bounds.size;
		CGPoint layerOrigin = bounds.origin;
		CGPoint realAnchorPoint = CGPointMake(layerOrigin.x + (layerSize.width * self.anchorPoint.x),
											  layerOrigin.y + (layerSize.height * self.anchorPoint.y));
		
		if(self.smallAnchor )
			rect = CGRectMake(realAnchorPoint.x - (smAnchor / 2), realAnchorPoint.y - (smAnchor / 2), smAnchor, smAnchor);
		else
			rect = CGRectMake(realAnchorPoint.x - (lgAnchor / 2), realAnchorPoint.y - (lgAnchor / 2), lgAnchor, lgAnchor);
		
		CGContextAddEllipseInRect(context, rect);
		if(self.brownAnchor )
			CGContextSetFillColorWithColor(context, [[UIColor blueColor]CGColor]);
		else
			CGContextSetFillColorWithColor(context, [[UIColor redColor]CGColor]);
		
		CGContextDrawPath(context, kCGPathFill);
		
		NSString *temp = [NSString stringWithFormat:@"Bounds:%@  Position:%@  Frame:%@  Anchor Point:%@",
						  NSStringFromCGRect(self.bounds), 
						  NSStringFromCGPoint(self.position),
						  NSStringFromCGRect(self.frame), 
						  NSStringFromCGPoint(self.anchorPoint)];
		NSLog(@"%@, %@", self.name, temp);

	}
}

@end
