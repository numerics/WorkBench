//
//  CHLookAndFeelManager.m
//  WorkBench
//
//  Created by John Basile on 9/26/12.
//  Copyright 2011 Numerics Software. All rights reserved.
//

#import "CHLookAndFeelManager.h"

static CHLookAndFeelManager *g_sharedLookAndFeelManager = nil;

@implementation CHLookAndFeelManager


#pragma mark -
#pragma mark Singleton methods

// Following Apple's Singleton examples at
//   http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html#//apple_ref/doc/uid/TP40002974-CH4-SW32
+ (CHLookAndFeelManager *)sharedLookAndFeelManager {
    if (g_sharedLookAndFeelManager == nil) {
        g_sharedLookAndFeelManager = [[super allocWithZone: NULL] init];
        // load in stuff from bundle4
    }


    return g_sharedLookAndFeelManager;
}

+ (id) allocWithZone: (NSZone *) zone {
    return [self sharedLookAndFeelManager];
}

- (id) copyWithZone: (NSZone *) zone {
    return self;
}

+ (NSDictionary *) dictionaryFromPlistWithBaseName: (NSString *) aBaseName {
    NSString *fullName = [NSString stringWithFormat: @"%@.plist", aBaseName];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;

    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];

    plistPath = [bundlePath stringByAppendingPathComponent: fullName];

    if (![[NSFileManager defaultManager] fileExistsAtPath: plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource: aBaseName ofType: @"plist"];
    }

    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath: plistPath];
    NSDictionary *propertiesDictionary = (NSDictionary *)[NSPropertyListSerialization propertyListFromData: plistXML
                                                          mutabilityOption: NSPropertyListMutableContainersAndLeaves
                                                          format: &format
                                                          errorDescription: &errorDesc];


    return propertiesDictionary;
}
//
//- (id) retain {
//    return self;
//}
//
//- (NSUInteger) retainCount {
//    return NSUIntegerMax; //denotes an object that cannot be released
//}
//
//- (oneway void) release {
//   //do nothing
//}
//
//- (id) autorelease {
//    return self;
//}


- (id) init {
    if ((self = [super init])) {
        [self createColorDictionary];
        [self createFontDictionary];
        [self createFontColorDictionary];
    }
    return self;
}

#pragma mark -
#pragma mark Getters

- (UIColor *) colorAtKey: (NSString *) keyName {
    return [_colorDictionary objectForKey: keyName];
}

- (UIFont *) fontAtKey: (NSString *) keyName  {
    return [_fontDictionary objectForKey: keyName];
}

- (UIColor *) fontColorAtKey: (NSString *) keyName  {
    return [_fontColorDictionary objectForKey: keyName];
}

- (UIImage *) imageAtKey: (NSString *) keyName {
    return [_imageDictionary objectForKey: keyName];
}

// This isn't actually required to be a string, but we are *probably* only
// going to have strings in the plist dictionary.
- (NSString *) stringAtKey: (NSString *) keyName {
    if (_propertiesDictionary) {
        if ([_propertiesDictionary isKindOfClass: [NSDictionary class ]]) {
            return [_propertiesDictionary objectForKey: keyName];
        }
        else {
            NSLog(@"[%@] *** ERROR *** -- properties dictionary is not a dictionary, it is a %@", self.class, [_propertiesDictionary class ]);
            return nil;
        }
    }
    else {
        return nil;
    }
}

/*
 *  Returns a UIColor from a given hex string representation of a color (RGB).
 *  Assumptions:
 *      - 6 characters in string (RGB format)
 *      - no 0x in front of the string
 */
- (UIColor *) colorFromHexString: (NSString *) hexString {
    UIColor *color = [UIColor blackColor];

    if (!hexString) {
        return color;
    }

    NSScanner *scanner = [NSScanner scannerWithString: hexString];
    [scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString: @"#"]];

    unsigned int value = 0;
    if ([scanner scanHexInt: &value]) {
        int red = (value >> 16) & 0xFF;
        int green = (value >> 8) & 0xFF;
        int blue = value & 0xFF;
        color = [UIColor colorWithRed: red / 255.0 green: green / 255.0 blue: blue / 255.0 alpha: 1.0];
    }

    return color;
}

#pragma mark -
#pragma mark Setters

- (void) setBundle: (NSString *) aBundle {
    _bundleName = aBundle;
}

- (NSString *) setBundleName: (NSString *) keyName {
    return @"Bundle Name";
}

#pragma mark -
#pragma mark Create Dictionaries

- (void) createColorDictionary {
    if (_colorDictionary == nil) {
        _colorDictionary = [NSMutableDictionary dictionary];
    }
    [_colorDictionary setObject: [UIColor blackColor] forKey: @"Black"];
    [_colorDictionary setObject: [UIColor whiteColor] forKey: @"White"];
    [_colorDictionary setObject: [UIColor blueColor]  forKey: @"Blue"];

    [_colorDictionary setObject: [UIColor colorWithRed: 50.0f / 255.0f green: 50.0f / 255.0f blue: 50.0f / 255.0f alpha: 1] forKey: @"Dark Gray"];
    [_colorDictionary setObject: [UIColor colorWithRed: 95.0f / 255.0f green: 95.0f / 255.0f blue: 95.0f / 255.0f alpha: 1] forKey: @"Gray"];
    [_colorDictionary setObject: [UIColor colorWithRed: 150.0f / 255.0f green: 150.0f / 255.0f blue: 150.0f / 255.0f alpha: 1] forKey: @"Light Gray"];
    [_colorDictionary setObject: [UIColor colorWithRed: 224.0f / 255.0f green: 224.0f / 255.0f blue: 224.0f / 255.0f alpha: 1] forKey: @"Gray Cell"];
    [_colorDictionary setObject: [UIColor colorWithRed: 236.0f / 255.0f green: (236.0f / 255.0f) blue: (236.0f / 255.0f) alpha: 1] forKey: @"Bone"];
    [_colorDictionary setObject: [UIColor colorWithRed: 38.0f / 255.0f green: (38.0f / 255.0f) blue: (38.0f / 255.0f) alpha: 1] forKey: @"Cell Background"];
    [_colorDictionary setObject: [UIColor colorWithRed: 27.0f / 255.0f green: (27.0f / 255.0f) blue: (27.0f / 255.0f) alpha: 1] forKey: @"defaultDayBkgColor"];
}

