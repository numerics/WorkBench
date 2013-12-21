//
//  CoreTextView.h
//  WorkBench
//
//  Created by John Basile on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlyphView.h"
#import "TextLineView.h"
#import "CTLabel.h"
#import "CTLinkButton.h"

@interface CoreTextView : UIView 
{
    TextLineView    *txLineLabel;
    CTLabel         *paragraphLabel;
    GlyphView       *ctLabel;
	UILabel         *txtLabel;
	UILabel         *fntLabel;
	UIButton		*drawTextButton;
	UISlider		*pointSize;             // Slider
	UISlider		*kernSize;              // Slider
}
@property (nonatomic, strong) GlyphView         *ctLabel;
@property (nonatomic, strong) TextLineView      *txLineLabel;
@property (nonatomic, strong) CTLabel     *paragraphLabel;

- (void)setUpView; 
-(void)buttonTapped:(id)sender;

@end
