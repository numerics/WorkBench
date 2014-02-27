//
//  GHClanManageCustomContainerLayer.m
//  WorkBench
//
//  Created by Basile, John on 8/26/13.
//
//

#import "GHClanManageCustomContainerLayer.h"

@implementation GHClanManageCustomContainerLayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.headerView = [[GHCustomContainerLayer alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        self.headerView.addTopLeftNotch = YES;
        self.headerView.shouldCreateGradient = YES;
        self.headerView.addShadow = YES;
        self.headerView.borderColor = [UIColor whiteColor];

        [self addSubview:self.headerView];
        [self.headerView commit];
       
        self.headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headerBtn setFrame:CGRectMake(0, 0, frame.size.width, 25)];
        [self.headerBtn setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.headerBtn];
        
        self.headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, -8, 200, 14)];
        [self.headerTitle setTextColor:[UIColor whiteColor]];
        [self.headerTitle setFont:[UIFont fontWithName:@"EurostileBold" size:16.0]];
        [self.headerTitle setBackgroundColor:[UIColor clearColor]];

        [self.headerBtn addSubview:self.headerTitle];
        
        UIImage *accessoryImage = [UIImage imageNamed:@"little_arrow_white"];
        self.accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,accessoryImage.size.width , accessoryImage.size.height)];
        [self.accessoryImageView setImage:accessoryImage];
        
        CGRect cFrame = CGRectMake(0, 0, frame.size.width, frame.size.height - 30.0);
        self.containerView = [[GHCustomContainerLayer alloc] initWithFrame:cFrame];
        self.containerView.addShadow = YES;
        //self.alpha = 0.8;
        //self.containerView.backgroundColor = [UIColor colorWithHexString:@"0x222222" withAlpha:0.8];

        //[self.containerView setColorApperance:kFillColor WithHexString:@"0x222222" withAlpha:0.4];

        [self addSubview:self.containerView];
        [self.containerView commit];

    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.containerView.left = self.headerView.left;
    self.containerView.top = self.headerView.bottom + 2;
    
    self.headerTitle.left = self.headerBtn.left + 20;
    self.headerTitle.top = self.headerBtn.top + 8;
    
    self.accessoryImageView.right = self.headerBtn.right - 10;
    self.accessoryImageView.top = self.headerBtn.top + 10;
    
    self.headerBtn.left = self.headerView.left + 1;
    self.headerBtn.top = self.headerView.top + 2;
    
}


- (BOOL)isAccessibilityElement
{
    return NO;
}

@end
