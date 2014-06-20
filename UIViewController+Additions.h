//
//  UIViewController+Additions.h
//  Mozart
//
//  Created by John Basile on 4/23/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

- (UIViewController *)findParentViewControllerOfType:(Class)classType forViewController:(UIViewController *)viewController;

@property (nonatomic, readonly) UIViewController *topViewController;

@end