- (void) createFontDictionary {
    if (_fontDictionary == nil) {
        _fontDictionary = [NSMutableDictionary dictionary];
    }

#if DEBUG_JWORBY || DEBUG_FONTS
    // Test to see what fonts are available
    NSArray *familyNames = [[UIFont familyNames] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *fontFamilyName in familyNames) {
        for (NSString *fontName in[UIFont fontNamesForFamilyName : fontFamilyName]) {
            NSLog(@"[%@] createFontDictionary: fontName = %@", [self class ], fontName);
        }
    }
#endif

    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 10] forKey: @"T1"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 11] forKey: @"T2"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 12] forKey: @"T3"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 13] forKey: @"T4"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 14] forKey: @"T5"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 15] forKey: @"T6"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 16] forKey: @"T7"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 18] forKey: @"T8"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 22] forKey: @"T9"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 27] forKey: @"T10"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 28] forKey: @"T11"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: 34] forKey: @"T12"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: 10] forKey: @"T13"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: 11] forKey: @"T14"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: 13] forKey: @"T15"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: 15] forKey: @"T16"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: 16] forKey: @"T17"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: 18] forKey: @"T18"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: 20] forKey: @"T19"];
	[_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: 14] forKey: @"T20"];

}

- (void) createFontColorDictionary {
    if (_fontColorDictionary == nil) {
        _fontColorDictionary = [NSMutableDictionary dictionary];
    }

    //*************************************************************************************
    // NOTE: Fonts here match up with the GDS, hence the naming convention used
    //*************************************************************************************

    UIColor *percent60Black = [UIColor colorWithRed: 0.6 green: 0.6 blue: 0.6 alpha: 1.0];
    UIColor *percent75Black = [UIColor colorWithRed: 0.75 green: 0.75 blue: 0.75 alpha: 1.0];
    UIColor *primary = [UIColor colorWithRed: 0.4 green: 0.625 blue: 0.766 alpha: 1.0];
    UIColor *white = [UIColor whiteColor];
    UIColor *black = [UIColor blackColor];


    [_fontColorDictionary setObject: percent60Black forKey: @"T1"];
    [_fontColorDictionary setObject: percent75Black forKey: @"T2"];
    [_fontColorDictionary setObject: black forKey: @"T3"];


    [_fontColorDictionary setObject: percent60Black forKey: @"T4"];
    [_fontColorDictionary setObject: percent60Black forKey: @"T5"];


    [_fontColorDictionary setObject: black forKey: @"T6"];
    [_fontColorDictionary setObject: percent75Black forKey: @"T7"];
    [_fontColorDictionary setObject: black forKey: @"T8"];


    [_fontColorDictionary setObject: white forKey: @"T9"];
    [_fontColorDictionary setObject: primary forKey: @"T10"];
    [_fontColorDictionary setObject: black forKey: @"T11"];
    [_fontColorDictionary setObject: white forKey: @"T12"];


    [_fontColorDictionary setObject: black forKey: @"T13"];
    [_fontColorDictionary setObject: percent75Black forKey: @"T14"];
    [_fontColorDictionary setObject: primary forKey: @"T15"];


    [_fontColorDictionary setObject: white forKey: @"T16"];
    [_fontColorDictionary setObject: percent75Black forKey: @"T17"];


    [_fontColorDictionary setObject: black forKey: @"T18"];


    [_fontColorDictionary setObject: percent60Black forKey: @"T19"];
    [_fontColorDictionary setObject: black forKey: @"T20"];

 
    [_fontColorDictionary setObject: percent60Black forKey: @"T21"];

 
    [_fontColorDictionary setObject: percent60Black forKey: @"T22"];
    [_fontColorDictionary setObject: percent60Black forKey: @"T23"];
    [_fontColorDictionary setObject: percent60Black forKey: @"T24"];


    [_fontColorDictionary setObject: black forKey: @"T25"];
    [_fontColorDictionary setObject: percent60Black forKey: @"T26"];
    [_fontColorDictionary setObject: black forKey: @"T27"];
    [_fontColorDictionary setObject: primary forKey: @"T28"];
    [_fontColorDictionary setObject: black forKey: @"T29"];
    [_fontColorDictionary setObject: primary forKey: @"T30"];
    [_fontColorDictionary setObject: black forKey: @"T31"];
    [_fontColorDictionary setObject: black forKey: @"T32"];


    [_fontColorDictionary setObject: black forKey: @"T33"];
    [_fontColorDictionary setObject: black forKey: @"T34"];
}

@end