//
//  AccordianDemo.m
//  WorkBench
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "AccordianDemo.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import "DetailItem.h"
#import "Item.h"
#import "DetailData.h"

@implementation AccordianDemo
@synthesize accordian;


+ (NSString *)className 
{
	return @"Accordian Demo";
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
	}
    return self;
}

#pragma mark Setup the View

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
    DetailData* subItem11 =	[DetailData initWithTarget:self action:@selector(subItemSelected1:) imageNamed:@"subItemImage1" title:@"subItem11"];
    DetailData* subItem12 =	[DetailData initWithTarget:self action:@selector(subItemSelected2:) imageNamed:@"subItemImage2" title:@"subItem12"];
    DetailData* subItem13 =	[DetailData initWithTarget:self action:@selector(subItemSelected3:) imageNamed:@"subItemImage3" title:@"subItem13"];
    DetailData* subItem14 =	[DetailData initWithTarget:self action:@selector(subItemSelected4:) imageNamed:@"subItemImage4" title:@"subItem14"];
    
    DetailData* subItem21 =	[DetailData initWithTarget:self action:@selector(subItemSelected1:) imageNamed:@"subItemImage1" title:@"subItem21"];
    DetailData* subItem22 =	[DetailData initWithTarget:self action:@selector(subItemSelected2:) imageNamed:@"subItemImage2" title:@"subItem22"];
    DetailData* subItem23 =	[DetailData initWithTarget:self action:@selector(subItemSelected3:) imageNamed:@"subItemImage3" title:@"subItem23"];
    DetailData* subItem24 =	[DetailData initWithTarget:self action:@selector(subItemSelected4:) imageNamed:@"subItemImage4" title:@"subItem24"];
    
    DetailData* subItem31 =	[DetailData initWithTarget:self action:@selector(subItemSelected1:) imageNamed:@"subItemImage1" title:@"subItem31"];
    DetailData* subItem32 =	[DetailData initWithTarget:self action:@selector(subItemSelected2:) imageNamed:@"subItemImage2" title:@"subItem32"];
    DetailData* subItem33 =	[DetailData initWithTarget:self action:@selector(subItemSelected3:) imageNamed:@"subItemImage3" title:@"subItem33"];
    
    
    Item* item1 = [[Item alloc] init];
    item1.title  = @"Metro Local Service (1 - 99)";
    item1.detail = @"To/From Downtown Los Angeles";
    item1.icon   = nil;[UIImage imageNamed:@"home-icon-preinterview"];
    item1.content = [[DetailItem alloc] init];
    item1.content.subTableItems = [NSArray arrayWithObjects:subItem11,subItem12,subItem13,subItem14,nil];
    
    
    Item* item2 = [[Item alloc] init];
    item2.title  = @"Metro Local Service (100 - 199)";
    item2.detail = @"East/West routes in other areas";
    item2.icon   = [UIImage imageNamed:@"home-icon-interview"];
    item2.content = [[DetailItem alloc] init];
    item2.content.subTableItems = [NSArray arrayWithObjects:subItem21,subItem22,subItem23,subItem24,nil];
    
    
    Item* item3 = [[Item alloc] init];
    item3.title  = @"Metro Local Service (200 - 299)";
    item3.detail = @"North/South routes in other areas";
    item3.icon   = [UIImage imageNamed:@"home-icon-postinterview"];
    item3.content = [[DetailItem alloc] init];
    item3.content.subTableItems = [NSArray arrayWithObjects:subItem31,subItem32,subItem33,nil];
    CGRect tFrame = CGRectMake(100, 100, 320, 329);
    if( self.accordian == nil )
    {
        self.accordian =[[AccordianTableView alloc] initWithFrame:tFrame style:UITableViewStylePlain];
        //AccordianViewController* srvc = [[AccordianViewController alloc] initWithNibName:@"BlankTableViewController" bundle:nil];
        //self.accordian = srvc;
        self.accordian.contentArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"home-heading.png"],item1,item2,item3,nil];
    }
    [self addSubview:accordian];
    [self.accordian reloadData];

}

- (void) subItemSelected1:(id)sender
{
	
	NSLog(@"subItemSelected1");
    
}


@end


