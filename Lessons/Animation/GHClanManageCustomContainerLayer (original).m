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
        self.headerView = [[GHCustomContainerLayer alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        self.headerView.addTopLeftNotch = YES;
        self.headerView.borderColor = [UIColor colorWithHexString:@"0x666666"];
        self.headerView.startColor = [UIColor colorWithHexString:@"0x222222"];
        self.headerView.endColor = [UIColor colorWithHexString:@"0x000000"];
        self.headerView.shouldCreateGradient = YES;
        self.headerView.addShadow = YES;
        self.headerView.fillColor = [UIColor blackColor];
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
        
        // default alpha
        self.alpha = 0.8;
        CGRect cFrame = CGRectMake(0, 0, frame.size.width, frame.size.height - 30.0);
        self.containerView = [[GHCustomContainerLayer alloc] initWithFrame:cFrame andAlpha: self.alpha];
        self.containerView.borderColor = [UIColor colorWithHexString:@"0x666666"];
        self.containerView.backgroundColor = [UIColor colorWithHexString:@"0x222222"];
        [self addSubview:self.containerView];
        [self.containerView commit];

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withContainerAlpha:(CGFloat)alpha
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.headerView = [[GHCustomContainerLayer alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        self.headerView.addTopLeftNotch = YES;
        self.headerView.borderColor = [UIColor colorWithHexString:@"0x666666"];
        self.headerView.startColor = [UIColor colorWithHexString:@"0x222222"];
        self.headerView.endColor = [UIColor colorWithHexString:@"0x000000"];
        self.headerView.shouldCreateGradient = YES;
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
        self.containerView = [[GHCustomContainerLayer alloc] initWithFrame:cFrame andAlpha:alpha];
        self.containerView.borderColor = [UIColor colorWithHexString:@"0x666666"];
        self.containerView.backgroundColor = [UIColor colorWithHexString:@"0x222222"];
        self.containerView.layer.opacity = alpha;
        [self addSubview:self.containerView];
        [self.containerView commit];
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
//    self.headerView.left = self.left;
//    self.headerView.top = self.top;
    
    self.containerView.left = self.headerView.left;
    self.containerView.top = self.headerView.bottom;
    
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
