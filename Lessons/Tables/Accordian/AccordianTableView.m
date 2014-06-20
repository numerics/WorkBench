//
//  ItemViewController.m
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "AccordianTableView.h"
#import "DetailTableViewCell.h"
#import "ItemTableConstants.h"

@implementation AccordianTableView

@synthesize expandedItemIndex,contentArray,selectedCell;


#pragma mark -
#pragma mark View lifecycle
//
//- (id)initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil
//{
//    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
//    if (self)
//    {
//        self.tableView.userInteractionEnabled = YES;
//        [self becomeFirstResponder];
//    }
//    return self;
//}
//
//-(void)viewDidLoad
//{
//	self.view.backgroundColor = [UIColor clearColor];
//}
//
//-(void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//
////	self.navigationItem.title = @"Title";
////	self.navigationController.navigationBar.tintColor = kHeadingTintColor;
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//	[super viewDidAppear:animated];
//}

//
// Initializes and returns a table view object having the given frame and style.
//
- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ((self = [super initWithFrame:frame style:style]))
	{
        // Initialization code
		[self awakeFromNib];
    }
    return self;
}

//
// Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
//
- (void) awakeFromNib
{
	self.delegate = self;
	self.dataSource = self;
    [self setAllowsSelection:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentArray.count;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSObject* content = [contentArray objectAtIndex:indexPath.row];
	CGFloat height = _tableView.rowHeight;
	if ([content isKindOfClass:[UIImage class]])
	{
		height = ((UIImage*)content).size.height;
	}
	else if ([content isKindOfClass:[Item class]])
	{
		// if cell is expanded
		if (indexPath.row+1 < contentArray.count && [[contentArray objectAtIndex:indexPath.row+1] isKindOfClass:[DetailItem class]])
		{
			height = kItemTableCellExpandedHeight;
		}
		else
		{
			height = kItemTableCellBackgroundImage.size.height;
		}
	}
	else if ([content isKindOfClass:[DetailItem class]])
	{
		height = [DetailTableViewCell heightForItem:(DetailItem*)content];
	}
	return height;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSObject* content = [contentArray objectAtIndex:indexPath.row];
	NSLog(@"row %i contains a %@ object",indexPath.row,[[content class] description]);
	
	UITableViewCell* cell = nil;
	
	if ([content isKindOfClass:[UIImage class]]) 
	{
		if (!cell) 
		{ 
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
			[cell.contentView addSubview:[[UIImageView alloc] initWithImage:(UIImage*)content]];
		}
	}
	else if ([content isKindOfClass:[Item class]]) 
	{
		if (!cell) 
		{
			cell = [[ItemTableCellView alloc] initWithReuseIdentifier:nil];
		}
		[(ItemTableCellView*)cell setItem:(Item*)content];
		
		[(ItemTableCellView*)cell setExpanded:(contentArray.count > indexPath.row+1 
						 && [[contentArray objectAtIndex:indexPath.row+1] isKindOfClass:[DetailItem class]]) ];
			
	}
	else if ([content isKindOfClass:[DetailItem class]])
	{
		if (!cell) 
		{
			cell = [ [DetailTableViewCell alloc] initWithReuseIdentifier:nil];
		}
		[(DetailTableViewCell*)cell setDetailItem:(DetailItem*)content];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([cell isKindOfClass:[DetailTableViewCell class]])
	{
		cell.backgroundColor = kHeadingTintColor;
	}
}


#pragma mark -
#pragma mark Table view delegate


- (void) expandCellAtIndexPath: (NSIndexPath*) indexPath
{
	NSObject* selectedContent = [contentArray objectAtIndex:indexPath.row];
	if( [selectedContent isKindOfClass:[Item class]], @"invalid content state on expand" );
	
	NSLog(@"inserting detail for row: %i",indexPath.row);
	NSIndexPath* insertIdx = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
	
	[self beginUpdates];
	[(ItemTableCellView*)[self cellForRowAtIndexPath:indexPath] setExpanded:YES];
	[contentArray insertObject:[(Item*)selectedContent content] atIndex:insertIdx.row];
	[self insertRowsAtIndexPaths:[NSArray arrayWithObject:insertIdx] withRowAnimation:UITableViewRowAnimationTop];
	[self endUpdates];
	
	self.expandedItemIndex = indexPath;
}

- (void) collapseExpandedCell
{
	NSIndexPath* indexPath = self.expandedItemIndex;
	if (indexPath)
	{
		NSLog(@"removing detail for row: %i",indexPath.row);
		NSIndexPath* deleteIdx = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
		
		[self beginUpdates];
		[(ItemTableCellView*)[self cellForRowAtIndexPath:indexPath] setExpanded:NO];
		[contentArray removeObjectAtIndex:deleteIdx.row];
		[self deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIdx] withRowAnimation:UITableViewRowAnimationTop];
		[self endUpdates];
		
		self.expandedItemIndex = nil;
	}
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (indexPath.row < 1) return;
	
	NSLog(@"tableView:didSelectRowAtIndexPath:%@",indexPath);
	NSIndexPath* selectedIndex = [self.expandedItemIndex copy];
	[self collapseExpandedCell];
	if (selectedIndex && selectedIndex.row < indexPath.row)
	{
		indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
	}
	
	NSObject* content = [contentArray objectAtIndex:indexPath.row];
	if ([content isKindOfClass:[Item class]])
	{
		ItemTableCellView* cell = (ItemTableCellView*)[self cellForRowAtIndexPath:indexPath];
		if( cell != selectedCell )
		{
			[self expandCellAtIndexPath:indexPath];
			[_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
			self.selectedCell = cell;
		}
		else
			self.selectedCell = nil;
	}
	else
	{
		if (indexPath != selectedIndex)
		{
			[self expandCellAtIndexPath:indexPath];
			[_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
		}
	}
}

-(void) expandItem:(NSUInteger)itemNum
{
	[self collapseExpandedCell];
	int homeItemCounter = 0;
	NSIndexPath* indexPath = nil;
	for (int i=0; i<contentArray.count; i++)
	{
		NSObject* obj = [contentArray objectAtIndex:i];
		if ([obj isKindOfClass:[Item class]])
		{
			if (homeItemCounter == itemNum)
			{
				indexPath = [NSIndexPath indexPathForRow:i inSection:0];
				break;
			}
			else homeItemCounter++;
		}
	}
	if (indexPath )
	{
		[self expandCellAtIndexPath:indexPath];
		[self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}		
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.expandedItemIndex = nil;
}


@end

