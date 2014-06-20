//
//  NSDictionary+Addititions.m
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "NSDictionary+Addititions.h"

@implementation NSDictionary (Addititions)

-(NSString *)queryStringFromParameters
{
    NSMutableString *queryString = [[NSMutableString alloc] init];
    __block BOOL isFirstKey = YES;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        NSString *delimeter = @"&";
        
        if(isFirstKey)
        {
            isFirstKey = NO;
            delimeter = @"";
        }
        
        [queryString appendFormat:@"%@%@=%@", delimeter, key, obj];
    }];
    
    return [NSString stringWithString:queryString];
}

- (id)objectOrNilForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    
    return [object isEqual:[NSNull null]] ? nil : object;
}

- (NSString *)JSONString
{
    return [self JSONString:NO];
    
}

-(NSString *)JSONString:(BOOL)prettyPrint
{
    NSError *error;
    NSJSONWritingOptions options = (NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
    
    if (!jsonData)
    {
        NSLog(@"%@", error.localizedDescription);
        return @"{}";
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

@implementation NSMutableDictionary(Addititions)

-(void)setObjectOrNil:(id)object forKey:(id <NSCopying>)key
{
    object = object == nil ? [NSNull null] : object;
    
    [self setObject:object forKey:key];
    
}


@end
