//
//  CHCalendarDayData.m
//  WorkBench
//
//  Created by John Basile on 9/26/12.
//
//

#import "CHCalendarDayData.h"
#import "DateUtil.h"
#import "CHLookAndFeelManager.h"

@implementation CHCalendarDayData


- (id)init
{
    self = [super init];
    if (self)
	{
        
    }
    return self;
}


-(void)drawDate:(NSDate*)date inRect:(CGRect)rect calendarView:(int)calAppearance currentMonth:(BOOL)inCurrentMonth selected:(BOOL)selected               // Required as a DayDataSource
{
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(cgContext, 1.0, 1.0, 1.0, 1.0);

    NSString *dayString = [NSString stringWithFormat:@"%@", [DateUtil stringFromDate:date dateFormat:@"d"]];
    UIFont* dayFont = [[CHLookAndFeelManager sharedLookAndFeelManager] fontAtKey: @"T17"];
    CGSize daySize = [dayString sizeWithFont: dayFont];
    if(!inCurrentMonth)
        [[UIColor grayColor] set];
    else
        [[UIColor whiteColor] set];
    
    // apply drop shadow to current day
    if (inCurrentMonth && [NSDate date] == date)
    {
        CGContextSaveGState(cgContext);
        CGContextSetShadowWithColor(cgContext, CGSizeMake(0.0, 0.0), 5.0, [[UIColor colorWithWhite:1.0 alpha:0.65] CGColor]);
        [dayString drawInRect: CGRectMake(42 - daySize.width, -1, daySize.width, 20) withFont: dayFont];
        CGContextRestoreGState(cgContext);
    }
    else
    {
        [dayString drawInRect: CGRectMake(42 - daySize.width, -1, daySize.width, 20) withFont: dayFont];
    }
    CGContextSetStrokeColorWithColor(cgContext,[[UIFactory sharedInstance] grayColor:38.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(cgContext, 1);
    CGContextStrokeRect(cgContext, rect);
    
    if( selected)
    {
        CGRect strokeRect = CGRectInset(CGRectMake(0, 0, rect.size.width-1, rect.size.height), 1.0, 1.0);
        CGContextSetStrokeColorWithColor(cgContext, [UIColor lightGrayColor].CGColor);
        CGContextSetLineWidth(cgContext, 2.0);
        CGContextStrokeRect(cgContext, strokeRect);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertCalendarDaySelection" object:date];
    }
}

@end
