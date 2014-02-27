//
//  GlyphView.h
//  WorkBench
//
//  Created by John Basile on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GlyphView : UIView 
{
	CGFloat			fontPtSize;
	CGFloat			kernPtSize;
}
- (void)setGlyphSize:(CGFloat)gSize; 
- (void)setGlyphKern:(CGFloat)gKern; 
- (CGAffineTransform)transformToCartesian:(CGRect)rect;
@end
