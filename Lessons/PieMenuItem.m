//
//  PieMenuItem.m
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 27/11/08.
//  Modified by John Basile on 6/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "PieMenuItem.h"


@implementation PieMenuItem

@synthesize title;
@synthesize label;
@synthesize target;
@synthesize action;
@synthesize userInfo;
@synthesize icon;
@synthesize subItems;
@synthesize parentItem;
@synthesize type;

- (id) initWithTitle:(NSString *)theTitle
			   label:(NSString *)theLabel
			  target:(id)theTarget
            selector:(SEL)theSelector
			userInfo:(id)theInfo
				icon:(UIImage *)theIcon {
	if (self = [self init]) {
		self.title = theTitle;
		self.label = theLabel;
		self.target = theTarget;
		self.action = theSelector;
		self.userInfo = theInfo;
		self.icon = theIcon;
	}
	return self;
}


- (id) init {
	if (self = [super init]) {
		self.type = PieMenuItemTypeNormal;
		self.subItems = [[NSArray alloc] init];
	}
	return self;
}

- (void) performAction {
	if (target != nil && action)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        // removes warning due to ARC not handling PerfomSelector abstraction methods
        // See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
		[target performSelector:action withObject:userInfo];
#pragma clang diagnostic pop
	}
}

- (void) addSubItem:(PieMenuItem *)theSubItem {
	if (theSubItem == nil) {
		NSException *exception = [NSException exceptionWithName:@"NSInvalidArgumentException"
														 reason:@"the item suplied is nil"  userInfo:nil];
		@throw exception;
	}
	if ([subItems count] >= kMaxNumberOfSubitems) {
		NSException *exception = [NSException exceptionWithName:@"RangeException"
														 reason:@"maximus number of subitems reached"  userInfo:nil];
		@throw exception;
	}
	if ([subItems indexOfObject:theSubItem] != NSNotFound) {
		NSException *exception = [NSException exceptionWithName:@"DuplicatedItemException"
														 reason:@"the item is allready a subitem"  userInfo:nil];
		@throw exception;
	}
	if (theSubItem.parentItem != nil && theSubItem.parentItem != self) {
		NSException *exception = [NSException exceptionWithName:@"ItemParentException"
														 reason:@"the item is a subitem of another item"  userInfo:nil];
		@throw exception;
	}
	if (theSubItem == self) {
		NSException *exception = [NSException exceptionWithName:@"ItemCicleException"
														 reason:@"the item is the same as teh parent"  userInfo:nil];
		@throw exception;
	}

	theSubItem.parentItem = self;
	self.subItems = [subItems arrayByAddingObject:theSubItem];
	self.type = PieMenuItemTypeParent;
}

- (BOOL) hasSubitems {
	return [subItems count] > 0;
}

- (NSUInteger) numberOfSubitems {
	return [subItems count];
}

- (PieMenuItem *) subitemAtIndex:(NSInteger)theIndex {
	if (theIndex >= 0 && theIndex < [subItems count]) {
		return [subItems objectAtIndex:theIndex];
	}
	return nil;
}

- (NSInteger) indexInParent {
	if (parentItem != nil) {
		return [parentItem.subItems indexOfObject:self];
	}
	return NSNotFound;
}


@end
