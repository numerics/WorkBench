//
//  DetailItem.h
//
//  Created by John Basile on 08/18/12.
//  Copyright (c) 2012 Beachbody, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemTableConstants.h"

@interface DetailItem : NSObject
{
	NSArray			*subTableItems;
	CGFloat			displayHeight;
}

@property (nonatomic,retain)	NSArray		*subTableItems;
@property (nonatomic,assign) 	CGFloat		displayHeight; // internal use only

-(id) initWithDictionary:(NSDictionary*) dict;

@end
