//
//  ItemTableCellView.h
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
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

@property (nonatomic,strong)	Item        *item;
@property (nonatomic,assign)	BOOL        expanded;
@property (nonatomic,strong)    CKLabel     *detailLabel;
@property (nonatomic,strong)    CKLabel     *titleLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setExpanded:(BOOL)e;

@end

