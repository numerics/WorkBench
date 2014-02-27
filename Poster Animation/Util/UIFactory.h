//
//  UIFactory.h
//  UIPresentations
//
//  Created by John Basile.
//  Copyright 2010 Numerics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDayView.h"

@interface UIFactory : NSObject
{
	NSString        *appPrefix;
	UIColor         *backgroundColor;
    NSDictionary    *commonDict;
    NSDictionary    *calendarDict;

	UIImage			*dividerImage;

	UIColor			*linkColorNormal;
	UIColor			*linkColorHighlight;
	UIColor			*greyTextColor;
	UIColor			*lightGreyTextColor;
	UIImage			*loadingBackgroundImage;
	
}
@property (nonatomic, strong) NSDictionary  *calendarDict;
@property (nonatomic, readonly) BOOL isPortraitOrientation;
@property (nonatomic, readonly) BOOL isLandscapeOrientation;

@property (nonatomic, strong) NSString      *appPrefix;
@property (nonatomic, strong) UIColor       *backgroundColor;
@property (nonatomic, strong) NSDictionary  *commonDict;
@property (nonatomic, strong) NSArray       *abstractObjects;


@property (nonatomic, strong) UIImage		*dividerImage;

@property (nonatomic, strong) UIColor		*linkColorNormal;
@property (nonatomic, strong) UIColor		*linkColorHighlight;
@property (nonatomic, strong) UIColor		*greyTextColor;
@property (nonatomic, strong) UIColor		*lightGreyTextColor;

@property (nonatomic, strong) UIImage		*loadingBackgroundImage;

@property (nonatomic) CGFloat titleLineHeightLarge;
@property (nonatomic) CGFloat titleLineHeightSmall;
@property (nonatomic) CGFloat titleMaxHeight;


//
// Returns the singleton reference to the UIFactory.
//
+ (UIFactory*) sharedInstance;

- (UIColor *)grayColor:(CGFloat)gray alpha:(CGFloat)alpha;

- (UIColor *) getDayViewColors:(NSString *)property;

-(UIColor *) getBackgroundFromProperties:(NSString *)property;

- (NSDictionary *) getTargetDict:(NSString *)viewController;

- (NSString *) getClassTitle:(NSString *)viewController;

- (id) loadClazz:(NSString *)viewController;

- (id) loadProperty: (NSString*)viewController property:(NSString *)key;

- (void) loadDefaultPropertyValues: (id)aObj;

- (void) loadDefaultPropertyValues:(id)aObj ObjectName:(NSString *)objName;

- (void)loadButtonProperties:(NSDictionary *)buttonInfo button:(id)obj;

- (void)loadLabelProperties:(NSDictionary *)labelInfo label:(UILabel *)lbl;

- (void)loadImageViewProperties:(NSDictionary *)imageViewInfo imageView:(UIImageView *)imv;

- (UIViewController *)loadControllerWithFactory:(NSString *)controllerName;

- (UIView *)loadViewWithFactory:(NSString *)viewName withFrame:(CGRect)frame;

- (NSDictionary *) getCalendarLayoutProperties;
- (NSDictionary *) getCalendarViewProperties;
- (NSDictionary *) getCalendarDayViewProperties;
- (CalendarDayView *)initializeCalendarDayView:(CGRect)frame;

//- (BOOL)instructions:(id)controller instructName:(NSString *)name;

- (BOOL) isPortraitOrientation;

- (BOOL) isLandscapeOrientation;

- (UIFont*) fontWithSize:(CGFloat)fontSize bold:(BOOL)bold italic:(BOOL)italic;

- (UILabel *) stdTitleLabelWithText:(NSString*)text;

- (UILabel *) stdLabelWithText:(NSString*)text;

- (UILabel *) labelWithColor:(UIColor *)Color selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

- (UILabel *) labelWithColor:(UIColor *)color selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold text:(NSString*)text;

- (UILabel *) labelWithColor:(UIColor *)color
			   selectedColor:(UIColor *)selectedColor
					fontSize:(CGFloat)fontSize
						bold:(BOOL)bold
					  italic:(BOOL)italic
						text:(NSString*)text;

- (UITextView*) textViewWithColor:(UIColor *)Color fontSize:(CGFloat)fontSize bold:(BOOL)bold;

//
// Creates a new, autoreleased text field. The caller is responsible for retaining ownership.
//
- (UITextField*) textFieldWithFrame:(CGRect)frame;

- (NSString *) getFormattedRuntimeString:(NSInteger) runtime;

- (NSString *) stringWithTimeInterval:(NSTimeInterval) timeInterval;

