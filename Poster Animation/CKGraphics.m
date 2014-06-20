#import <Foundation/Foundation.h>

#import "CKGraphics.h"

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

void drawLinearGradientFromTo(CGContextRef context, CGPoint startPt, CGPoint endPt, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0};
    CGRect rect = CGRectStandardize(CGRectMake(startPt.x, startPt.y, endPt.x - startPt.x, endPt.y - startPt.y));
    
	NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPt, endPt, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color)
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

void drawXPxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGFloat lineWidth, CGColorRef color)
{
    
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
}

void drawGrayPatchedHLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint,  CGFloat lineWidth)
{
	CGFloat width = endPoint.x - startPoint.x;
	if( width < 20.0)
	{
		drawXPxStroke(context, startPoint, endPoint, lineWidth, [UIColor whiteColor].CGColor);
		return;
	}
	drawXPxStroke(context, startPoint, endPoint, lineWidth, [UIColor whiteColor].CGColor);
	
	CGFloat dx = arc4random() % 11 * 0.1;
    dx = 0.4 * dx;
	CGFloat x = startPoint.x + (fabs(dx) * width);
	CGFloat grLngth = (dx < 0.0) ? 10.0 - (fabs(dx) * width) : 10.0 + (fabs(dx) * width);
	CGFloat ramp = (dx < 0.0) ? 10 - 0.7*(fabs(dx) * width) : 10 + 0.7*(fabs(dx) * width);
    CGFloat xr = x+ramp+grLngth;
	CGFloat xe = x + ramp + grLngth + ramp;
    
    if( xr > endPoint.x )
    {
        xr = endPoint.x;
        xe = endPoint.x;
    }
	else if( xe > endPoint.x )
	{
        xe = endPoint.x;
	}
    
	drawLinearGradientFromTo(context, CGPointMake(x, startPoint.y), CGPointMake(x+ramp, startPoint.y), [UIColor whiteColor].CGColor,[UIColor lightGrayColor].CGColor);
	drawXPxStroke(context, CGPointMake(x+ramp, startPoint.y), CGPointMake(xr, startPoint.y),lineWidth, [UIColor lightGrayColor].CGColor);
	drawLinearGradientFromTo(context, CGPointMake(xr, startPoint.y), CGPointMake(xe, startPoint.y), [UIColor lightGrayColor].CGColor,[UIColor whiteColor].CGColor);
    
}

void drawGrayPatchedVLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint,  CGFloat lineWidth)
{
	CGFloat height = endPoint.y - startPoint.y;
	if( height < 20.0)
	{
		drawXPxStroke(context, startPoint, endPoint, lineWidth, [UIColor whiteColor].CGColor);
		return;
	}
	drawXPxStroke(context, startPoint, endPoint, lineWidth, [UIColor whiteColor].CGColor);
	
	CGFloat dy = arc4random() % 11 * 0.1;
    dy = 0.4 * dy;
	CGFloat y = startPoint.y + (fabs(dy) * height);
	CGFloat grLngth = (dy < 0.0) ? 10.0 - (fabs(dy) * height) : 10.0 + (fabs(dy) * height);
	CGFloat ramp = (dy < 0.0) ? 10 - 0.7*(fabs(dy) * height) : 10 + 0.7*(fabs(dy) * height);
    CGFloat yr = y+ramp+grLngth;
	CGFloat ye = y + ramp + grLngth + ramp;
    if( yr > endPoint.y )
    {
        yr = endPoint.y;
        ye = endPoint.y;
    }
	else if( ye > endPoint.y )
	{
        ye = endPoint.y;
	}
	drawLinearGradientFromTo(context, CGPointMake(startPoint.x, y), CGPointMake(startPoint.x, startPoint.y+ramp), [UIColor whiteColor].CGColor,[UIColor lightGrayColor].CGColor);
	drawXPxStroke(context, CGPointMake(startPoint.x, startPoint.y + ramp), CGPointMake(startPoint.x, yr),lineWidth, [UIColor lightGrayColor].CGColor);
	drawLinearGradientFromTo(context, CGPointMake(startPoint.x, yr), CGPointMake(startPoint.x, ye), [UIColor lightGrayColor].CGColor,[UIColor whiteColor].CGColor);
    
}

