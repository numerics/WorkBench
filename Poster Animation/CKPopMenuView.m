//
//  CKPopMenuView.m
//  WorkBench
//
//  Created by Basile, John on 10/9/13.
//  Copyright (c) 2013 Numerics. All rights reserved.
//

#import "CKPopMenuView.h"
@interface CKPopMenuView()
{
    void (^_touchCallback)(void);
}

@end

@implementation CKPopMenuView
@synthesize menuTable,theButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformSelection:) name:@"kselectedPlatform" object:nil];
    }
    self.clipsToBounds = NO;
    return self;
}

- (id)initWithFrame:(CGRect)frame titleDict:(NSDictionary *)titleDict item:(int)selectedItem
{
    int cnt  = [titleDict count] + 1;   // added item for the button
    CGFloat hgt = cnt * frame.size.height;
    self.trueFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, hgt);
    self.btnFrame = frame;
    self = [self initWithFrame:self.trueFrame];
    if (self )
    {
        self.dataDict = titleDict;
        self.imgDict = nil;
        self.selImgDict = nil;
        self.labelCentric = YES;
        
        [self setUpView:self.trueFrame item:selectedItem];
        self.frame = frame;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem
{
    int cnt  = [titleDict count] + 1;   // added item for the button
    CGFloat hgt = cnt * frame.size.height;
    CGRect trueFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, hgt);
    self.btnFrame = frame;
    
    self = [self initWithFrame:trueFrame];
    if (self )
    {
        self.dataDict = titleDict;
        self.imgDict = iconDict;
        self.selImgDict = nil;
        if( !iconDict )
        {
            self.labelCentric = YES;
        }
        [self setUpView:trueFrame item:selectedItem];
        self.frame = frame;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict selectedIconDict:(NSDictionary *)selectDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem
{
    int cnt  = [titleDict count] + 1;
    CGFloat hgt = cnt * frame.size.height;
    self.trueFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, hgt);
    self.btnFrame = frame;
    
    self = [self initWithFrame:self.trueFrame];
    if (self )
    {
        self.dataDict = titleDict;
        self.imgDict = iconDict;
        self.selImgDict = selectDict;
        if( !iconDict )
        {
            self.labelCentric = YES;
        }
        [self setUpView:self.trueFrame item:selectedItem];
        self.frame = frame;
    }
    return self;
}

- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];
    
    return (NSDictionary *)mutableDictionary;
}

- (id)initWithFrame:(CGRect)frame displayDataArray:(NSDictionary *)data item:(int)selectedItem
{
    int cnt  =  [[self indexKeyedDictionaryFromArray:[data objectForKey:@"titles"]]count];
    CGFloat hgt = cnt * frame.size.height;
    self.trueFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, hgt);
    self.btnFrame = frame;
    
    self = [self initWithFrame:self.trueFrame];
    if (self )
    {
        NSArray *icons  = [data objectForKey:@"icons"];
        NSArray *sIcons = [data objectForKey:@"selectedIcons"];
        NSArray *titles = [data objectForKey:@"titles"];
        
        if( [icons count] > 0)
            self.imgDict = [self indexKeyedDictionaryFromArray:icons];

        if( [sIcons count] > 0)
            self.selImgDict = [self indexKeyedDictionaryFromArray:sIcons];

        if( [titles count] > 0)
            self.dataDict = [self indexKeyedDictionaryFromArray:titles];
    }
    [self setUpView:self.trueFrame item:selectedItem];
    self.frame = frame;

    return self;
    
}

