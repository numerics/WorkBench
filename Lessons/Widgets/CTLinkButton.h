//
//  CTLinkButton.h
//
//  Created by John Basile on 4/25/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>


@interface CTLinkButton : UIView 
{
	NSString	*link;
	NSString	*title;
	UIButton	*label;
	NSString	*font;
	UIButton	*linkdButton;
	
	CGFloat		fontSize;
}
@property (readonly) UIButton *label;
@property (strong, readwrite) NSString *link;
@property (strong, readwrite) NSString *title;
@property (strong, readwrite) NSString *font;
@property (readwrite) CGFloat fontSize;

-(UIButton *)linkdButton;
-(void) setLinkdButton:(UIButton *)button;
-(void)buildStringLayerWithFont:(NSString *)ft andSize:(CGFloat)fs;
-(void)buildStringLayerWithFont:(NSString *)ft andSize:(CGFloat)fs usingDelegate:(id)theDelegate theSelector:(SEL)requestSelector;
@end
