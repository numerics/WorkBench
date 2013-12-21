//
//  CTLinkButton.m
//
//  Created by John Basile on 4/25/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import "CTLinkButton.h"

@implementation CTLinkButton
@synthesize link, font, fontSize, title, label;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		label = [[UIButton alloc] initWithFrame:CGRectMake(-5.0, -5.0, self.layer.bounds.size.width+10, self.layer.bounds.size.height+10)];
    }
    return self;
}

-(void)buildStringLayerWithFont:(NSString *)ft andSize:(CGFloat)fs usingDelegate:(id)theDelegate theSelector:(SEL)requestSelector
{
    
	label.titleLabel.font = [UIFont fontWithName:ft size:fs];
	label.titleLabel.textColor = [UIColor whiteColor];
	
	[label setTitle:title forState:UIControlStateHighlighted];
	[label setBackgroundImage:[UIImage imageNamed:@"touchBg.png"] forState:UIControlStateHighlighted];
	
	label.titleLabel.textAlignment = NSTextAlignmentCenter;
	label.titleLabel.backgroundColor = [UIColor clearColor];
	
	label.layer.cornerRadius = label.bounds.size.height/4;
	label.layer.masksToBounds = YES;
	
	[self addSubview:label];
	
//	[label addTarget:theDelegate action:@selector(requestSelector:) forControlEvents:UIControlEventTouchUpInside];
	[label addTarget:theDelegate action:requestSelector forControlEvents:UIControlEventTouchUpInside];
	
	
	[label addTarget:self action:@selector(activateNormalButtons:) forControlEvents:UIControlStateHighlighted];
	[label addTarget:self action:@selector(activateHighilitButtons:) forControlEvents:UIControlEventTouchCancel];
}

-(void)buildStringLayerWithFont:(NSString *)ft andSize:(CGFloat)fs
{	
	label.titleLabel.font = [UIFont fontWithName:ft size:fs];
	label.titleLabel.textColor = [UIColor whiteColor];
	
	[label setTitle:title forState:UIControlStateHighlighted];
	[label setBackgroundImage:[UIImage imageNamed:@"touchBg.png"] forState:UIControlStateHighlighted];
	
	label.titleLabel.textAlignment = NSTextAlignmentCenter;
	label.titleLabel.backgroundColor = [UIColor clearColor];
	
	label.layer.cornerRadius = label.bounds.size.height/4;
	label.layer.masksToBounds = YES;
	
	[self addSubview:label];
	
	[label addTarget:self action:@selector(actionTaped:) forControlEvents:UIControlEventTouchUpInside];
	
	
	[label addTarget:self action:@selector(activateNormalButtons:) forControlEvents:UIControlStateHighlighted];
	[label addTarget:self action:@selector(activateHighilitButtons:) forControlEvents:UIControlEventTouchCancel];
}

-(UIButton *)linkdButton
{
	return linkdButton;
}

-(void) setLinkdButton:(UIButton *)button
{
	linkdButton = button;
}

-(void)activateNormalButtons:(id)sender
{
	if(linkdButton)
	{
		linkdButton.highlighted = YES;
	}
}

-(void)activateHighilitButtons:(id)sender
{
	if(linkdButton)
	{
		linkdButton.highlighted = NO;
	}
}

-(void)actionTaped:(id)sender
{
	NSLog(@"link is %@",link);
	if(linkdButton)
	{
		linkdButton.highlighted = NO;
	}
}



@end
