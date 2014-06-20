#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
void drawLinearGradientFromTo(CGContextRef context, CGPoint startPt, CGPoint endPt, CGColorRef startColor, CGColorRef endColor);
void drawGrayPatchedHLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint,  CGFloat lineWidth);
void drawGrayPatchedVLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint,  CGFloat lineWidth);

CGRect rectFor1PxStroke(CGRect rect);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
void drawXPxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGFloat lineWidth, CGColorRef color);
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

static inline double radians (double degrees) { return degrees * M_PI/180; }

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);

void drawRoundedRect(CGContextRef context, CGRect rect, CGFloat cornerRadius);

extern void SSDrawRoundedRect(CGContextRef context, CGRect rect, CGFloat cornerRadius);

CGGradientRef createGradientWithColors(NSArray *colors);
CGGradientRef createGradientWithColorsAndLocations(NSArray *colors, NSArray *locations);
void drawGradientInRect(CGContextRef context, CGGradientRef gradient, CGRect rect);

CGRect CGRectSetX(CGRect rect, CGFloat x);
CGRect CGRectSetY(CGRect rect, CGFloat y);
CGRect CGRectSetWidth(CGRect rect, CGFloat width);
CGRect CGRectSetHeight(CGRect rect, CGFloat height);
CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);
CGRect CGRectSetSize(CGRect rect, CGSize size);
CGRect CGRectSetZeroOrigin(CGRect rect);
CGRect CGRectSetZeroSize(CGRect rect);
CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize);
CGRect CGRectAddPoint(CGRect rect, CGPoint point);
