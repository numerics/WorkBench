//
//  Item.m
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize icon,title,detail,content;

-(id) initWithDictionary:(NSDictionary*) dict
{
	if (self = [super init])
	{
		icon = [UIImage imageNamed:[dict valueForKey:@"icon"]];
		title = [dict valueForKey:@"title"];
		detail = [dict valueForKey:@"detail"];
		content = [[DetailItem alloc] initWithDictionary:dict];
 	}
	return self;
}

//+(NSArray*) allItems
//{
//	NSString* contentPath = [[NSBundle mainBundle] pathForResource:@"home-content" ofType:@"plist"];
//	NSArray* allContent = [NSArray arrayWithContentsOfFile:contentPath];
//	NSMutableArray* allItems = [NSMutableArray arrayWithCapacity:allContent.count];
//	for (NSDictionary* d in allContent)
//	{
//		Item* hi = [[Item alloc] initWithDictionary:d];
//		[allItems addObject:hi];
//	}
//	return allItems;
//}


@end
