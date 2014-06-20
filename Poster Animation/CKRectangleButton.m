//
//  CKRectangleButton.m
//  Mozart
//
//  Created by John Basile on 5/25/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKRectangleButton.h"

@implementation CKRectangleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame andTouchCallback:NULL];
    if (self)
	{

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		appearance:(int)look
{
    self = [super initWithFrame:frame
						  Title:title
					andSubTitle:subTitle
					 buttonType:kRectangleButton
					 appearance:look
			   andTouchCallback:NULL];
    if (self)
	{
		
    }
    return self;
	
}

-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		appearance:(int)look
  andTouchCallback:(void(^)(void))touchCallback
{
    self = [super initWithFrame:frame
						  Title:title
					andSubTitle:subTitle
					 buttonType:kRectangleButton
					 appearance:look
			   andTouchCallback:touchCallback];
    if (self)
	{
		
    }
    return self;
	
}


-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		  addImage:(UIImage *)icon
  andSelectedImage:(UIImage *)selectedIcon
		appearance:(int)look
  andTouchCallback:(void(^)(void))touchCallback
{
    self = [super initWithFrame:frame
						  Title:title
					andSubTitle:subTitle
					 buttonType:kRectangleButton
					 appearance:look
			   andTouchCallback:touchCallback];
    if (self)
	{
//		CGRect rect = CGRectMake(0, 0, icon.size.width, icon.size.height);
//		[self addImage:rect icon:icon selectedIcon:selectedIcon];
		if( icon )
			[self setImage:icon forState:UIControlStateNormal];
		if( selectedIcon )
			[self setImage:selectedIcon forState:UIControlStateSelected];
    }
    return self;
}
@end



