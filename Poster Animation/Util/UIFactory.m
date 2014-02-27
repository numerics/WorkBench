//
//  UIFactory.m
//  UIPresentations
//
//  Created by John Basile.
//  Copyright 2010 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFactory.h"
#import "UIUtil.h"
#import <objc/runtime.h>
#import "StringFunctions.h"
#import "NSString+Additions.h"
#import "CHLookAndFeelManager.h"

@interface UIFactory()

@property (nonatomic, strong) UILabel* titleLabelPrototypeLarge;
@property (nonatomic, strong) UILabel* titleLabelPrototypeSmall;

@end

@implementation UIFactory

@synthesize appPrefix,backgroundColor,commonDict,abstractObjects,calendarDict;
@synthesize dividerImage;

@synthesize titleLineHeightLarge;
@synthesize titleLineHeightSmall;
@synthesize titleMaxHeight;

@synthesize loadingBackgroundImage;


@synthesize linkColorNormal, linkColorHighlight, greyTextColor, lightGreyTextColor;

static UIFactory* UI_FACTORY_INSTANCE = nil;


//
// Class initializer. Called only once before the class receives its first message.
//
+ (void)initialize
{
	UI_FACTORY_INSTANCE  = [[UIFactory alloc] init];
}

//
// Returns the singleton reference to the UIFactory.
//
+ (UIFactory*) sharedInstance
{
	return UI_FACTORY_INSTANCE;
}

-(NSDictionary *) getTargetDict:(NSString *)viewController
{
    NSDictionary *viewItem = [self.commonDict objectForKey:viewController];
    NSDictionary *target = [viewItem objectForKey:self.appPrefix];
    return target;
}


-(NSString *) getClassTitle:(NSString *)viewController
{
    NSString *newViewController = nil;
    NSDictionary *targetDict = [self getTargetDict:viewController];
    
    newViewController = [targetDict objectForKey:@"sClass"];
    if( newViewController)
        return newViewController;
    else
        return viewController;
}

-(id) loadClazz:(NSString *)viewController
{
    NSString *newViewController = [self getClassTitle:viewController];
    Class clazz = nil;
    
    if( newViewController)
        clazz = [NSClassFromString(newViewController) class];
    else
        clazz = [NSClassFromString(viewController) class];
    
    return clazz;
}

