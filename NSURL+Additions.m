//
//  NSURL+Additions.m
//  Mozart
//
//  Created by John Basile on 4/23/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "NSURL+Additions.h"
#import "NSString+Additions.h"

@implementation NSURL (Additions)

-(NSDictionary *)queryParameters
{
    return self.query.parametersFromQueryString;
}

@end
