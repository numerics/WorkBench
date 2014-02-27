//
//  DetailTableViewCell.h
//
//  Created by John Basile on 08/18/12.
//  Copyright (c) 2012 Beachbody, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailItem.h"
#import "ItemTableConstants.h"

@interface DetailTableViewCell : UITableViewCell <UITableViewDelegate,UITableViewDataSource>
{
	DetailItem		*detailItem;
	UITableView		*tableView; 
}
@property (nonatomic,retain) 	DetailItem	*detailItem;

+ (CGFloat) heightForItem:(DetailItem*) item;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (CGSize) sizeThatFits:(CGSize) size;


@end
