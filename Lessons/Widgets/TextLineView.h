//
//  TextLineView.h
//  WorkBench
//
//  Created by John Basile on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextLineView : UIView 
{
	CGFloat			fontPtSize;
    
}
- (void)setTextSize:(CGFloat)gSize;                                                         // gSize should be pt size ie.e 12pt, etc..

@end