- (void)setUpView:(CGRect)frame item:(int)selectedItem
{
    self.backgroundColor = [UIColor clearColor];
    
    if( !self.imgDict )
        self.theButton = [[MenuButton alloc] initWithFrame:self.btnFrame titleDict:self.dataDict item:selectedItem];
    else
        self.theButton = [[MenuButton alloc] initWithFrame:self.btnFrame iconDict:self.imgDict selectedIconDict:self.selImgDict titleDict:self.dataDict item:selectedItem];
    [self addSubview:self.theButton];
    
    self.theButton.titleLabel.font = [UIFont fontWithName:@"Bourgeois-Med" size:(isiPad() ? 14.0 : 13.0)];
    [self.theButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.menuSelected = NO;
    [self.theButton commit];
    
    CGRect tableFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.menuTable = [[UITableView alloc] initWithFrame:tableFrame];
    self.menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTable.backgroundColor = [UIColor clearColor];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    self.menuTable.clipsToBounds = NO;
    [self addSubview:self.menuTable];
    self.menuTable.scrollEnabled = YES;
    self.menuTable.hidden = YES;
}

- (void) menuButtonPressed
{
    if( self.menuSelected )
    {
        self.menuSelected = NO;
        self.menuTable.hidden = YES;
        self.frame = self.btnFrame;
    }
    else
    {
        self.menuSelected = YES;
        self.menuTable.hidden = NO;
        self.frame = self.trueFrame;
    }
    [self.menuTable scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];

    [self setNeedsDisplay];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.top = 0;
    self.theButton.left = 0;
    self.theButton.top = 0;
    self.menuTable.left = self.theButton.left;
    self.menuTable.top = self.theButton.bottom;
 }

- (void) platformSelection:(NSNotification *)notification
{
    NSIndexPath *indexPath = (NSIndexPath*) [notification object];
    self.menuSelected = NO;

    int row = indexPath.row + 1;
    NSString *title = [self.dataDict objectForKey:[NSString stringWithFormat:@"%d",row]];
    self.theButton.titleLabel.text = title;
    if(self.imgDict)
    {
        NSString *imageName = [self.imgDict objectForKey:[NSString stringWithFormat:@"%d",row]];
        self.theButton.iconImage.image = [UIImage imageNamed:imageName];
        imageName = [self.selImgDict objectForKey:[NSString stringWithFormat:@"%d",row]];
        self.theButton.selectedImage.image = [UIImage imageNamed:imageName];
        
        if( row == 1)
            [self.theButton.iconImage setFrame:CGRectMake(9, 9, 25, 25)];           // XBOX
        else if (row == 2)
            [self.theButton.iconImage setFrame:CGRectMake(4, 10, 26, 20)];            //Play Station
        else
            [self.theButton.iconImage setFrame:CGRectMake(10, 15, 32, 15)];           // STEAM
        
        [self.theButton.selectedImage setFrame:self.theButton.iconImage.frame];

    }
    self.frame = self.btnFrame;
    self.menuTable.hidden = YES;
    
    self.theButton.titleLabel.hidden = NO;
    self.theButton.normalIcon.hidden = NO;
    self.theButton.selectedIcon.hidden = YES;
    [self.theButton bringSubviewToFront:self.theButton.normalIcon];
    
    if( self.theButton.iconImage )
    {
        self.theButton.iconImage.hidden = NO;
        self.theButton.selectedImage.hidden = YES;
    }
    [self.theButton update];
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		if( self.labelCentric )
            cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier small:YES];
        else
            cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 	}
	cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.backgroundColor = [UIColor clearColor];
    int row = indexPath.row + 1;
    if( self.labelCentric )
    {
        NSString *title = [self.dataDict objectForKey:[NSString stringWithFormat:@"%d",row]];
        cell.Label.text = title;
    }
    else
    {
        if( self.imgDict )
        {
            NSString *imageName = [self.imgDict objectForKey:[NSString stringWithFormat:@"%d",row]];
            cell.iconImage.image = [UIImage imageNamed:imageName];
            cell.iconImage.contentMode = UIViewContentModeScaleToFill;
             if( row == 1)
                [cell.iconImage setFrame:CGRectMake(15, 10, 25, 25)];           // XBOX
            else if (row == 2)
                [cell.iconImage setFrame:CGRectMake(15, 10, 26, 20)];            //PS3-PS4
            else
                [cell.iconImage setFrame:CGRectMake(10, 15, 32, 15)];           // STEAM

        }
        NSString *title = [self.dataDict objectForKey:[NSString stringWithFormat:@"%d",row]];
        cell.Label.text = title;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kselectedPlatform" object:indexPath];
    
    int row = indexPath.row + 1;
    if( row )
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XBOX_PlatformSelected" object:indexPath];
    else if(row == 2)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PSN_PlatformSelected" object:indexPath];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STEAM_PlatformSelected" object:indexPath];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////

