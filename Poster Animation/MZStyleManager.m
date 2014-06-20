//
//  MZStyleManager.m
//  Mozart
//
//  Created by John Basile on 5/4/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "MZStyleManager.h"


@interface MZStyleManager ()

@end


@implementation MZStyleManager

static NSDictionary *stlyeDict;

- (id) init {
    self = [super init];
    if (self)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mozartStyle" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        stlyeDict = [string objectFromJSONString];
    }
    return self;
}

// ************************ LABELS
+ (UIFont *)getFontAndSizeForLabel:(NSString *)keyType
{
	UIFont *fnt;
	
	fnt = [[UIFactory sharedInstance] fontAtKey:keyType];
	return( fnt );
}

+ (NSTextAlignment)getTextAlignmentForLabel:(NSString *)keyType
{
	NSString *align = [keyType substringFrom:2 to:3];

	if ([align isEqualToString:@"C"] )
		return NSTextAlignmentCenter;
	else if ([align isEqualToString:@"R"] )
		return NSTextAlignmentRight;
	else
		return NSTextAlignmentLeft;
}

+ (UIColor *)getTextColorForLabel:(NSString *)keyType
{
    UIColor *color;
	color = [[UIFactory sharedInstance] fontColorAtKey:keyType];
	return( color );
	
}

+ (NSString *)getTextColorForLabelType:(kMZLabelType) labelType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZTextColor];
}

+ (float)getTextSizeForLabelType:(kMZLabelType) labelType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZFontSize] floatValue];
}

+ (NSString *)getBackgroundColorForLabelType:(kMZLabelType) labelType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZBackgroundColor];
}

+ (NSString *)getFontTypeLabelType:(kMZLabelType) labelType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZFontType];
}

+ (NSString *)getDropShadowForLabelType:(kMZLabelType) labelType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZDropShadow];
}

+ (float)getOpacityForLabelType:(kMZLabelType) labelType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZOpacity] floatValue];
}

+ (float)getShadowOpacityForLabelType:(kMZLabelType) labelType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZShadowOpacity] floatValue];
}

+ (float)getShadowOffXsetForLabelType:(kMZLabelType) labelType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZShadowOffsetX] floatValue];
	
}
+ (float)getShadowOffYsetForLabelType:(kMZLabelType) labelType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZShadowOffsetY] floatValue];
    
}

+ (NSString *)getShadowColorForLabelType:(kMZLabelType) labelType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZShadowColor];
}

+ (NSTextAlignment)getTextAlignmentForLabelType:(kMZLabelType) labelType
{
    if ([[[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZTextAlignment] isEqualToString:kMZTextAlignmentCenter])
        return NSTextAlignmentCenter;
    else if ([[[[stlyeDict objectOrNilForKey:kMZStyleForLabels] objectOrNilForKey:[[NSNumber numberWithInt:labelType] stringValue]] objectOrNilForKey:kMZTextAlignment] isEqualToString:kMZTextAlignmentRight])
        return NSTextAlignmentRight;
    else
        return NSTextAlignmentLeft;
}

// ************************ BUTTONS
+ (NSString *)getTextColorForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZTextColor];
}

+ (float)getTextSizeForButtonType:(kMZButtonType) buttonType {
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZFontSize] floatValue];
}

+ (NSString *)getBackgroundColorForButtonType:(kMZButtonType) buttonType {
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZBackgroundColor];
}

+ (NSString *)getFontTypeForButtonType:(kMZButtonType) buttonType {
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZFontType];
}

+ (NSString *)getBorderColorForButtonType:(kMZButtonType) buttonType {
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZBorderColor];
}

+ (NSTextAlignment)getTextAlignmentForButtonType:(kMZButtonType) buttonType
{
    if ([[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZTextAlignment] isEqualToString:kMZTextAlignmentCenter])
        return NSTextAlignmentCenter;
    else if ([[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZTextAlignment] isEqualToString:kMZTextAlignmentRight])
        return NSTextAlignmentRight;
    else
        return NSTextAlignmentLeft;
}

+ (NSString *)getHighliteColorForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZHighliteColor];
}

+ (NSString *)getStartColorForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZStartColor];
}

+ (NSString *)getEndColorForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZEndColor];
}

+ (NSString *)getPoint1ColorForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZPoint1Color];
}

+ (NSString *)getPoint2ColorForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZPoint2Color];
}

+ (NSString *)getDropShadowForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZDropShadow];
}

+ (NSString *)getGradientForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZGradient];
}

+ (NSString *)getInvGradientForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZInvGradient];
}

+ (float)getOpacityForButtonType:(kMZButtonType) buttonType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZOpacity] floatValue];
}

+ (float)getShadowOpacityForButtonType:(kMZButtonType) buttonType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZShadowOpacity] floatValue];
}
+ (float)getLineOpacityForButtonType:(kMZButtonType) buttonType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZLineOpacity] floatValue];
}

+ (float)getShadowOffsetForButtonType:(kMZButtonType) buttonType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZShadowOffset] floatValue];
}

+ (float)getShadowRadiusForButtonType:(kMZButtonType) buttonType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZShadowRadius] floatValue];
}

+ (float)getCornerRadiusForButtonType:(kMZButtonType) buttonType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZCornerRadius] floatValue];
}
+ (float)getLineWidthForButtonType:(kMZButtonType) buttonType
{
    return [[[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZLineWidthRadius] floatValue];
}

+ (NSString *)getLinkForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZLinkIcon];
}

+ (NSString *)getFillColorForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZFillColor];
}

+ (NSString *)getShadowColorForButtonType:(kMZButtonType) buttonType
{
    return [[[stlyeDict objectOrNilForKey:kMZStyleForButtons] objectOrNilForKey:[[NSNumber numberWithInt:buttonType] stringValue]] objectOrNilForKey:kMZShadowColor];
}

@end
