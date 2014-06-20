//
//  AccordianViewController.h
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableCellView.h"

@interface AccordianTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray		*contentArray;
	NSIndexPath			*expandedItemIndex;
	ItemTableCellView	*selectedCell;
}

-(void) collapseExpandedCell;
-(void) expandItem:(NSUInteger)itemNum;

@property (nonatomic,copy) 	NSIndexPath			*expandedItemIndex;
@property (nonatomic,strong) NSMutableArray		*contentArray;
@property (nonatomic,strong) ItemTableCellView	*selectedCell;


@end
