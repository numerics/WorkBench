//
//  StreamView.h
//
//  Created by John Basile on 12/6/10.
//  Copyright 2010 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>


@interface StreamView : UIView 
{
	CATextLayer *attributedTextLayer;

}
- (void)rotate;
- (CTFontRef)newCustomFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes; 
- (void)setupAttributedTextLayerWithFont:(CTFontRef)font;

@end
