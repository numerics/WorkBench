//
//  DetailTableViewCell.m
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "DetailData.h"

@implementation DetailTableViewCell

@synthesize detailItem;

+ (CGFloat) heightForItem:(DetailItem*) item
{
	static CGFloat rowHeight = 44;
	static CGFloat sectionTopPadding = 10;
	static CGFloat sectionBottomPadding = 10;
	return rowHeight * item.subTableItems.count + sectionTopPadding + sectionBottomPadding;
}


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] )
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundColor = [UIColor purpleColor];
		tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) style:UITableViewStyleGrouped];
		tableView.backgroundColor = [UIColor clearColor];
		tableView.dataSource = self;
		tableView.delegate = self;
		tableView.scrollEnabled = NO;
		[self.contentView addSubview:tableView];
	}
	return self;
}

- (CGSize) sizeThatFits:(CGSize) size
{
	return tableView.contentSize;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return detailItem.subTableItems.count;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	[tableView reloadData];
	CGRect r = tableView.frame;
	r.size = tableView.contentSize;
	tableView.frame = r;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = nil;
	static NSString* reuse = @"menuCell";
	cell = [_tableView dequeueReusableCellWithIdentifier:reuse];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
		cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron-purple"]];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.textColor = kHeadingTintColor;
	}
	//cell.textLabel.text = @"text";
	cell.textLabel.text = [(DetailData*)[detailItem.subTableItems objectAtIndex:indexPath.row] title];

	return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
	id tg = [(DetailData*)[detailItem.subTableItems objectAtIndex:indexPath.row] target];
	SEL	action = [(DetailData*)[detailItem.subTableItems objectAtIndex:indexPath.row] action];
	
	///*** When an action for an item is defined this will work ***///
	if ([tg respondsToSelector:action])
		 [tg performSelectorOnMainThread:action withObject:nil waitUntilDone:NO];
    [tableView reloadData];

}



@end