static const char * getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL)
    {
        if (attribute[0] == 'T' && attribute[1] != '@')
        {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2)
        {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@')
        {
            // it's another ObjC object type:
            const char *answer = (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
            return answer;
        }
    }
    return "";
}


-(id) loadProperty: (NSString*)viewController property:(NSString *)key
{
    NSDictionary *targetDict = [self getTargetDict:viewController];
    return (id)([targetDict objectForKey:key]);
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
// removes warning due to ARC not handling PerfomSelector abstraction methods
// See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

-(void) loadDefaultPropertyValues: (id)aObj
{
    const char * cName = class_getName([aObj class]);
    NSString *objName = [NSString stringWithUTF8String:cName];
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([aObj class], &propertyCount);
    NSMutableArray *arrNames = [NSMutableArray array];
    NSMutableArray *arrTypes = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        if( name)
        {
            const char *propType = getPropertyType(property);
            [arrNames addObject:[NSString stringWithUTF8String:name]];
            [arrTypes addObject:[NSString stringWithUTF8String:propType]];
        }
    }
    free(properties);
    
    NSDictionary *targetDict = [self getTargetDict:objName];
    
    for (int i = 0; i < [arrNames count]; i++)
    {
        NSString* pName = [arrNames objectAtIndex:i];
        id newValue = (id)[targetDict valueForKey:pName];
		if( newValue)
		{
            NSString* tName = [arrTypes objectAtIndex:i];
            if( [tName isEqualToString:@"UITextView"] || [tName isEqualToString:@"UILabel"] || [tName isEqualToString:@"UITextField"])
            {
                [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.text",pName]];
            }
            else if ([tName isEqualToString:@"UIImageView"])
            {
                UIImage *im = [UIImage imageNamed: newValue];
                [aObj setValue:im forKeyPath:[NSString stringWithFormat:@"%@.image",pName]];
            }
            else
                [aObj setValue:newValue forKey:pName];
		}
    }
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
// removes warning due to ARC not handling PerfomSelector abstraction methods
// See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

-(void) loadDefaultPropertyValues:(id)aObj ObjectName:(NSString *)objName
{
    Class clazz = nil;
	clazz = [NSClassFromString(objName) class];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([clazz class], &propertyCount);
    NSDictionary *targetDict = [self getTargetDict:objName];
    
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        if( name)
        {
            NSString* pName = [NSString stringWithUTF8String:name];
            id newValue = (id)[targetDict valueForKey:pName];
            if( newValue)
            {
                const char *attributes = property_getAttributes(property);
                NSString *type = [NSString stringWithUTF8String:attributes];
                if( [type occurencesOfSubstring:@"UITextView"] )
                {
                    [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.text",pName]];
                }
                else if( [type occurencesOfSubstring:@"UILabel"])
                {
                    [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.text",pName]];
                }
                else if( [type occurencesOfSubstring:@"UITextField"])
                {
                    [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.text",pName]];
                }
                else if( [type occurencesOfSubstring:@"UIImageView"])
                {
                    UIImage *im = [UIImage imageNamed: newValue];
                    [aObj setValue:im forKeyPath:[NSString stringWithFormat:@"%@.image",pName]];
                }
                else if( [type occurencesOfSubstring:@"UIButton"])
                {
                    [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.titleLabel.text",pName]];
                }
                else
                {
                    [aObj setValue:newValue forKey:pName];
                }
            }
        }
    }
    free(properties);
}

#pragma clang diagnostic pop
- (void)loadButtonProperties:(NSDictionary *)buttonInfo button:(UIButton *)btn
{
	CGRect rect = CGRectZero;
	id obj = nil;
	
	obj = [buttonInfo objectForKey:@"x"];
	if( obj )										// test if frame is being set
	{
		rect.origin.x = [obj intValue];
		rect.origin.y =  [[buttonInfo objectForKey: @"y"] intValue];
		rect.size.width = [[buttonInfo objectForKey: @"width"] intValue];
		rect.size.height = [[buttonInfo objectForKey: @"height"] intValue];
		btn.frame = rect;
	}
	
	NSString *imageName = [buttonInfo objectForKey: @"image"];
	if(imageName)
	{
		UIImage *image = [[UIImage imageNamed: imageName] stretchableImageWithLeftCapWidth: 3.5 topCapHeight: 0.0];
		[btn setBackgroundImage:image forState:UIControlStateNormal];
	}
	
	NSString *title = [buttonInfo objectForKey: @"title"];
	if(title)
	{
		[btn setTitle:title forState:UIControlStateNormal];
	}
	
	NSString *color = [buttonInfo objectForKey: @"titleColor"];
	if(color)
	{
		[btn setTitleColor:[[CHLookAndFeelManager sharedLookAndFeelManager] colorAtKey:color] forState:UIControlStateNormal];
	}
	
	NSString *bcolor = [buttonInfo objectForKey: @"backgroundColor"];
	if(bcolor)
	{
		btn.backgroundColor = [[CHLookAndFeelManager sharedLookAndFeelManager] colorAtKey:bcolor];
	}
}

- (void)loadLabelProperties:(NSDictionary *)labelInfo label:(UILabel *)lbl
{
	CGRect rect = CGRectZero;
	id obj = nil;
	
	obj = [labelInfo objectForKey:@"x"];
	if( obj )										// test if frame is being set
	{
		rect.origin.x = [obj intValue];
		rect.origin.y =  [[labelInfo objectForKey: @"y"] intValue];
		rect.size.width = [[labelInfo objectForKey: @"width"] intValue];
		rect.size.height = [[labelInfo objectForKey: @"height"] intValue];
		lbl.frame = rect;
	}
	
	int i = [[labelInfo objectForKey: @"textAlignment"] intValue];
	lbl.textAlignment = i;												// UITextAlignmentLeft, default
	
	NSString *text = [labelInfo objectForKey: @"text"];
	if(text)
	{
		lbl.text = text;
	}
	
	NSString *color = [labelInfo objectForKey: @"titleColor"];
	if(color)
	{
		[lbl setTextColor:[[CHLookAndFeelManager sharedLookAndFeelManager] colorAtKey:color]];
	}
	
	NSString *bcolor = [labelInfo objectForKey: @"backgroundColor"];
	if(bcolor)
	{
		lbl.backgroundColor = [[CHLookAndFeelManager sharedLookAndFeelManager] colorAtKey:bcolor];
	}
}

- (void)loadImageViewProperties:(NSDictionary *)imageViewInfo imageView:(UIImageView *)imv
{
	CGRect rect = CGRectZero;
	id obj = nil;
	
	NSString *imageName = [imageViewInfo objectForKey:@"image"];
	imv.image = [UIImage imageNamed: imageName];
	
	obj = [imageViewInfo objectForKey:@"x"];
	if( obj )																	// test if frame is being set
	{
		rect.origin.x = [obj intValue];
		rect.origin.y =  [[imageViewInfo objectForKey: @"y"] intValue];
		rect.size.width = [[imageViewInfo objectForKey: @"width"] intValue];
		rect.size.height = [[imageViewInfo objectForKey: @"height"] intValue];
		imv.frame = rect;
	}
}

- (UIView *)loadViewWithFactory:(NSString *)viewName withFrame:(CGRect)frame
{
    Class clazz = [self loadClazz:viewName];
	
	UIView *instance = [[clazz alloc] initWithFrame:frame];
	return instance;
}

- (UIViewController *)loadControllerWithFactory:(NSString *)controllerName                  // example, "AboutViewController"
{
    Class clazz = nil;
    UIViewController *instance = nil;
    NSString *nibName = [self getClassTitle:controllerName];                                // will return the subclass name if one exist, eg: "BBAboutViewController"
    
    if( ![controllerName isEqualToString:nibName] )                                         // if we have a subclass, test if its using a subclassed Nib
    {
        if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil)            // test, see if the nib file exist for eg: "BBAboutViewController"
        {                                                                                   // the nib file "BBAboutViewController" is found
			clazz = [NSClassFromString(nibName) class];										// will get the ViewController's Sub-Class, BBAboutViewController
            instance = [[clazz alloc] initWithNibName:nibName bundle:nil];                  // and initialize an instance of "BBAboutViewController" with "BBAboutViewController.xib" file
        }
        else                                                                                // The nib file BBAboutViewController was NOT found
        {
 			clazz = [NSClassFromString(nibName) class];										// will get the ViewController's Sub-Class, BBAboutViewController
            instance = [[clazz alloc] initWithNibName:controllerName bundle:nil];           // So, initialize an instance of "BBAboutViewController" with "AboutViewController.xib" file
        }
    }
    else
    {
		clazz = [NSClassFromString(controllerName) class];									// will get the ViewController's Class, AboutViewController
        instance = [[clazz alloc] initWithNibName:nibName bundle:nil];                      // initialize an instance of "AboutViewController" with "AboutViewController.xib" file
    }
	
    return instance;
}

-(UIColor *) getBackgroundFromProperties:(NSString *)property
{
    NSDictionary *target;
    UIColor *result = nil;
    
    if( [property isEqualToString:@"CalendarLayoutView"] )
    {
        target = [self getCalendarLayoutProperties];
    }
    else if( [property isEqualToString:@"CalendarView"] )
    {
        target = [self getCalendarViewProperties];
    }
    else if( [property isEqualToString:@"CalendarDayView"] )
    {
        target = [self getCalendarDayViewProperties];
    }
    else                                                // get it from the Common Dictionary
    {
        target = [self getTargetDict:property];
    }
    
    NSString *value = [target objectForKey:@"backgroundColor"];
    if( value )
    {
        if( [value hasSuffix:@".png"] )
            result = [UIColor colorWithPatternImage:[UIImage imageNamed: value]];
        else
        {
            SEL selector = NSSelectorFromString(value);
            if ([UIColor respondsToSelector:selector])
            {
                result = [UIColor performSelector:selector withObject:nil];
            }
            else                // fails, default to clearColor
                result = [UIColor clearColor];
        }
        
    }
    return result;
}

- (NSDictionary *) getCalendarLayoutProperties
{
    NSDictionary *viewItem = [self.calendarDict objectForKey:@"CalendarLayoutView"];
    NSDictionary *target = [viewItem objectForKey:self.appPrefix];
    return target;
}

- (NSDictionary *) getCalendarViewProperties
{
    NSDictionary *viewItem = [self.calendarDict objectForKey:@"CalendarView"];
    NSDictionary *target = [viewItem objectForKey:self.appPrefix];
    return target;
}

- (NSDictionary *) getCalendarDayViewProperties
{
    NSDictionary *viewItem = [self.calendarDict objectForKey:@"CalendarDayView"];
    NSDictionary *target = [viewItem objectForKey:self.appPrefix];
    return target;
}

- (UIColor *)grayColor:(CGFloat)gray alpha:(CGFloat)alpha
{
    return ([UIColor colorWithRed:(gray/255.0) green:(gray/255.0) blue:(gray/255.0) alpha:alpha]);
}

- (UIColor *) getDayViewColors:(NSString *)property
{
    NSDictionary *viewItem = [self.calendarDict objectForKey:@"CalendarDayView"];
    NSDictionary *target = [viewItem objectForKey:self.appPrefix];
    NSDictionary *clrDict = [target objectForKey:property];
    
    NSString *alpha = [clrDict objectForKey:@"Alpha"];
    NSString *gray = [clrDict objectForKey:@"Gray"];
    if( [gray length] < 1)                              // No Gray
    {
        NSString *red = nil;
        NSString *image = [clrDict objectForKey:@"Image"];
        if( image && [image hasSuffix:@".png"])
        {
            return [UIColor colorWithPatternImage:[UIImage imageNamed: image]];
        }
        else
        {
            red = [clrDict objectForKey:@"Red"];
            if( red )
            {
                NSString *green = [clrDict objectForKey:@"Green"];
                NSString *blue = [clrDict objectForKey:@"Blue"];
                return ([UIColor colorWithRed:([red doubleValue]/255.0) green:([green doubleValue]/255.0) blue:([blue doubleValue]/255.0) alpha:[alpha doubleValue]]);
            }
            else        // no Color specified
                return [UIColor clearColor];
        }
    }
    else
        return [self grayColor:[gray doubleValue] alpha:[alpha doubleValue]];
}


- (CalendarDayView *)initializeCalendarDayView:(CGRect)frame
{
    UIView *instance = nil;
    NSString *newCalView = nil;
    NSString *calDayData = nil;
    Class clazz = nil;
    
    Class dClazz = nil;
    id dayData = nil;
    
    
    NSDictionary *viewItem = [self.calendarDict objectForKey:@"CalendarDayView"];
    NSDictionary *target = [viewItem objectForKey:self.appPrefix];
    newCalView = [target objectForKey:@"sClass"];
    if( newCalView)
	{
		clazz = [self loadClazz:newCalView];
		instance = [[clazz alloc] initWithFrame:frame];
	}
	else
	{
		clazz = [self loadClazz:@"CalendarDayView"];
		instance = [[clazz alloc] initWithFrame:frame];
	}
    
    calDayData = [target objectForKey:@"dClass"];
    if( calDayData)                                 // should be one for every target...i.e REQUIRED
    {
		dClazz = [self loadClazz:calDayData];
		dayData = [[dClazz alloc] init];
    }
    else
    {
        /// REPORT AN ERROR?
    }
    CalendarDayView *cdv = (CalendarDayView *)instance;
	cdv.dataObj = dayData;
	return cdv;
}

- (id)init
{
	if (self = [super init])
	{
		self.appPrefix = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"APP_PREFIX"];
        self.abstractObjects = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"AbstractObjects" ofType:@"plist"]];
        self.commonDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Common" ofType:@"plist"]];
        self.calendarDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Calendar" ofType:@"plist"]];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bkg_light"]];
		
		self.dividerImage = [UIImage imageNamed:@"divider_horizontal.png"];
		self.linkColorNormal    = [UIColor colorWithRed:(39.0 / 255.0) green:(86.0 / 255.0) blue:(179.0 / 255.0) alpha:1.0f];
		self.linkColorHighlight = [UIColor colorWithRed:0.30f green:0.70f blue:1.0f alpha:1.0f];
		self.greyTextColor	    = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.0f];
		self.lightGreyTextColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.0f];
		
		self.titleLabelPrototypeLarge = [self labelWithColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:21.0 bold:NO];
		self.titleLabelPrototypeSmall = [self labelWithColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:18.0 bold:NO];
	}
	
	return self;
}

