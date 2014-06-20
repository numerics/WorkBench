//
//  CHLookAndFeelManager.h
//  ChinUp
//
//  Created by Kailash Sharma on 12/01/11.
//  Copyright 2011 Atimi Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CHLookAndFeelManager : NSObject {
    @private
    NSString *_bundleName;

    NSMutableDictionary *_colorDictionary;
    NSMutableDictionary *_fontDictionary;
    NSMutableDictionary *_fontColorDictionary;
    NSMutableDictionary *_imageDictionary;
    NSDictionary *_propertiesDictionary;
}

+ (CHLookAndFeelManager *)sharedLookAndFeelManager;
+ (NSDictionary *) dictionaryFromPlistWithBaseName: (NSString *) aBaseName;

- (NSString *) setBundleName: (NSString *) keyName;

- (UIColor *) colorAtKey: (NSString *) keyName;
- (UIFont *) fontAtKey: (NSString *) keyName;
- (UIColor *) fontColorAtKey: (NSString *) keyName;
- (UIImage *) imageAtKey: (NSString *) keyName;
- (NSString *) stringAtKey: (NSString *) keyName;

- (UIColor *) colorFromHexString: (NSString *) hexString;

// Dictionaries
- (void) createColorDictionary;
- (void) createFontDictionary;
- (void) createFontColorDictionary;

@end