//
//  CalendarDayView.m
//  WorkBench
//
//  Created by John Basile on 6/27/12.
//
//

#import "CalendarDayView.h"
#import "DateUtil.h"

@implementation CalendarDayView

@synthesize focusDate,title,currentMonthDate,calApperance;
@synthesize topLabel;
@synthesize itemCountInCalendar;

@synthesize selected,dataObj;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIFactory sharedInstance] getBackgroundFromProperties:@"CalendarDayView"];
    }
    return self;
}

- (void)drawSelection:(CGRect)rect
{
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(cgContext, 1.0, 1.0, 1.0, 1.0);
    if( selected )
    {
        CGContextSetLineWidth(cgContext, 2.0);
        rect = CGRectInset(rect, 1.0, 1.0);
        CGContextAddRect(cgContext, rect);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertCalendarDaySelection" object:self.focusDate];
    }
    else
    {
        CGContextSetLineWidth(cgContext, 0.25);
        CGContextAddRect(cgContext, rect);
    }
    CGContextStrokePath(cgContext);
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
	CGContextClearRect(cgContext, bounds);
    BOOL inCurrentMonth = [DateUtil isInCurrentMonth:self.focusDate dateToCheck:self.currentMonthDate];
    
    ///Background Default Colors
	if( inCurrentMonth )
	{
        [[[UIFactory sharedInstance] getDayViewColors:@"inCurrentMonthColor"]set];
		CGContextFillRect(cgContext, rect);
	}
	else
	{
		[[[UIFactory sharedInstance] getDayViewColors:@"notInCurrentMonthColor"]set];
        //[[[UIFactory sharedInstance] grayColor:0.0 alpha:1.0]set];  // black
		CGContextFillRect(cgContext, rect);
	}
    
	if( !dataObj )
    {
        NSString *wName = [NSString stringWithFormat:@"%@", [DateUtil stringFromDate:focusDate dateFormat:@"d"]];
        CGRect topFrame = CGRectMake(20,0,self.frame.size.width-20,20);
        if( topLabel == nil)
        {
            self.topLabel = [[UILabel alloc] initWithFrame:topFrame];
            [self addSubview:topLabel];
        }
        [self.topLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
        self.topLabel.backgroundColor = [UIColor clearColor];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel.textColor = [UIColor whiteColor];
        self.topLabel.text = [wName uppercaseString];
    }
    else
        [dataObj drawDate:focusDate inRect:bounds calendarView:self.calApperance currentMonth:inCurrentMonth selected:selected];
    
    /// Border Lines
    CGContextSetStrokeColorWithColor(cgContext,[[UIFactory sharedInstance] getDayViewColors:@"borderColor"].CGColor);
    CGContextSetLineWidth(cgContext, 1);
    CGContextStrokeRect(cgContext, rect);
    //  [self drawSelection:rect];
}


@end
