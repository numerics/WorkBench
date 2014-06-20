//
//  CustomDrawView.m
//  WorkBench
//
//  Created by Basile, John on 8/20/13.
//
//

#import "CustomDrawView.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import <objc/runtime.h>

@interface CustomDrawView()
{
}

@property (nonatomic, strong) UITableView       *_drawTable;
@property (nonatomic, strong) NSMutableArray    *_drawArray;
@property (nonatomic, assign) int               _drawItem;
@property (nonatomic, assign) int               _tableCnt;
@property (nonatomic, assign) CGRect            _drawRect;

@end

@implementation CustomDrawView

+ (NSString *)className
{
	return @"Custom Drawing";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		[self setUpView:frame];
    }
    return self;
}


- (void)setUpView:(CGRect)rect;
{
    self.backgroundColor = [UIColor whiteColor];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//	UIButton	*runButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	runButton.frame = CGRectMake(10., 10., 300., 44.);
//	[runButton setTitle:@"Run Animation" forState:UIControlStateNormal];
//	[runButton addTarget:self action:@selector(toggleRun:) forControlEvents:UIControlEventTouchUpInside];
//	[evDelegate.benchViewController.parametersView addSubview:runButton];
    
    self._drawTable = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 20.0, 250.0, 300.0) style:UITableViewStylePlain];
    self._drawTable.delegate = self;
    self._drawTable.dataSource = self;

    self._drawArray = [NSMutableArray array];

    unsigned int propertyCount = 0;
	objc_property_t * properties = class_copyPropertyList([CustomDrawView class], &propertyCount);
	for (unsigned int i = 0; i < propertyCount; ++i)
	{
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
        if(name[0] != '_')
            [self._drawArray addObject:[NSString stringWithUTF8String:name]];
	}
	free(properties);
	
    self._tableCnt = [self._drawArray count];
    self._drawItem = 1;
  	[evDelegate.benchViewController.parametersView addSubview:self._drawTable];
  
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
// removes warning due to ARC not handling PerfomSelector abstraction methods
// See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

- (void)drawRect:(CGRect)rect
{
    NSString    *method = [NSString stringWithFormat:@"drawRect_%d",self._drawItem];
    SEL selector = NSSelectorFromString(method);    
    if ([self respondsToSelector:selector])
    {
        self._drawRect = rect;
        [self performSelector:selector withObject:nil];
    }

}
#pragma clang diagnostic pop


