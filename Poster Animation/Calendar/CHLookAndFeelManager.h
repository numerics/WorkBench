//
//  CHLookAndFeelManager.h
//  WorkBench
//
//  Created by John Basile on 9/26/12.
//  Copyright 2011 Numerics Software. All rights reserved.
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