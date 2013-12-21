//
//  GHClanManageCustomContainerLayer.h
//  WorkBench
//
//  Created by Basile, John on 8/26/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIColor+EliteKit.h"
#import "UIView+EliteKit.h"

#import "GHCustomContainerLayer.h"


@interface GHClanManageCustomContainerLayer : UIView
{
    
}
@property (nonatomic, strong) GHCustomContainerLayer *headerView;
@property (nonatomic, strong) UILabel *headerTitle;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) GHCustomContainerLayer *containerView;


@end