//
//- (BOOL)instructions:(id)controller instructName:(NSString *)name
//{
//	if(![[NSUserDefaults standardUserDefaults]objectForKey:name] )
//	{
//		NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: YES], name, nil];
//		[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
//	}
//	
//	//[[NSUserDefaults standardUserDefaults] registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: YES], name, nil]];
//	BOOL instructionsReport = [[NSUserDefaults standardUserDefaults] boolForKey: name];
//	if (instructionsReport )
//	{
//		InstructionsViewController* instructionsViewController = [[InstructionsViewController alloc] init];
//		instructionsViewController.delegate = controller;
//		instructionsViewController.sectionName = name;
//		[controller presentModalViewController: instructionsViewController animated:NO];
//		
//		[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool: NO] forKey: name];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//	}
//	return instructionsReport;
//}

- (BOOL) isPortraitOrientation
{
	return UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL) isLandscapeOrientation
{
	return !UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (UIFont*) fontWithSize:(CGFloat)fontSize bold:(BOOL)bold italic:(BOOL)italic
{
    //	NSArray* familyNames = [UIFont familyNames];
    //	NSArray* fontNames = [UIFont fontNamesForFamilyName:@"Helvetica"];
    //	NSArray* fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
	
    //	return [UIFont fontWithName:@"Courier New" size:fontSize];
    //	return [UIFont fontWithName:@"Helvetica Neue" size:fontSize];
	
	if (bold && italic)
	{
		return [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:fontSize];
	}
	else if (bold)
	{
		return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
	}
	else if (italic)
	{
		return [UIFont fontWithName:@"HelveticaNeue-Italic" size:fontSize];
	}
	
	return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

- (UILabel *) stdTitleLabelWithText:(NSString*)text
{
	return [self
			labelWithColor:[UIColor orangeColor]
			selectedColor:[UIColor whiteColor]
			fontSize:18
			bold:YES
			italic:NO
			text:text];
}

- (UILabel *) stdLabelWithText:(NSString*)text
{
	return [self
			labelWithColor:[UIColor redColor]
			selectedColor:[UIColor whiteColor]
			fontSize:13
			bold:NO
			italic:NO
			text:text];
}

- (UILabel *) labelWithColor:(UIColor *)color selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	return [self labelWithColor:color selectedColor:selectedColor fontSize:fontSize bold:bold italic:NO text:nil];
}

- (UILabel *) labelWithColor:(UIColor *)color
			   selectedColor:(UIColor *)selectedColor
					fontSize:(CGFloat)fontSize
						bold:(BOOL)bold
						text:(NSString*)text
{
	return [self labelWithColor:color
				  selectedColor:selectedColor
					   fontSize:fontSize
						   bold:bold
						 italic:NO
						   text:text];
}

- (UILabel *) labelWithColor:(UIColor *)color
			   selectedColor:(UIColor *)selectedColor
					fontSize:(CGFloat)fontSize
						bold:(BOOL)bold
					  italic:(BOOL)italic
						text:(NSString*)text
{
	//Create and configure a label.
    UIFont *font = [self fontWithSize:fontSize bold:bold italic:italic];
	
    // Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection
	// properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in
	// setSelected:animated:.
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
	//label.backgroundColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.textColor = color;
	label.highlightedTextColor = selectedColor;
	label.font = font;
	label.numberOfLines = 0;
	label.lineBreakMode = NSLineBreakByWordWrapping;
	
	if (text != nil)
	{
		label.text = text;
	}
	
    //	DebugLog(@"Using font %@", font.fontName);
	
	return label;
}

//
// Returns a new, autoreleased UITextView. The caller is reponsible for retaining ownership.
//
- (UITextView *) textViewWithColor:(UIColor *)Color fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	//Create and configure a TextView.
	UIFont *font;
	
    if (bold)
	{
        font = [UIFont boldSystemFontOfSize:fontSize];
    }
	else
	{
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    
	// Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection
	// properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in
	// setSelected:animated:.
	UITextView* textView = [[UITextView alloc] initWithFrame:CGRectZero];
	textView.backgroundColor = [UIColor whiteColor];
	textView.opaque = YES;
	textView.textColor = Color;
	textView.font = font;
	
	return textView;
}

//
// Creates a new text field. The caller is responsible for retaining ownership.
//
- (UITextField*) textFieldWithFrame:(CGRect)frame
{
	UITextField* textField = [[UITextField alloc] initWithFrame:frame];
	textField.font = [UIFont systemFontOfSize:14.0f];
	textField.clearButtonMode = UITextFieldViewModeWhileEditing; // UITextFieldViewModeAlways;
	//textField.borderStyle = UITextBorderStyleBezel;
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.textAlignment = NSTextAlignmentLeft;                                      //kCTLeftTextAlignment;
	textField.textColor = [UIColor blackColor];
	textField.backgroundColor = [UIColor whiteColor];
	textField.opaque = YES;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	textField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	textField.returnKeyType = UIReturnKeyDone;
	textField.enablesReturnKeyAutomatically = NO;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//textField.delegate = self;
	
	return textField;
}

- (NSString *) getFormattedRuntimeString:(NSInteger) runtime
{
	NSString* hoursString = @"";
	NSString* minutesString = @"";
	
	NSInteger hours = runtime / 60;
	NSInteger minutes = runtime % 60;
	
	if (hours == 1)
	{
		hoursString = @"1 hr.";
	}
	else if (hours > 1)
	{
		hoursString = [NSString stringWithFormat:@"%d hrs.", hours];
	}
	
	if (minutes == 1)
	{
		minutesString = @"1 min.";
	}
	else if (minutes > 1)
	{
		minutesString = [NSString stringWithFormat:@"%d mins.", minutes];
	}
	
	return [NSString stringWithFormat:@"%@ %@", hoursString, minutesString];
}

- (NSString *) stringWithTimeInterval:(NSTimeInterval) timeInterval
{
	NSString* hoursString = @"";
	NSString* minutesString = @"";
	
	NSInteger hours = timeInterval / 3600;
	NSInteger minutes = (NSInteger)(timeInterval / 60) % 60;
	
	if (hours == 1)
	{
		hoursString = @"1 hr.";
	}
	else if (hours > 1)
	{
		hoursString = [NSString stringWithFormat:@"%d hrs.", hours];
	}
	
	if (minutes == 1)
	{
		minutesString = @"1 min.";
	}
	else if (minutes > 1)
	{
		minutesString = [NSString stringWithFormat:@"%d mins.", minutes];
	}
	
	if ([hoursString isEqualToString:@""] && [minutesString isEqualToString:@""])
	{
		return @"less than 1 min.";
	}
	return [NSString stringWithFormat:@"%@ %@", hoursString, minutesString];
}


//
// Returns the size of the given title taking into account a font size reduction
// if the title needs to wrap.
//
- (CGSize) titleSize:(NSString*)title withWidth:(CGFloat)width outFont:(UIFont**)outFont
{
	CGSize sizeToReturn = CGSizeZero;
	UIFont* finalFont = self.titleLabelPrototypeLarge.font;
	
	if (title != nil)
	{
		CGSize titleSize = [title sizeWithFont:finalFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];       // iOS 6
		
		// Cast the size to NSInteger to avoid fractional offsets.
		titleSize = CGSizeMake((NSInteger)titleSize.width, (NSInteger)titleSize.height);
		
		if (titleSize.height > self.titleLineHeightLarge)
		{
			finalFont = self.titleLabelPrototypeSmall.font;
			titleSize = [title sizeWithFont:finalFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];       // iOS 6
			
			// Do not let the title wrap passed the max lines.
			if (titleSize.height > self.titleMaxHeight)
			{
				titleSize.height = self.titleMaxHeight;
			}
		}
		
		sizeToReturn = titleSize;
	}
	
	if (outFont != nil)
	{
		*outFont = finalFont;
	}
	
	return sizeToReturn;
}

//
// Lays out the given title label at the given origin/point respecting the maximum width.
// Returns the resulting frame of the label.
//
- (CGRect) layoutTitleLabel:(UILabel*)titleLabel atPoint:(CGPoint)point withMaxWidth:(CGFloat)maxWidth
{
	// Cast the origin to NSInteger to avoid a fractional offset.
	CGRect toReturn = CGRectMake((NSInteger)point.x, (NSInteger)point.y, 0.0f, 0.0f);
	
	if (titleLabel != nil)
	{
		if (![StringFunctions isEmptyString:titleLabel.text])
		{
			UIFont* labelFont = nil;
			CGSize labelSize = [self titleSize:titleLabel.text withWidth:maxWidth outFont:&labelFont];
			
			// Apple the new font.
			titleLabel.font = labelFont;
			
			// Set the alignment.
			titleLabel.textAlignment = NSTextAlignmentLeft;                 //kCTLeftTextAlignment;
			
			// Set the line break mode.
			titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;       //NSLineBreakByTruncatingTail;
			
			// Update the size.
			toReturn.size = labelSize;
		}
		
		// Position the label.
		titleLabel.frame = toReturn;
	}
	
	return toReturn;
}

//
// Draws the given title at the given origin/point respecting the maximum width.
// Returns the resulting frame of the label.
//
- (CGRect) drawTitle:(NSString*)title atPoint:(CGPoint)point withMaxWidth:(CGFloat)maxWidth
{
	// Cast the origin to NSInteger to avoid a fractional offset.
	CGRect toReturn = CGRectMake((NSInteger)point.x, (NSInteger)point.y, 0.0f, 0.0f);
	
	if (![StringFunctions isEmptyString:title])
	{
		UIFont* outFont = nil;
		toReturn.size = [self titleSize:title withWidth:maxWidth outFont:&outFont];
		
        [title drawInRect:toReturn withFont:outFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];  // iOS 6
		// UILineBreakModeWordWrap
	}
	
	return toReturn;
}



//
// Toggles the selected state of a checkbox button.
//
- (void) checkboxToggleSelection:(id)source
{
	if (source != nil && [source isKindOfClass:[UIButton class]])
	{
		((UIButton*)source).selected = !((UIButton*)source).selected;
	}
}

//
// Toggles the selected state of a checkbox button.
//
- (void) checkboxSetSelection:(id)source selected:(BOOL)selected
{
	if (source != nil && [source isKindOfClass:[UIButton class]])
	{
		((UIButton*)source).selected = selected;
	}
}


//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
- (void) adjustButtonSizeToFitText:(UIButton*)button
{
	[UIUtil adjustButtonSizeToFitText:(UIButton*)button];
}

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
- (void) adjustButtonSizeToFitText:(UIButton*)button withInsets:(UIEdgeInsets)insets
{
	[UIUtil adjustButtonSizeToFitText:(UIButton*)button withInsets:(UIEdgeInsets)insets];
}

//
// Corrects the width and height of the given UILabel to accomodate its text on a single line.
//
- (void) adjustLabelSizeToFitText:(UILabel*)label
{
	[UIUtil adjustLabelSizeToFitText:(UILabel*)label];
}

//
// Corrects the height of the given UILabel to accomodate its text content relative to its current width.
//
- (void) adjustLabelHeightToFitText:(UILabel*)label
{
	[UIUtil adjustLabelHeightToFitText:(UILabel*)label];
}

//
// Returns the ideal height for the given text string.
//
- (CGFloat) idealStringHeight:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font
{
	return [UIUtil idealStringHeight:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font];
}

//
// Returns the ideal size for the given text string.
//
- (CGSize) idealStringSize:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font
{
	return [UIUtil idealStringSize:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font];
}

//
// A helper method to set just the x-position of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setX:(CGFloat)xPos
{
	return [UIUtil view:(UIView*)view setX:(CGFloat)xPos];
}

//
// A helper method to set just the y-position of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setY:(CGFloat)yPos
{
	return [UIUtil view:(UIView*)view setY:(CGFloat)yPos];
}

//
// A helper method to set just the origin of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setOrigin:(CGPoint)origin
{
	return [UIUtil view:(UIView*)view setOrigin:(CGPoint)origin];
}

//
// A helper method to set just the width of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setWidth:(CGFloat)width
{
	return [UIUtil view:(UIView*)view setWidth:(CGFloat)width];
}

//
// A helper method to set just the height of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setHeight:(CGFloat)height
{
	return [UIUtil view:(UIView*)view setHeight:(CGFloat)height];
}

//
// A helper method to set just the size of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setSize:(CGSize)size
{
	return [UIUtil view:(UIView*)view setSize:(CGSize)size];
}

//
// A helper method to set just the accessibility label and hint of the given view.
//
- (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint
{
	[UIUtil view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint];
}

//
// A helper method to set just the accessibility label and hint of the given view.
//
- (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint andValue:(NSString*)value
{
	[UIUtil view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint andValue:(NSString*)value];
}

//
// A helper method to convert the string into an accessible string such that each letter is spoken separately.
//
- (NSString*) letterizeString:(NSString*)str
{
	return [UIUtil letterizeString:(NSString*)str];
}

//
// Splits the given string on words and capitalizes each word.
//
- (NSString*) capitalizeWordsInString:(NSString*)str
{
	return [UIUtil capitalizeWordsInString:(NSString*)str];
}

//
// A helper method to set just the line break mode of the given UIButton.
//
- (void) button:(UIButton*)button setLineBreakMode:(UILineBreakMode)lineBreakMode
{
	[UIUtil button:(UIButton*)button setLineBreakMode:(UILineBreakMode)lineBreakMode];
}

//
// A helper method to set just the text alignment of the given UIButton.
//
- (void) button:(UIButton*)button setTextAlignment:(UITextAlignment)textAlignment
{
	[UIUtil button:(UIButton*)button setTextAlignment:(UITextAlignment)textAlignment];
}

//
// A helper method to set just the font of the given UIButton.
//
- (void) button:(UIButton*)button setFont:(UIFont*)font
{
	[UIUtil button:(UIButton*)button setFont:(UIFont*)font];
}

//
// A helper method to return the font of a UIButton (this is done to reduce the number of compiler warnings).
//
- (UIFont*) buttonGetFont:(UIButton*)button
{
	return [UIUtil buttonGetFont:(UIButton*)button];
}

//
// Loads the nib with the given name and return the first UIView.
//
- (UIView*) loadViewFromNibNamed:(NSString*)nibName owner:(id)owner
{
	return [UIUtil loadViewFromNibNamed:(NSString*)nibName owner:(id)owner];
}

- (UIButton*) replaceButton:(UIButton*)src withButton:(UIButton*)replacement
{
	return [UIUtil replaceButton:(UIButton*)src withButton:(UIButton*)replacement];
}

- (UIView*) replaceView:(UIView*)src withView:(UIView*)replacement
{
	return [UIUtil replaceView:(UIView*)src withView:(UIView*)replacement];
}

//
// Returns an autoreleased UIAccessibilityElement.
//
- (id) accessibleElementWithContainer:(id)container frame:(CGRect)frame label:(NSString*)label hint:(NSString*)hint
{
	return [UIUtil accessibleElementWithContainer:(id)container frame:(CGRect)frame label:(NSString*)label hint:(NSString*)hint];
}

//
// A helper method to defocus all subviews of a view
//
+ (void) resignFirstRespondersOf:(UIView*)parentView
{
	[UIUtil resignFirstRespondersOf:(UIView*)parentView];
}

//
// A helper method to defocus all subviews of a view and a given class.  For example [UITextEntry class] if you only want to close onscreen keyboards.
//
+ (void) resignFirstRespondersOf:(UIView*)parentView ofClass:(Class)ofClass
{
	[UIUtil resignFirstRespondersOf:(UIView*)parentView ofClass:(Class)ofClass];
}

//
// Displays the following message in a standard UIAlertView.
//
- (void) alertMessage:(NSString*)message
{
	[UIUtil alertMessage:(NSString*)message];
}

//
// A generic handler to deal with not implemented features.
//
- (void) notYetImplementedHandler:(id)source
{
	[UIUtil notYetImplementedHandler:(id)source];
}

@end

@implementation UIMutableFont

//
// Constructor.
//
- (id) initWithFont:(UIFont*)font
{
	if (self = [super init])
	{
		_ascender = font.ascender;
		_capHeight = font.capHeight;
		_descender = font.descender;
		_familyName = font.familyName;
		_fontName = font.fontName;
		_leading = font.leading;
		_pointSize = font.pointSize;
		_xHeight = font.xHeight;
	}
	
	return self;
}

//
// Destructor
//
- (void) dealloc
{
	_familyName = nil;
	_fontName = nil;
	
}

//
// Specifies the top y-coordinate, offset from the baseline, of the receiver’s longest ascender. (read-only)
//
- (CGFloat) ascender
{
	return _ascender;
}

//
// Specifies the receiver’s cap height information. (read-only)
//
- (CGFloat) capHeight
{
	return _capHeight;
}

//
// Specifies the bottom y-coordinate, offset from the baseline, of the receiver’s longest descender. (read-only)
//
- (CGFloat) descender
{
	return _descender;
}

//
// Specifies the receiver’s family name. (read-only)
//
- (NSString*) familyName
{
	return _familyName;
}

//
// Specifies the font face name. (read-only)
//
- (NSString*) fontName
{
	return _fontName;
}

//
// Specifies the receiver’s leading information. (read-only)
//
- (CGFloat) leading
{
	return _leading;
}

//
// Specifies receiver’s point size, or the effective vertical point size for a font with a nonstandard matrix. (read-only)
//
- (CGFloat) pointSize
{
	return _pointSize;
}

//
// Specifies the x-height of the receiver. (read-only)
//
- (CGFloat) xHeight
{
	return _xHeight;
}

@end

