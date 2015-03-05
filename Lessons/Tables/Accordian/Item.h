//
//  Item.h
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailItem.h"

@interface Item : NSObject
{
	UIImage			*icon;
	NSString		*title;
	NSString		*detail;
	
	DetailItem		*content;
}

@property (nonatomic,retain) 	UIImage		*icon;
@property (nonatomic,retain) 	NSString	*title;
@property (nonatomic,retain) 	NSString	*detail;
@property (nonatomic,retain) 	DetailItem	*content;

-(id) initWithDictionary:(NSDictionary*) dict;

//+(NSArray*) allItems;

@end
