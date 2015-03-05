//
//  DetailData.m
//  WorkBench
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "DetailData.h"

@implementation DetailData
@synthesize target,title,action,imageName;


+(DetailData*) initWithTarget:(NSObject*)t action:(SEL)s imageNamed:(NSString*)imgName title:(NSString*)text
{
	DetailData* mbi = [[DetailData alloc] init];
	mbi.title = text;
	mbi.imageName = imgName;
	mbi.target = t;
	mbi.action = s;
	return mbi;
}


@end
