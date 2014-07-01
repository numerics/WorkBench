//
//  PieMenuItem.h
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 27/11/08.
//  Modified by John Basile on 6/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMaxNumberOfSubitems   5

typedef enum {
	PieMenuItemTypeNormal,
	PieMenuItemTypeBack,
	PieMenuItemTypeParent,
} PieMenuItemType;

@interface PieMenuItem : NSObject
{
	NSString *title;
	NSString *label;
	id target;
	SEL action;
	id userInfo;
	UIImage *icon;
	NSArray *subItems;
	PieMenuItem *__weak parentItem;
	PieMenuItemType type;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) id target;
@property (nonatomic) SEL action;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSArray *subItems;
@property (nonatomic, weak) PieMenuItem *parentItem;
@property (nonatomic) PieMenuItemType type;

- (id) initWithTitle:(NSString *)theTitle
			   label:(NSString *)theLabel
			  target:(id)theTarget
            selector:(SEL)theSelector
			userInfo:(id)theInfo
				icon:(UIImage *)theIcon;

- (void) addSubItem:(PieMenuItem *)theSubItem;
- (BOOL) hasSubitems;
- (NSUInteger) numberOfSubitems;
- (PieMenuItem *) subitemAtIndex:(NSInteger)theIndex;
- (void) performAction;
- (NSInteger) indexInParent; 

@end
