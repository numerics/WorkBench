//
//  UIFont+AppDefault.m
//  < Font Default for Applicaiton >
//
//  Created by Earl Bonovich on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIFont+AppDefault.h"


@implementation UIFont (AppDefault)

static NSString *fileNameOfLightFont = @"ClearviewTextLight"; 
+(UIFont *)appLightFontOfSize:(CGFloat)fontSize {
	UIFont *fontToUse = [UIFont fontWithName:fileNameOfLightFont size:fontSize];
	return fontToUse;
}
+(NSString *)appLightFontName {
	return fileNameOfLightFont;
}


static NSString *fileNameOfBoldFont = @"ClearviewTextBold"; 
+(NSString *)appBoldFontName {
	return fileNameOfBoldFont;
}
+(UIFont *)appBoldFontOfSize:(CGFloat)fontSize {
	UIFont *fontToUse = [UIFont fontWithName:fileNameOfBoldFont size:fontSize];
	return fontToUse;
}

static NSString *fileNameOfBookFont = @"ClearviewTextBook"; 
+(NSString *)appBookFontName 
{
	return fileNameOfBookFont;
}
+(UIFont *)appBookFontOfSize:(CGFloat)fontSize 
{
	UIFont *fontToUse = [UIFont fontWithName:fileNameOfBookFont size:fontSize];
	return fontToUse;
}

static NSString *fileNameOfMediumFont = @"ClearviewTextMedium"; 
+(NSString *)appMediumFontName {
	return fileNameOfMediumFont;
}
+(UIFont *)appMediumFontOfSize:(CGFloat)fontSize {
	UIFont *fontToUse = [UIFont fontWithName:fileNameOfMediumFont size:fontSize];
	return fontToUse;
}

static NSString *fileNameOfItalicFont = @"ClearviewText-MediumItalic";
+(NSString *)appItalicFontName {
	return fileNameOfItalicFont;
}
+(UIFont *)appItalicFontOfSize:(CGFloat)fontSize {
	UIFont *fontToUse = [UIFont fontWithName:fileNameOfItalicFont size:fontSize];
	return fontToUse;
}


@end
