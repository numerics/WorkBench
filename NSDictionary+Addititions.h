//
//  NSDictionary+Addititions.h
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Addititions)

-(NSString *)queryStringFromParameters;

-(id)objectOrNilForKey:(id)aKey;

-(NSString *)JSONString:(BOOL)prettyPrint;
-(NSString *)JSONString;

@end

@interface NSMutableDictionary(Addititions)

-(void)setObjectOrNil:(id)object forKey:(id <NSCopying>)key;


@end
