//
//  TextLayers.h
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface TextLayers : UIView 
{
	CATextLayer		*attributedTextLayer;
	CATextLayer		*normalTextLayer;
	UIButton		*animateButton;
}
- (void)setUpView; 
- (void)setupAttributedTextLayerWithFont:(CTFontRef)font;
- (CTFontRef)newCustomFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes; 

@end
