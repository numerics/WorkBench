//
//  CKRectangleButton.h
//  Mozart
//
//  Created by John Basile on 5/25/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKCustomButton.h"

@interface CKRectangleButton : CKCustomButton

-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		appearance:(int)look;


-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		appearance:(int)look
  andTouchCallback:(void(^)(void))touchCallback;

-(id)initWithFrame:(CGRect)frame
			 Title:(NSString *)title
	   andSubTitle:(NSString *)subTitle
		  addImage:(UIImage *)icon
  andSelectedImage:(UIImage *)selectedIcon
		appearance:(int)look
  andTouchCallback:(void(^)(void))touchCallback;

@end