//
// Returns the size of the given title taking into account a font size reduction
// if the title needs to wrap.
//
- (CGSize) titleSize:(NSString*)title withWidth:(CGFloat)width outFont:(UIFont**)outFont;

//
// Lays out the given title label at the given origin/point respecting the maximum width.
// Returns the resulting frame of the label.
//
- (CGRect) layoutTitleLabel:(UILabel*)titleLabel atPoint:(CGPoint)point withMaxWidth:(CGFloat)maxWidth;

//
// Draws the given title at the given origin/point respecting the maximum width.
// Returns the resulting frame of the label.
//
- (CGRect) drawTitle:(NSString*)title atPoint:(CGPoint)point withMaxWidth:(CGFloat)maxWidth;

//
// Toggles the selected state of a checkbox button.
//
- (void) checkboxToggleSelection:(id)source;

//
// sets the selected state of the checkbox
//
- (void) checkboxSetSelection:(id)source selected:(BOOL)selected;

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
- (void) adjustButtonSizeToFitText:(UIButton*)button;

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
- (void) adjustButtonSizeToFitText:(UIButton*)button withInsets:(UIEdgeInsets)insets;

//
// Corrects the width and height of the given UILabel to accomodate its text on a single line.
//
- (void) adjustLabelSizeToFitText:(UILabel*)label;

//
// Corrects the height of the given UILabel to accomodate its text content relative to its current width.
//
- (void) adjustLabelHeightToFitText:(UILabel*)label;

//
// Returns the ideal height for the given text string.
//
- (CGFloat) idealStringHeight:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font;

//
// Returns the ideal size for the given text string.
//
- (CGSize) idealStringSize:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font;

//
// A helper method to set just the x-position of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setX:(CGFloat)xPos;

//
// A helper method to set just the y-position of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setY:(CGFloat)yPos;

//
// A helper method to set just the origin of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setOrigin:(CGPoint)origin;

//
// A helper method to set just the width of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setWidth:(CGFloat)width;

//
// A helper method to set just the height of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setHeight:(CGFloat)height;

//
// A helper method to set just the size of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setSize:(CGSize)size;

//
// A helper method to set just the accessibility label and hint of the given view.
//
- (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint;

//
// A helper method to set just the accessibility label and hint of the given view.
//
- (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint andValue:(NSString*)value;

//
// A helper method to convert the string into an accessible string such that each letter is spoken separately.
//
- (NSString*) letterizeString:(NSString*)aString;

//
// Splits the given string on words and capitalizes each word.
//
- (NSString*) capitalizeWordsInString:(NSString*)str;

//
// A helper method to set just the line break mode of the given UIButton.
//
- (void) button:(UIButton*)button setLineBreakMode:(UILineBreakMode)lineBreakMode;

//
// A helper method to set just the text alignment of the given UIButton.
//
- (void) button:(UIButton*)button setTextAlignment:(UITextAlignment)textAlignment;

//
// A helper method to set just the font of the given UIButton.
//
- (void) button:(UIButton*)button setFont:(UIFont*)font;

//
// A helper method to return the font of a UIButton (this is done to reduce the number of compiler warnings).
//
- (UIFont*) buttonGetFont:(UIButton*)button;

//
// Loads the nib with the given name and return the first UIView.
//
- (UIView*) loadViewFromNibNamed:(NSString*)nibName owner:(id)owner;

- (UIButton*) replaceButton:(UIButton*)src withButton:(UIButton*)replacement;

- (UIView*) replaceView:(UIView*)src withView:(UIView*)replacement;

//
// Returns an autoreleased UIAccessibilityElement.
//
- (id) accessibleElementWithContainer:(id)container frame:(CGRect)frame label:(NSString*)label hint:(NSString*)hint;

//
// A helper method to defocus all subviews of a view
//
+ (void) resignFirstRespondersOf:(UIView*)parentView;

//
// A helper method to defocus all subviews of a view and a given class.  For example [UITextEntry class] if you only want to close onscreen keyboards.
//
+ (void) resignFirstRespondersOf:(UIView*)parentView ofClass:(Class)ofClass;


//
// Displays the following message in a standard UIAlertView.
//
- (void) alertMessage:(NSString*)message;

//
// A generic handler to deal with not implemented features.
//
- (void) notYetImplementedHandler:(id)source;

@end

@interface UIMutableFont : UIFont
{
	CGFloat _ascender;
	CGFloat _capHeight;
	CGFloat _descender;
	NSString* _familyName;
	NSString* _fontName;
	CGFloat _leading;
	CGFloat _pointSize;
	CGFloat _xHeight;
}

- (id) initWithFont:(UIFont*)font;

@end
	