@implementation MenuCell
@synthesize iconImage,Label,labelCentric;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.labelCentric = NO;
        self.iconImage = [[UIImageView alloc] init];
        self.iconImage.contentMode = UIViewContentModeScaleToFill;

        [self.contentView  addSubview:self.iconImage];
        
        self.Label = [[CKLabel alloc] init];
        [self.Label setFrame:CGRectMake(0, 0, 95, 20)];
        self.Label.textAlignment = NSTextAlignmentLeft;
        self.Label.backgroundColor = [UIColor clearColor];
        
        [self.Label setTextColor:[UIColor whiteColor]];
        [self.Label setFont:[UIFont fontWithName:@"Bourgeois-Med" size:14.0]];
        [self.contentView addSubview:self.Label];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        CKMenuBackingView *bckView = [[CKMenuBackingView alloc] initWithFrame:self.frame];
        self.backgroundView = bckView;
        
        bckView.lineColor = [UIColor colorWithHexString:@"0xAAAAAA"];
        self.backgroundView.alpha = 0.95;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier small:(BOOL)small
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.labelCentric = YES;
        self.Label = [[CKLabel alloc] init];
        [self.Label setFrame:CGRectMake(0, 0, 70, 30)];
        self.Label.textAlignment = NSTextAlignmentCenter;
        self.Label.backgroundColor = [UIColor clearColor];
        self.Label.numberOfLines = 2;
        [self.Label setTextColor:[UIColor whiteColor]];
        [self.Label setFont:[UIFont fontWithName:@"Bourgeois-Med" size:13.0]];
        [self.contentView addSubview:self.Label];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        CKMenuBackingView *bckView = [[CKMenuBackingView alloc] initWithFrame:self.frame];
        self.backgroundView = bckView;
        
        bckView.lineColor = [UIColor colorWithHexString:@"0xAAAAAA"];
        self.backgroundView.alpha = 0.95;
    }
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if( !selected )
        [self setDefaultStyle];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if(!highlighted)
        return;
    
    CKMenuBackingView *bckView = (CKMenuBackingView *)self.backgroundView;
    bckView.lineColor = [UIColor colorWithHexString:@"ffe03f"];
    bckView.alpha = 1.0;
    [bckView setNeedsDisplay];
    [super setHighlighted:highlighted animated:animated];
}

- (void) setDefaultStyle
{
    CKMenuBackingView *bckView = (CKMenuBackingView *)self.backgroundView;
    bckView.lineColor = [UIColor colorWithHexString:@"0xAAAAAA"];
    bckView.alpha = 0.95;
    [bckView setNeedsDisplay];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if( self.labelCentric )
    {
        self.Label.horizontalCenter = self.contentView.horizontalCenter;
        self.Label.verticalCenter = self.contentView.verticalCenter;
    }
    else
    {
        self.Label.left = 60;
        self.Label.verticalCenter = self.contentView.verticalCenter;
    }
}

@end


//////////////////////////////////////////////////////////////////////////////////////////

@implementation CKMenuBackingView
@synthesize lineColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* rectangleFill = [UIColor colorWithHexString:@"0x222222"];
    UIColor* ShadowColor = [UIColor colorWithRed: 0 green: 0.0 blue: 0.0 alpha: 0.8];
    
    
    //// Shadow Declarations
    CGSize ShadowOffset = CGSizeMake(0.1, 2.1);
    CGFloat ShadowBlurRadius = 6;
    
    {
        //// Rectangle Drawing
        CGFloat right = rect.size.width;
        CGFloat bottom = rect.size.height;
        CGFloat left = 0.0;
        CGFloat top = 0.0;
        
        //CGContextSetAlpha(context, 0.7);
        UIBezierPath* rectanglePath = [UIBezierPath bezierPath];
        [rectanglePath moveToPoint: CGPointMake(left, top)];
        [rectanglePath addLineToPoint: CGPointMake(right, top)];
        [rectanglePath addLineToPoint: CGPointMake(right, bottom)];
        [rectanglePath addLineToPoint: CGPointMake(left, bottom)];
        [rectanglePath addLineToPoint: CGPointMake(left, top)];
        [rectanglePath closePath];
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, ShadowOffset, ShadowBlurRadius, ShadowColor.CGColor);
        [rectangleFill setFill];
        [rectanglePath fill];
        CGContextRestoreGState(context);
        
        [self.lineColor  setStroke];
        rectanglePath.lineWidth = 1.0;
        [rectanglePath stroke];
    }
    
}

@end

//////////////////////////////////////////////////////////////////////////////////////////

