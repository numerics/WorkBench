//
//  ItemTableCellView.h
//
//  Created by John Basile on 08/18/12.
//  Copyright (c) 2012 Beachbody, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ItemTableConstants.h"

#define kItemTableCellExpandedHeight	44
#define kItemTableCellBackgroundImage	[UIImage imageNamed:@"background-cell-tall-grey.png"]

@class ItemTableCellView;

@interface ItemTableCellView : UITableViewCell
{
	Item						*item;
	BOOL						expanded;
	CGFloat						originalTitleY;
}

@property (nonatomic,retain)	Item	*item;
@property (nonatomic,assign)	BOOL	expanded;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setExpanded:(BOOL)e;

@end

