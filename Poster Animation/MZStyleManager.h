//
//  MZStyleManager.h
//  Mozart
//
//  Created by John Basile on 5/4/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLabelMacros.h"
#import "MZButtonMacros.h"

#define kMZFontType @"font-type"
#define kMZTextColor @"text-color"
#define kMZFontSize @"font-size"
#define kMZBackgroundColor @"background-color"
#define kMZBorderColor @"border-color"
#define kMZTextAlignment @"text-alignment"
#define kMZTextAlignmentLeft @"left"
#define kMZTextAlignmentRight @"right"
#define kMZTextAlignmentCenter @"center"

#define kMZDropShadow @"dropShadow"
#define kMZShadowColor @"Shadow-color"
#define kMZShadowOpacity @"ShadowOpacity"
#define kMZShadowOffset @"ShadowOffset"
#define kMZShadowOffsetX @"ShadowOffsetX"
#define kMZShadowOffsetY @"ShadowOffsetY"
#define kMZShadowRadius @"ShadowRadius"
#define kMZOpacity @"opacity"						// Usually, 1.0, 0.0 = will clear the inside of the button
#define kMZGradient @"gradient"						// Button has a gradient look (convect), from start-color, to end-color
#define kMZStartColor @"start-color"				// carefull choice of colors is what gives it the convect vs concave look
#define kMZEndColor @"end-color"
#define kMZInvGradient @"inverseGradient"			// When selected button has an gradient look (concave), from point1-color, to point2-color
#define kMZPoint1Color @"point1-color"				// carefull choice of colors is what gives it the convect vs concave look
#define kMZPoint2Color @"point2-color"
#define kMZLinkIcon @"addLinkIcon"					// TBD this will be a button that links to a menu/ or other control
#define kMZFillColor @"fill-color"					// If Not a gradient Button, then this is the fill color of the button
#define kMZHighliteColor @"highlite-color"			// If Not a gradient Button, then this is the highlite color of the button
#define kMZCornerRadius @"cornerRadius"				// Rectangle buttons can have the 'RoundedRect' by setting the cornerRadius
#define kMZLineWidthRadius @"lineWidth"
#define kMZLineOpacity @"lineOpacity"

@interface MZStyleManager : NSObject

// Labels
+ (NSString *)getTextColorForLabelType:(kMZLabelType) labelType;
+ (float)getTextSizeForLabelType:(kMZLabelType) labelType;
+ (UIFont *)getFontAndSizeForLabel:(NSString *)keyType;
+ (NSTextAlignment)getTextAlignmentForLabel:(NSString *)keyType;
+ (UIColor *)getTextColorForLabel:(NSString *)keyType;
+ (NSString *)getBackgroundColorForLabelType:(kMZLabelType) labelType;
+ (NSString *)getFontTypeLabelType:(kMZLabelType) labelType;
+ (NSString *)getDropShadowForLabelType:(kMZLabelType) labelType;
+ (float)getOpacityForLabelType:(kMZLabelType) labelType;
+ (float)getShadowOpacityForLabelType:(kMZLabelType) labelType;
+ (float)getShadowOffXsetForLabelType:(kMZLabelType) labelType;
+ (float)getShadowOffYsetForLabelType:(kMZLabelType) labelType;
+ (NSTextAlignment)getTextAlignmentForLabelType:(kMZLabelType) labelType;
+ (NSString *)getShadowColorForLabelType:(kMZLabelType) labelType;

// Buttons
+ (NSString *)getTextColorForButtonType:(kMZButtonType) buttonType;
+ (float)getTextSizeForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getBackgroundColorForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getFontTypeForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getBorderColorForButtonType:(kMZButtonType) buttonType;
+ (NSTextAlignment)getTextAlignmentForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getInvGradientForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getPoint1ColorForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getPoint2ColorForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getHighliteColorForButtonType:(kMZButtonType) buttonType;

+ (NSString *)getStartColorForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getEndColorForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getDropShadowForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getGradientForButtonType:(kMZButtonType) buttonType;
+ (float)getOpacityForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getShadowColorForButtonType:(kMZButtonType) buttonType;
+ (float)getShadowOpacityForButtonType:(kMZButtonType) buttonType;
+ (float)getShadowOffsetForButtonType:(kMZButtonType) buttonType;
+ (float)getShadowRadiusForButtonType:(kMZButtonType) buttonType;
+ (float)getCornerRadiusForButtonType:(kMZButtonType) buttonType;
+ (float)getLineWidthForButtonType:(kMZButtonType) buttonType;
+ (float)getLineOpacityForButtonType:(kMZButtonType) buttonType;

+ (NSString *)getLinkForButtonType:(kMZButtonType) buttonType;
+ (NSString *)getFillColorForButtonType:(kMZButtonType) buttonType;
@end
