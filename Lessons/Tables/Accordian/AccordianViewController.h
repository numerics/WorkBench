//
//  AccordianViewController.h
//
//  Created by John Basile on 08/18/12.
//  Copyright (c) 2012 Beachbody, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableCellView.h"

@interface AccordianViewController : UITableView <UITableViewDelegate, UITableViewDataSource>
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
