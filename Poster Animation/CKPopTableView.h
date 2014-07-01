//
//  GHPopTableView.h
//  GhostKit
//
//  Created by Basile, John on 10/9/13.
//  Copyright (c) 2013 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKLabel.h"
#import "CKDynamicButton.h"

typedef enum
{
    kTPlatform = 1,
    kTTBD1,
    kTTBD2,
} popTableType;


@class PopCell;

@interface CKPopTableView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView                 *menuTable;
    
}
@property (nonatomic, strong) UITableView *menuTable;

@property (nonatomic, strong) NSDictionary      *dataDict;
@property (nonatomic, strong) NSDictionary      *imgDict;
@property (nonatomic, strong) NSDictionary      *selImgDict;
@property (nonatomic, strong) NSMutableArray    *dataOffset;

@property (nonatomic, assign) BOOL labelCentric;
@property (nonatomic, assign) int selectedItem;

- (id)initWithFrame:(CGRect)frame titleDict:(NSDictionary *)titleDict item:(int)selectedItem;
@end



//////////////////////////////////////////////////////////////////////////////////////////
@class GHPopBackingView;

@interface PopCell : UITableViewCell
{
    UIImageView             *iconImage;
    CKLabel                 *Label;
    BOOL                    labelCentric;
}
@property (nonatomic, strong) UIImageView       *iconImage;
@property (nonatomic, strong) CKLabel           *Label;
@property (nonatomic, assign) BOOL              labelCentric;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier small:(BOOL)small;

@end

//////////////////////////////////////////////////////////////////////////////////////////

@interface GHPopBackingView : UIView
{
    UIColor       *lineColor;
}
@property (nonatomic, strong) UIColor       *lineColor;

@end
