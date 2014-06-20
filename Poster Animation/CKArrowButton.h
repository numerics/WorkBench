//
//  CKArrowButton.h
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKButton.h"
typedef enum
{
    CKArrowButtonDirectionRight,
    CKArrowButtonDirectionDown,
    CKArrowButtonDirectionLeft,
    CKArrowButtonDirectionUp
} CKArrowButtonDirection;

@interface CKArrowButton : CKButton

@property (nonatomic, strong) UIColor           *normalColor;
@property (nonatomic, strong) UIColor           *highlightedColor;

@property (nonatomic) CKArrowButtonDirection    direction;


@end
