//
//  GHPopMenuView.h
//  GhostKit
//
//  Created by Basile, John on 10/9/13.
//  Copyright (c) 2013 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKLabel.h"
#import "CKCustomButtonControl.h"

@class MenuCell;
@class MenuButton;

typedef enum
{
    kPlatform = 1,
    kTBD1,
    kTBD2,
} popMenuType;

@interface CKPopMenuView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView                 *menuTable;
    MenuButton                  *theButton;
}
@property (nonatomic, strong) UITableView *menuTable;
@property (nonatomic, strong) MenuButton  *theButton;


@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSDictionary *imgDict;
@property (nonatomic, strong) NSDictionary *selImgDict;
@property (nonatomic, assign) BOOL labelCentric;
@property (nonatomic, assign) int selectedItem;
@property (nonatomic, assign) CGRect trueFrame;
@property (nonatomic, assign) CGRect btnFrame;
@property (nonatomic, assign) BOOL menuSelected;


- (id)initWithFrame:(CGRect)frame titleDict:(NSDictionary *)titleDict item:(int)selectedItem;

- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem;
- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict selectedIconDict:(NSDictionary *)selectDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem;

// keys are icons, selectedIcons, titles
// each is an array of values
- (id)initWithFrame:(CGRect)frame displayDataArray:(NSDictionary *)data item:(int)selectedItem;

@end



//////////////////////////////////////////////////////////////////////////////////////////
@class CKMenuBackingView;

@interface MenuCell : UITableViewCell
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

@interface CKMenuBackingView : UIView
{
    UIColor       *lineColor;
}
@property (nonatomic, strong) UIColor       *lineColor;

@end

//////////////////////////////////////////////////////////////////////////////////////////

@interface MenuButton : CKCustomButtonControl


@property (nonatomic, strong) UIImageView       *iconImage;
@property (nonatomic, strong) UIImageView       *selectedImage;
@property (nonatomic, assign) BOOL              btnSelected;

- (id)initWithFrame:(CGRect)frame titleDict:(NSDictionary *)titleDict item:(int)selectedItem;

- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict selectedIconDict:(NSDictionary *)selectDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem;
- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem;
@end