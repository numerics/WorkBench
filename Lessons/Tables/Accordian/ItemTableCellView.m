//
//  ItemTableCellView.m
//
//  Created by John Basile on 8/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "ItemTableCellView.h"
#import "UIFactory.h"

@implementation ItemTableCellView
@synthesize item;

@synthesize expanded;

- (void)setExpanded:(BOOL)e
{
	expanded = e;
	[self setNeedsLayout];
}

- (void) layoutSubviews 
{
	[super layoutSubviews];
	
	if (originalTitleY == 0)
	{
		originalTitleY = self.titleLabel.center.y;
	}
	self.titleLabel.text    = item.title;
	self.imageView.image    = item.icon;
	UIImage* arrow;
	CGPoint newCenter = self.titleLabel.center;
	if (expanded) 
	{
		arrow = [UIImage imageNamed:@"icon-triangle-down.png"];
		self.detailLabel.hidden = YES;
		newCenter.y = self.accessoryView.center.y;//self.imageView.center.y;
	}
	else 
	{
		arrow = [UIImage imageNamed:@"icon-triangle-up.png"];
		self.detailLabel.hidden = NO;
		self.detailLabel.text = item.detail;
		newCenter.y = originalTitleY;
	}
	[(UIImageView*)self.accessoryView setImage:arrow];
	self.titleLabel.center = newCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.detailLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel setLabelApperance:@"AM1400L"];
    [self.detailLabel setLabelApperance:@"AM1195L"];
    self.titleLabel.left = 60.0;
    self.titleLabel.top = (self.detailLabel.hidden) ? 14 : 18.0;
    self.detailLabel.left = 60.0;
    self.detailLabel.top = self.titleLabel.bottom;
    
	//[[UIFactory sharedInstance] adjustLabelSizeToFitText:self.titleLabel];
    
	[self setNeedsDisplay];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        // Initialization code.
		self.backgroundView = [[UIImageView alloc] initWithImage:kItemTableCellBackgroundImage];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
		self.titleLabel = [[CKLabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width - 80.0, 18)];
		self.detailLabel = [[CKLabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width - 80.0, 22)];
		
        
        self.titleLabel.backgroundColor = [UIColor clearColor];
		self.titleLabel.textColor = kHeadingTintColor;
		
		self.detailLabel.backgroundColor = [UIColor clearColor];
		self.detailLabel.numberOfLines = 2;
		
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        
		self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-triangle-up.png"]];
		
		originalTitleY = 0;
    }
    return self;
}

@end