@implementation MenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.btnSelected = NO;
        self.clipsToBounds = YES;

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame titleDict:(NSDictionary *)titleDict item:(int)selectedItem
{
    self = [self initWithFrame:frame];
    if (self )
    {
        self.clipsToBounds = NO;
        [self setUpTitle:frame title:[titleDict objectForKey:[NSString stringWithFormat:@"%d",selectedItem]]];
        self.titleLabel.numberOfLines = 2;
        [self setAlignLabel:kLabelCenter];
        self.titleLabel.frame = CGRectMake(0, 0, 45.0, 44.0);
        [self addImage:CGRectMake(0, 0, 10, 10) icon:[UIImage imageNamed:@"up_arrow_white"] selectedIcon:[UIImage imageNamed:@"down_arrow_black"] align:kIconRight];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem
{
    self = [self initWithFrame:frame];
    if (self )
    {
        
        CGRect hFrame = CGRectMake(0, 0, frame.size.height, frame.size.height);
        [self addImage:CGRectMake(0, 0, 12, 12) icon:[UIImage imageNamed:@"up_arrow_white"] selectedIcon:[UIImage imageNamed:@"down_arrow_black"] align:kIconRight];
        
        NSString *imageName = [iconDict objectForKey:[NSString stringWithFormat:@"%d",selectedItem]];
        self.iconImage = [[UIImageView alloc] initWithFrame:hFrame];
        self.iconImage.image = [UIImage imageNamed:imageName];
        self.iconImage.contentMode = UIViewContentModeScaleToFill;
        [self.iconImage setFrame:CGRectMake(0, 0, 25.0, 25.0)];

        [self addSubview:self.iconImage];
        
        [self setUpTitle:hFrame title:[titleDict objectForKey:[NSString stringWithFormat:@"%d",selectedItem]]];
        [self.titleLabel sizeToFit];
        [self setAlignLabel:kLabelCenter];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict selectedIconDict:(NSDictionary *)selectDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem;
{
    self = [self initWithFrame:frame];
    if (self )
    {
        
        CGRect hFrame = CGRectMake(0, 0, frame.size.height, frame.size.height);
        [self addImage:CGRectMake(0, 0, 12, 12) icon:[UIImage imageNamed:@"down_arrow_white"] selectedIcon:[UIImage imageNamed:@"up_arrow_black"] align:kIconRight];
        
        NSString *imageName = [iconDict objectForKey:[NSString stringWithFormat:@"%d",selectedItem]];
        self.iconImage = [[UIImageView alloc] initWithFrame:hFrame];
        self.iconImage.image = [UIImage imageNamed:imageName];
        [self.iconImage setFrame:CGRectMake(0, 0, 25.0, 25.0)];
        self.iconImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.iconImage];
        
        imageName = [selectDict objectForKey:[NSString stringWithFormat:@"%d",selectedItem]];
        self.selectedImage = [[UIImageView alloc] initWithFrame:hFrame];
        self.selectedImage.image = [UIImage imageNamed:imageName];
        self.selectedImage.contentMode = UIViewContentModeScaleToFill;
        [self.selectedImage setFrame:CGRectMake(0, 0, 25.0, 25.0)];

        [self addSubview:self.selectedImage];
        self.selectedImage.hidden = YES;
        int row = selectedItem;
        
        if( row == 1)
            [self.iconImage setFrame:CGRectMake(9, 9, 25, 25)];           // XBOX
        else if (row == 2)
            [self.iconImage setFrame:CGRectMake(7, 17, 26, 20)];            //PS3-PS4
        else
            [self.iconImage setFrame:CGRectMake(10, 15, 32, 15)];           // STEAM
        
        
        self.offSetLabel_X = 15;
        [self.selectedImage setFrame:self.iconImage.frame];

        [self setUpTitle:hFrame title:[titleDict objectForKey:[NSString stringWithFormat:@"%d",selectedItem]]];
        [self.titleLabel sizeToFit];
        [self setAlignLabel:kLabelCenter];
    }
    return self;
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if( !self.iconImage )
    {
        self.titleLabel.left = 0.0;
        self.titleLabel.top = 0.0;
        self.normalIcon.right = self.right - 5;
        self.selectedIcon.right = self.right - 5;
    }
}

- (void) setHighlighted: (BOOL) highlighted
{
    if( highlighted && self.btnSelected == YES)
    {
        self.titleLabel.highlighted = YES;
        [self bringSubviewToFront:self.titleLabel];
        if( self.normalIcon && self.selectedIcon)
        {
            self.normalIcon.hidden = NO;
            self.selectedIcon.hidden = YES;
            [self bringSubviewToFront:self.normalIcon];
        }
        if( self.iconImage )
        {
            self.iconImage.hidden = NO;
            self.selectedImage.hidden = YES;
        }
        [self update];
    }
    else if( highlighted && self.btnSelected == NO)
    {
        [shapeLayer removeFromSuperlayer];
        [self.layer addSublayer:selectedStateBackgroundLayer];
        [self bringSubviewToFront:self.titleLabel];
        self.titleLabel.highlighted = NO;
        if( self.iconImage )
        {
            self.iconImage.hidden = YES;
            self.selectedImage.hidden = NO;
            [self bringSubviewToFront:self.selectedImage];

        }
        if( self.subTitle)
        {
            [self bringSubviewToFront:self.subTitle];
            self.subTitle.hidden = YES;
        }
        if( self.normalIcon && self.selectedIcon)
        {
            self.normalIcon.hidden = YES;
            self.selectedIcon.hidden = NO;
            [self bringSubviewToFront:self.selectedIcon];
        }
    }
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.btnSelected = NO;

}
@end






