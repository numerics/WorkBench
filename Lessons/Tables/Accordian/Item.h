//
//  Item.h
//
//  Created by John Basile on 08/18/12.
//  Copyright (c) 2012 Beachbody, LLC. All rights reserved.
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
