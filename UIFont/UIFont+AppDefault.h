//
//  UIFont+AppDefault.h
//  Navigator
//
//  Created by Earl Bonovich on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIFont (AppDefault)

+(UIFont *)appLightFontOfSize:(CGFloat)fontSize;
+(UIFont *)appBoldFontOfSize:(CGFloat)fontSize;
+(UIFont *)appBookFontOfSize:(CGFloat)fontSize;
+(UIFont *)appMediumFontOfSize:(CGFloat)fontSize;
+(UIFont *)appItalicFontOfSize:(CGFloat)fontSize;

+(NSString *)appLightFontName;
+(NSString *)appBoldFontName;
+(NSString *)appBookFontName;
+(NSString *)appMediumFontName;
+(NSString *)appItalicFontName;

@end
