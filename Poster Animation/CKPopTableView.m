//
//  CKPopTableView.m
//  WorkBench
//
//  Created by Basile, John on 10/15/13.
//  Copyright (c) 2013 Numerics. All rights reserved.
//

#import "CKPopTableView.h"

@implementation CKPopTableView
@synthesize menuTable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataOffset = [[NSMutableArray alloc]init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame titleDict:(NSDictionary *)titleDict item:(int)selectedItem
{
    self = [self initWithFrame:frame];
    if (self )
    {
        self.dataDict = titleDict;
        self.imgDict = nil;
        self.selImgDict = nil;
        
        
        [self setUpView:frame item:selectedItem];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame iconDict:(NSDictionary *)iconDict selectedIconDict:(NSDictionary *)selectDict titleDict:(NSDictionary *)titleDict item:(int)selectedItem
{
    
    self = [self initWithFrame:frame];
    if (self )
    {
        self.dataDict = titleDict;
        self.imgDict = iconDict;
        self.selImgDict = selectDict;
        if( !iconDict )
        {
            self.labelCentric = YES;
        }
        [self setUpView:frame item:selectedItem];
    }
    return self;
}

- (void)setUpView:(CGRect)frame item:(int)selectedItem
{
    self.backgroundColor = [UIColor clearColor];
    
    if(isiPad() )
    {
        self.labelCentric = NO;
        if( !self.imgDict )
        {
            NSString *title;
            NSMutableDictionary *icons = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *sicons = [[NSMutableDictionary alloc] init];
            title = [self.dataDict objectForKey:@"1"];
            if( [title length] > 2 )                                // we got somewthing
            {
                [icons  setObject:@"xbox_white" forKey:@"1"];
                [sicons setObject:@"xbox_blk"   forKey:@"1"];
                [self.dataOffset addObject:@"1"];
            }
            
            title = [self.dataDict objectForKey:@"2"];
            if( [title length] > 2 )                                // we got somewthing
            {
                [icons  setObject:@"psn_white" forKey:@"2"];
                [sicons setObject:@"psn_blk"   forKey:@"2"];
                [self.dataOffset addObject:@"2"];
            }
            
            title = [self.dataDict objectForKey:@"3"];
            if( [title length] > 2 )                                // we got somewthing
            {
                [icons  setObject:@"steam_white" forKey:@"3"];
                [sicons setObject:@"steam_blk"   forKey:@"3"];
                [self.dataOffset addObject:@"3"];
            }
            self.imgDict = (NSDictionary *)icons;
            self.selImgDict = (NSDictionary *)sicons;
        }
    }
    else
    {
        NSString *title;
        title = [self.dataDict objectForKey:@"1"];
        if( [title length] > 2 )                                // we got somewthing
        {
            [self.dataOffset addObject:@"1"];
        }
        
        title = [self.dataDict objectForKey:@"2"];
        if( [title length] > 2 )                                // we got somewthing
        {
            [self.dataOffset addObject:@"2"];
        }
        
        title = [self.dataDict objectForKey:@"3"];
        if( [title length] > 2 )                                // we got somewthing
        {
            [self.dataOffset addObject:@"3"];
        }
        self.labelCentric = YES;
    
    }
    CGRect tableFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.menuTable = [[UITableView alloc] initWithFrame:tableFrame];
    self.menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTable.backgroundColor = [UIColor clearColor];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    self.menuTable.clipsToBounds = NO;
    [self addSubview:self.menuTable];
    self.menuTable.scrollEnabled = NO;
    self.menuTable.bounces = NO;
    self.menuTable.hidden = NO;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.top = -2;
    if( isiPhone())
    {
        self.left = 31;//14;
    }
    else
    {
        self.left = 32;//14;
    }
    self.menuTable.left = 0;//self.left;
    self.menuTable.top = 0;//self.top;
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
    PopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		if( self.labelCentric )
            cell = [[PopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier small:YES];
        else
            cell = [[PopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 	}
	cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.backgroundColor = [UIColor clearColor];
    NSInteger row = indexPath.row + 1;
    if( self.labelCentric )
    {
        NSString *key = [self.dataOffset objectAtIndex:row-1 ];
        NSString *title = [self.dataDict objectForKey:key];
        cell.Label.text = title;
    }
    else
    {
        NSString *key = [self.dataOffset objectAtIndex:row-1 ];
        if( self.imgDict )
        {
            NSString *imageName = [self.imgDict objectForKey:key];
            cell.iconImage.image = [UIImage imageNamed:imageName];
            cell.iconImage.contentMode = UIViewContentModeScaleToFill;
            if( [key isEqualToString:@"1"])
                [cell.iconImage setFrame:CGRectMake(15, 10, 25, 25)];           // XBOX
            else if ([key isEqualToString:@"2"])
                [cell.iconImage setFrame:CGRectMake(15, 10, 26, 20)];            //PS3-PS4
            else
                [cell.iconImage setFrame:CGRectMake(10, 15, 32, 15)];           // STEAM
            
        }
        NSString *title = [self.dataDict objectForKey:key];
        cell.Label.text = title;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    int row = indexPath.row;
//    NSString *key = [self.dataOffset objectAtIndex:row];

    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"kselectedPlatform" object:nil userInfo:networkDict];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////

@implementation PopCell
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
        GHPopBackingView *bckView = [[GHPopBackingView alloc] initWithFrame:self.frame];
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
        GHPopBackingView *bckView = [[GHPopBackingView alloc] initWithFrame:self.frame];
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
    
    GHPopBackingView *bckView = (GHPopBackingView *)self.backgroundView;
    bckView.lineColor = [UIColor colorWithHexString:@"ffe03f"];
    bckView.alpha = 1.0;
    [bckView setNeedsDisplay];
    [super setHighlighted:highlighted animated:animated];
}

- (void) setDefaultStyle
{
    GHPopBackingView *bckView = (GHPopBackingView *)self.backgroundView;
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

@implementation GHPopBackingView
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

