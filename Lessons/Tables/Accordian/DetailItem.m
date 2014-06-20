//
//  DetailItem.m
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "DetailItem.h"


@implementation DetailItem

@synthesize subTableItems;
@synthesize displayHeight;

-(id) initWithDictionary:(NSDictionary*) dict
{
	if (self = [super init])
	{
		self.subTableItems = [dict objectForKey:@"detailContent"];
	}
	return self;
}

@end