- (void)drawRect_1
{
    //// General Declarations
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    UIColor* bgCopy = [UIColor colorWithRed: 0.133 green: 0.133 blue: 0.133 alpha: 1];
    //    UIColor* bgCopyDropShadowColor = [UIColor colorWithRed: 0 green: 0.001 blue: 0.001 alpha: 0.8];
    
   // CGRect  rect = self._drawRect;
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    
    UIColor* uNDOColor      = [UIColor colorWithHexString: @"0xFFFFFF"];//[UIColor colorWithRed: 0.603 green: 0.603 blue: 0.603 alpha: 1];
    UIColor* lEVELColor     = [UIColor colorWithHexString: @"0x666666"];;//[UIColor colorWithRed: 0.395 green: 0.395 blue: 0.395 alpha: 1];
    UIColor* rectangle19    = [UIColor colorWithRed: 0.012 green: 0.012 blue: 0.012 alpha: 1];
    UIColor* tAGColor       = [UIColor colorWithRed: 0.828 green: 0.702 blue: 0.06 alpha: 1];
    UIColor* tAGColor2      = [UIColor colorWithRed: 0.678 green: 0 blue: 0.101 alpha: 1];
    
    //// clan_tag
    {
        //// tag_unlock
        {
            //// LEVEL Drawing
            CGRect lEVELRect = CGRectMake(112.3, 127, 135, 17);
            [lEVELColor setFill];
            [@"LEVEL" drawInRect: lEVELRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
            
            
            //// UNLOCKS Drawing
            CGRect uNLOCKSRect = CGRectMake(182.7, 127, 157, 17);
            [lEVELColor setFill];
            [@"UNLOCKS" drawInRect: uNLOCKSRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentRight];
            
            
            //// Rectangle 18 copy Drawing
            UIBezierPath* rectangle18CopyPath = [UIBezierPath bezierPath];
            [rectangle18CopyPath moveToPoint: CGPointMake(161, 150)];
            [rectangle18CopyPath addLineToPoint: CGPointMake(451, 150)];
            [rectangle18CopyPath addLineToPoint: CGPointMake(451, 180)];
            [rectangle18CopyPath addLineToPoint: CGPointMake(161, 180)];
            [rectangle18CopyPath addLineToPoint: CGPointMake(161, 150)];
            [rectangle18CopyPath closePath];
            [strokeColor setFill];
            [rectangle18CopyPath fillWithBlendMode:kCGBlendModeNormal alpha:1.0];
            
            
            
            //// Rectangle 18 copy 3 Drawing
            UIBezierPath* rectangle18Copy3Path = [UIBezierPath bezierPath];
            [rectangle18Copy3Path moveToPoint: CGPointMake(161, 210)];
            [rectangle18Copy3Path addLineToPoint: CGPointMake(451, 210)];
            [rectangle18Copy3Path addLineToPoint: CGPointMake(451, 240)];
            [rectangle18Copy3Path addLineToPoint: CGPointMake(161, 240)];
            [rectangle18Copy3Path addLineToPoint: CGPointMake(161, 210)];
            [rectangle18Copy3Path closePath];
            [strokeColor setFill];
            [rectangle18Copy3Path fillWithBlendMode:kCGBlendModeNormal alpha:0.75];
            
            
            //// Rectangle 18 copy 4 Drawing
            UIBezierPath* rectangle18Copy4Path = [UIBezierPath bezierPath];
            [rectangle18Copy4Path moveToPoint: CGPointMake(161, 271)];
            [rectangle18Copy4Path addLineToPoint: CGPointMake(451, 271)];
            [rectangle18Copy4Path addLineToPoint: CGPointMake(451, 301)];
            [rectangle18Copy4Path addLineToPoint: CGPointMake(161, 301)];
            [rectangle18Copy4Path addLineToPoint: CGPointMake(161, 271)];
            [rectangle18Copy4Path closePath];
            [strokeColor setFill];
            [rectangle18Copy4Path fillWithBlendMode:kCGBlendModeNormal alpha:0.75];
            
            
            //// Rectangle 8 Drawing
            UIBezierPath* rectangle8Path = [UIBezierPath bezierPath];
            [rectangle8Path moveToPoint: CGPointMake(203, 150)];
            [rectangle8Path addLineToPoint: CGPointMake(270, 150)];
            [rectangle8Path addLineToPoint: CGPointMake(270, 301)];
            [rectangle8Path addLineToPoint: CGPointMake(203, 301)];
            [rectangle8Path addLineToPoint: CGPointMake(203, 150)];
            [rectangle8Path closePath];
            [rectangle19 setFill];
            [rectangle8Path fillWithBlendMode:kCGBlendModeNormal alpha:0.75];
            
            //// Graphic 5 Drawing
            CGRect graphic5Rect = CGRectMake(127.29, 156, 108, 17);
            [uNDOColor setFill];
            [@"5" drawInRect: graphic5Rect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
            
            
            //// Graphic 3 character clan tag Drawing
            CGRect graphic3CharacterClanTagRect = CGRectMake(183.59, 155, 215, 18);
            [uNDOColor setFill];
            [@"3 character clan tag" drawInRect: graphic3CharacterClanTagRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentRight];
            
            
            //// [TAG] Drawing
            CGRect tAGRect = CGRectMake(219.3, 155, 131, 18);
            [uNDOColor setFill];
            [@"[TAG]" drawInRect: tAGRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
            
            
            //// Graphic 10 Drawing
            CGRect graphic10Rect = CGRectMake(123.29, 185, 116, 17);
            [uNDOColor setFill];
            [@"10" drawInRect: graphic10Rect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
            
            
            //// Gold clan tag Drawing
            CGRect goldClanTagRect = CGRectMake(182.45, 184, 173, 18);
            [uNDOColor setFill];
            [@"Gold clan tag" drawInRect: goldClanTagRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentRight];
            
            
            //// [TAG] 2 Drawing
            CGRect tAG2Rect = CGRectMake(219.3, 184, 131, 18);
            [tAGColor setFill];
            [@"[TAG]" drawInRect: tAG2Rect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
            
            
            //// Graphic 15 Drawing
            CGRect graphic15Rect = CGRectMake(123.29, 215, 116, 17);
            [uNDOColor setFill];
            [@"15" drawInRect: graphic15Rect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
            
            
            //// Graphic 4 character clan tag Drawing
            CGRect graphic4CharacterClanTagRect = CGRectMake(183.85, 214, 215, 18);
            [uNDOColor setFill];
            [@"4 character clan tag" drawInRect: graphic4CharacterClanTagRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentRight];
            
            
            //// [TAGG] Drawing
            CGRect tAGGRect = CGRectMake(215.3, 214, 139, 18);
            [tAGColor setFill];
            [@"[TAGG]" drawInRect: tAGGRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
            
            
            //// Graphic 20 Drawing
            CGRect graphic20Rect = CGRectMake(123.41, 245, 116, 17);
            [uNDOColor setFill];
            [@"20" drawInRect: graphic20Rect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
            
            
            //// Red clan tag Drawing
            CGRect redClanTagRect = CGRectMake(183.08, 244, 170, 18);
            [uNDOColor setFill];
            [@"Red clan tag" drawInRect: redClanTagRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentRight];
            
            
            //// [TAG] 3 Drawing
            CGRect tAG3Rect = CGRectMake(219.3, 244, 131, 18);
            [tAGColor2 setFill];
            [@"[TAG]" drawInRect: tAG3Rect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
            
            
            //// Graphic 20 copy Drawing
            CGRect graphic20CopyRect = CGRectMake(123.41, 276, 116, 17);
            [uNDOColor setFill];
            [@"20" drawInRect: graphic20CopyRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
            
            
            //// Graphic 5 character clan tag Drawing
            CGRect graphic5CharacterClanTagRect = CGRectMake(282.21, 275, 215, 18);
            [uNDOColor setFill];
            [@"5 character clan tag" drawInRect: graphic5CharacterClanTagRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
            
            
            //// [TAGGG] Drawing
            CGRect tAGGGRect = CGRectMake(212.3, 275, 148, 18);
            [tAGColor2 setFill];
            [@"[TAGGG]" drawInRect: tAGGGRect withFont: [UIFont fontWithName: @"EurostileBold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
        }
    }
}
 

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self._tableCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"custom";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [self._drawArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName: @"EurostileBold" size: 14];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* subviews = self.subviews;
	for (UIView *aView in subviews)
	{
		[aView removeFromSuperview];
	}
    self._drawItem = indexPath.row + 1;
    [self setNeedsDisplay];
}

@end
