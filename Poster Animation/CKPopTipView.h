//
//  CKPopTipView.h
//
//  Created by Chris Miles on 18/07/10.
//  Copyright (c) Chris Miles 2010-2012.
//
//  Modified by John Basile on 5/2/13.
//  Copyright (c) 2013 Numerics. All rights reserved.


/** \brief	Display a speech bubble-like popup on screen, pointing at the
			designated view or button.
 
	A UIView subclass drawn using core graphics. Pops up (optionally animated)
	a speech bubble-like view on screen, a rounded rectangle with a gradiant
	fill containing a specified text message, drawn with a pointer dynamically
	positioned to point at the center of the designated button or view.
 
 Example 1 - point at a UIBarButtonItem in a nav bar:
 
	- (void)showPopTipView {
		NSString *message = @"Start by adding a waterway to your favourites.";
		CKPopTipView *popTipView = [[CKPopTipView alloc] initWithMessage:message];
		popTipView.delegate = self;
		[popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
		
		self.myPopTipView = popTipView;
		[popTipView release];
	}

	- (void)dismissPopTipView {
		[self.myPopTipView dismissAnimated:NO];
		self.myPopTipView = nil;
	}

 
	#pragma mark CKPopTipViewDelegate methods
	- (void)popTipViewWasDismissedByUser:(CKPopTipView *)popTipView {
		// User can tap CKPopTipView to dismiss it
		self.myPopTipView = nil;
	}

 Example 2 - pointing at a UIButton:

	- (IBAction)buttonAction:(id)sender 
    {
		// Toggle popTipView when a standard UIButton is pressed
		if (nil == self.roundRectButtonPopTipView) 
        {
			self.roundRectButtonPopTipView = [[[CKPopTipView alloc] initWithMessage:@"My message"] autorelease];
			self.roundRectButtonPopTipView.delegate = self;

			UIButton *button = (UIButton *)sender;
			[self.roundRectButtonPopTipView presentPointingAtView:button inView:self.view animated:YES];
		}
		else {
			// Dismiss
			[self.roundRectButtonPopTipView dismissAnimated:YES];
			self.roundRectButtonPopTipView = nil;
		}	
	}

	#pragma mark CKPopTipViewDelegate methods
	- (void)popTipViewWasDismissedByUser:(CKPopTipView *)popTipView {
		// User can tap CKPopTipView to dismiss it
		self.roundRectButtonPopTipView = nil;
	}
 
 */

#import <UIKit/UIKit.h>

typedef enum {
    PointDirectionAny = 0,
	PointDirectionUp,
	PointDirectionDown,
} PointDirection;


typedef enum
{
    CMPopTipAnimationSlide = 0,
    CMPopTipAnimationPop
} CMPopTipAnimation;


@protocol CKPopTipViewDelegate;

@interface CKPopTipView : UIView
@property (nonatomic, assign)			BOOL					noBubble;

@property (nonatomic, strong)			UIColor					*backgroundColor;
@property (nonatomic, weak)				id<CKPopTipViewDelegate>	delegate;
@property (nonatomic, assign)			BOOL					disableTapToDismiss;
@property (nonatomic, assign)			BOOL					dismissTapAnywhere;
@property (nonatomic, strong)			NSString				*title;
@property (nonatomic, strong)			NSString				*message;
@property (nonatomic, strong)           UIView	                *customView;
@property (nonatomic, strong, readonly)	id						targetObject;
@property (nonatomic, strong)			UIColor					*titleColor;
@property (nonatomic, strong)			UIFont					*titleFont;
@property (nonatomic, strong)			UIColor					*textColor;
@property (nonatomic, strong)			UIFont					*textFont;
@property (nonatomic, assign)			NSTextAlignment			titleAlignment;
@property (nonatomic, assign)			NSTextAlignment			textAlignment;
@property (nonatomic, assign)           BOOL                    has3DStyle;
@property (nonatomic, strong)			UIColor					*borderColor;
@property (nonatomic, assign)           CGFloat                 cornerRadius;
@property (nonatomic, assign)			CGFloat					borderWidth;
@property (nonatomic, assign)           BOOL                    hasShadow;
@property (nonatomic, assign)           CMPopTipAnimation       animation;
@property (nonatomic, assign)           CGFloat                 maxWidth;
@property (nonatomic, assign)           PointDirection          preferredPointDirection;
@property (nonatomic, assign)           BOOL                    hasGradientBackground;

/* Contents can be either a message or a UIView */
- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow;
- (id)initWithMessage:(NSString *)messageToShow;
- (id)initWithCustomView:(UIView *)aView;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal;
- (PointDirection) getPointDirection;

@end


@protocol CKPopTipViewDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(CKPopTipView *)popTipView;
@end
