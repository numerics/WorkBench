//
//  DetailTableViewCell.h
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
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