CGRect rectFor1PxStroke(CGRect rect)
{
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

void drawRoundedRect(CGContextRef context, CGRect rect, CGFloat cornerRadius)
{
	CGPoint min = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGPoint mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGPoint max = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
	
	CGContextMoveToPoint(context, min.x, mid.y);
	CGContextAddArcToPoint(context, min.x, min.y, mid.x, min.y, cornerRadius);
	CGContextAddArcToPoint(context, max.x, min.y, max.x, mid.y, cornerRadius);
	CGContextAddArcToPoint(context, max.x, max.y, mid.x, max.y, cornerRadius);
	CGContextAddArcToPoint(context, min.x, max.y, min.x, mid.y, cornerRadius);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
}

CGGradientRef createGradientWithColors(NSArray *colors)
{
	return createGradientWithColorsAndLocations(colors, nil);
}

CGGradientRef createGradientWithColorsAndLocations(NSArray *colors, NSArray *locations)
{
	NSUInteger colorsCount = [colors count];
	if (colorsCount < 2)
	{
		return nil;
	}
	
	CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors objectAtIndex:0] CGColor]);
	
	CGFloat *gradientLocations = NULL;
	NSUInteger locationsCount = [locations count];
	if (locationsCount == colorsCount)
	{
		gradientLocations = (CGFloat *)malloc(sizeof(CGFloat) * locationsCount);
		for (NSUInteger i = 0; i < locationsCount; i++)
		{
			gradientLocations[i] = [[locations objectAtIndex:i] floatValue];
		}
	}
	
	NSMutableArray *gradientColors = [[NSMutableArray alloc] initWithCapacity:colorsCount];
	[colors enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop)
	{
		[gradientColors addObject:(id)[(UIColor *)object CGColor]];
	}];
	
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
	
	if (gradientLocations)
	{
		free(gradientLocations);
	}
	
	return gradient;
}


void drawGradientInRect(CGContextRef context, CGGradientRef gradient, CGRect rect)
{
	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
	CGContextRestoreGState(context);
}

void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    drawLinearGradient(context, rect, startColor, endColor);
    
    UIColor * glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35];
    UIColor * glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    
    drawLinearGradient(context, topHalf, glossColor1.CGColor, glossColor2.CGColor);
}

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight)
{
    CGRect arcRect = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - arcHeight, rect.size.width, arcHeight);
    
    CGFloat arcRadius = (arcRect.size.height/2) + (pow(arcRect.size.width, 2) / (8*arcRect.size.height));
    CGPoint arcCenter = CGPointMake(arcRect.origin.x + arcRect.size.width/2, arcRect.origin.y + arcRadius);
    
    CGFloat angle = acos(arcRect.size.width / (2*arcRadius));
    CGFloat startAngle = radians(180) + angle;
    CGFloat endAngle = radians(360) - angle;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, arcCenter.x, arcCenter.y, arcRadius, startAngle, endAngle, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    return path;
}

#pragma mark - CG Math

CGRect CGRectSetX(CGRect rect, CGFloat x)
{
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectSetY(CGRect rect, CGFloat y)
{
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}

CGRect CGRectSetWidth(CGRect rect, CGFloat width)
{
	return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}

CGRect CGRectSetHeight(CGRect rect, CGFloat height)
{
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}

CGRect CGRectSetOrigin(CGRect rect, CGPoint origin)
{
	return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectSetSize(CGRect rect, CGSize size)
{
	return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}

CGRect CGRectSetZeroOrigin(CGRect rect)
{
	return CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height);
}

CGRect CGRectSetZeroSize(CGRect rect)
{
	return CGRectMake(rect.origin.x, rect.origin.y, 0.0f, 0.0f);
}

CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize)
{
	// Probably a more efficient way to do this...
	CGFloat aspect = 1.0f;
	
	if (size.width > toSize.width) {
		aspect = toSize.width / size.width;
	}
	
	if (size.height > toSize.height) {
		aspect = fminf(toSize.height / size.height, aspect);
	}
	
	return CGSizeMake(size.width * aspect, size.height * aspect);
}


CGRect CGRectAddPoint(CGRect rect, CGPoint point) {
	return CGRectMake(rect.origin.x + point.x, rect.origin.y + point.y, rect.size.width, rect.size.height);
}

