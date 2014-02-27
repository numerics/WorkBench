//
//  ItemTableCellView.m
//
//  Created by John Basile on 08/18/12.
//  Copyright (c) 2012 Beachbody, LLC. All rights reserved.
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
		originalTitleY = self.textLabel.center.y;
	}
	self.textLabel.text	= item.title;
	self.imageView.image = item.icon;
	UIImage* arrow;
	CGPoint newCenter = self.textLabel.center;
	if (expanded) 
	{
		arrow = [UIImage imageNamed:@"icon-triangle-down.png"];
		self.detailTextLabel.hidden = YES;
		newCenter.y = self.accessoryView.center.y;//self.imageView.center.y;
	}
	else 
	{
		arrow = [UIImage imageNamed:@"icon-triangle-up.png"];
		self.detailTextLabel.hidden = NO;
		self.detailTextLabel.text = item.detail;
		newCenter.y = originalTitleY;
	}
	[(UIImageView*)self.accessoryView setImage:arrow];
	self.textLabel.center = newCenter;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
	//[[UIFactory sharedInstance] adjustLabelSizeToFitText:self.textLabel];
	[self setNeedsDisplay];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	return [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        // Initialization code.
		self.backgroundView = [[UIImageView alloc] initWithImage:kItemTableCellBackgroundImage];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.textColor = kHeadingTintColor;
		
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.numberOfLines = 2;
		
		self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-triangle-up.png"]];
		
		originalTitleY = 0;
    }
    return self;
}

@end
