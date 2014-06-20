//
//  UIViewController+Additions.m
//  Mozart
//
//  Created by John Basile on 4/23/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (UIViewController *)findParentViewControllerOfType:(Class)classType forViewController:(UIViewController *)viewController
{
    if(viewController.parentViewController == nil)
    {
        return nil;
    }
    else if([viewController.parentViewController isKindOfClass:classType])
    {
        return viewController.parentViewController;
    }
    else
    {
        return [self findParentViewControllerOfType:classType forViewController:viewController.parentViewController];
    }
}



-(UIViewController *)topViewController
{
    if(self.childViewControllers.count == 0)
    {
        return nil;
    }
    
    return [self.childViewControllers lastObject];
}

@end
