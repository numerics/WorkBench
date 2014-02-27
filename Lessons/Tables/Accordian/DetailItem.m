//
//  DetailItem.m
//
//  Created by John Basile on 08/18/12.
//  Copyright (c) 2012 Beachbody, LLC. All rights reserved.
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
