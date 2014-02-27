//
//  WorkBenchAppDelegate.h
//  WorkBench
//
//  Created by John Basile on 1/5/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkBenchViewController;

@interface WorkBenchAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow						*window;
    UINavigationController			*navigationController;
    WorkBenchViewController         *benchViewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController	*navigationController;
@property (nonatomic, strong) IBOutlet WorkBenchViewController *benchViewController;

@end

