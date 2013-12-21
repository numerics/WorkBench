//
//  CalendarLayoutView.m
//
//  Created by John Basile.
//  Copyright 2010 Numerics. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "CalendarLayoutView.h"
#import "DateUtil.h"
#import "UIFactory.h"
#import "CalendarDayView.h"


@implementation CalendarLayoutView

@synthesize calApperance,supView;
@synthesize SelectedItem,touchLocation;
@synthesize currentMonth,bckColor,byColandRow;
@synthesize selectionDelegate,dateDelegate,pgn,dayCellHeight,dayCellWidth;
@synthesize callback,dcallback,toggleSelection;
@synthesize items,nCols,nRows,itemViews,selectedDate,preScrollDate;

int		cRight = 0;
int		cBottom = 0;
int		originalTouch;
BOOL	suspendScroll = NO;
BOOL	draggingScroll = NO;
BOOL	swipedRight = NO;
BOOL	swipedLeft = NO;

/// initilization by Month
- (id)initWithFrame:(CGRect)frame thisMonth:(NSDate *)thisMonth
{
    self = [super initWithFrame:frame];
    if (self)
	{
        self.calApperance   = Cal_MonthView;
        [self initByColAndRows:7 rows:6 withMonth:thisMonth withView:nil];
        [self setSelectedDate:thisMonth];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertCalendarDaySelection" object:thisMonth];
        [self implementMonthView];
    }
    return self;
}

/// initilization by Week
- (id)initWithFrame:(CGRect)frame thisWeek:(NSDate *)thisWeek
{
    self = [super initWithFrame:frame];
    if (self)
	{
        self.calApperance   = Cal_WeekView;
        [self initByColAndRows:7 rows:6 withMonth:thisWeek withView:nil];
        [self setSelectedDate:thisWeek];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertCalendarDaySelection" object:thisWeek];
        [self implementWeekView];
    }
    return self;
}

/// initilization with specific cell sizes
- (void) initWithSize:(CGSize)iSize withMonth:(NSDate *)thisMonth withPosition:(CalendarAppearance)pos withView:(UIView *)sView
{
	self.currentMonth = thisMonth;
	self.calApperance = pos;
	self.dayCellWidth = iSize.width;
	self.dayCellHeight = iSize.height;
	self.byColandRow = NO;
	
	if( sView)
		self.supView = sView;
	
	[self setUp];
}

/// initilization with specific grid size, (i.e. 7 x 6 )
- (void) initByColAndRows:(int)nCol rows:(int)nRow withMonth:(NSDate *)thisMonth withView:(UIView *)sView
{
	UIGestureRecognizer* recognizer;
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	[self addGestureRecognizer:recognizer];
	recognizer.delegate = self;
    
	
    self.currentMonth = thisMonth;
	self.byColandRow = YES;
	self.nCols = nCol;
	self.nRows = nRow;
	self.dayCellWidth  = ( CalendarWidthP - (nCol-1)*ColPadding - 2 *BorderPadding ) / nCol;
	self.dayCellHeight = ( CalendarHeightP - (nRow-1)*ColPadding - 2 *BorderPadding ) / nRow;
    //	self.dayCellWidth  = ( self.frame.size.width - (nCol-1)*ColPadding - 2 *BorderPadding ) / nCol;
    //    self.dayCellHeight = (self.frame.size.height - (nRow-1)*ColPadding - 2 *BorderPadding ) / nRow;
    
    NSDictionary *properties = [[UIFactory sharedInstance] getCalendarLayoutProperties];
    NSString *value = [properties objectForKey:@"toggleSelection"];
    self.toggleSelection = ([value isEqualToString:@"NO"]) ? NO : YES;
    
	if( sView)
		self.supView = sView;
	[self setUp];
	
}

- (void)setUp
{
	self.delegate = self;
	self.bckColor = [UIColor whiteColor];
	self.bounces = YES;
    
	_itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);        // size the scroll area
    
    self.scrollEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.PagingEnabled = YES;
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
}

- (void)dealloc
{
	for (CalendarLayoutView *view in self.itemViews)
		[view removeFromSuperview];
	
	[itemViews removeAllObjects];
	itemViews = nil;
    
	self.supView = nil;
	
}

- (void) clearItems
{
	if(itemViews && [itemViews count] > 0)
	{
		for (UIView *view in itemViews)
			[view removeFromSuperview];
        
		[self.itemViews removeAllObjects];
	}
}

-(void)setSelectedDate:(NSDate *)aselectedDate
{
    selectedDate = [DateUtil getDateByIgnoringTimeComponant:aselectedDate];
}


- (void) setSelectionCallBack:(id)theDelegate theSelector:(SEL)requestSelector
{
	self.selectionDelegate = theDelegate;
	self.callback = requestSelector;
}

- (void) setFocusDateCallBack:(id)theDelegate theSelector:(SEL)requestSelector
{
	self.dateDelegate = theDelegate;
	self.dcallback = requestSelector;
}

- (void)callSelectionCallback
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // removes warning due to ARC not handling PerfomSelector abstraction methods
    // See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    
    if(selectionDelegate && callback && self.calApperance == Cal_MonthView)
        [selectionDelegate performSelector:self.callback withObject:nil];
#pragma clang diagnostic pop
}

- (void)callDateCallback
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // removes warning due to ARC not handling PerfomSelector abstraction methods
    // See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    
    if(dateDelegate && dcallback )
        [dateDelegate performSelector:self.dcallback withObject:nil];
#pragma clang diagnostic pop
}


#pragma mark -
#pragma mark Handle Zooming

- (void)setPagingMode
{
	self.showsVerticalScrollIndicator = self.showsHorizontalScrollIndicator = NO;
}

#pragma mark -
#pragma mark Handle Scrolling

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated         // scroll so rect is just visible (nearest edges). nothing if rect completely visible
{
    [super scrollRectToVisible:rect animated:animated];
}

- (void)setScrollGlobals:(id)sender                                     // scrolling stopped
{
	swipedRight = NO;
	swipedLeft = NO;
}

- (void)scrollRectToVisibleFrame:(CGRect)rect animated:(BOOL)animate;
{
    [self scrollRectToVisible:rect animated:animate];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setScrollGlobals:) userInfo:nil repeats:NO]; // reset scroll globals
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
	CGRect frame, bounds;
	CGFloat iWidth = self.dayCellWidth;
	CGFloat padding = BorderPadding;
    CGFloat screenW = self.frame.size.width;//( [UIFactory sharedInstance].isLandscapeOrientation == YES ) ? CalendarWidthL : CalendarWidthP;
	CGFloat posx;
	
	bounds = [self bounds];
    posx = bounds.origin.x;
    
    self.pgn = 1 + (posx + 0.5*(iWidth+padding))/(iWidth + padding);
    
    int row = self.pgn / 7;
    posx = row * screenW;
    frame = CGRectMake (posx, bounds.origin.y, bounds.size.width, bounds.size.height);
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setScrollGlobals:) userInfo:nil repeats:NO];
	
    int dayOfWeek = [DateUtil getDayOfWeekForDate:self.selectedDate];
    for( CalendarDayView *cView in self.itemViews )
    {
        int theCViewDayOfWeek = [DateUtil getDayOfWeekForDate:cView.focusDate];
        if( theCViewDayOfWeek == dayOfWeek)
        {
            self.selectedDate = cView.focusDate;
            self.preScrollDate = self.selectedDate;
            cView.selected = YES;
            [self callDateCallback];
            [cView setNeedsDisplay];
            break;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    draggingScroll = YES;
    suspendScroll = NO;
	swipedRight = NO;
	swipedLeft = NO;
	originalTouch = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
 	CGRect frame, bounds;
	CGFloat iWidth = self.dayCellWidth;
	CGFloat padding = BorderPadding;
    CGFloat screenW = self.frame.size.width;//( [UIFactory sharedInstance].isLandscapeOrientation == YES ) ? CalendarWidthL : CalendarWidthP;
	CGFloat posx;
    
	bounds = [self bounds];
    posx = bounds.origin.x;
    
    
    self.pgn = 1 + (posx + 0.5*(iWidth+padding))/(iWidth + padding);
    
    int row = self.pgn / 7;
    posx = row * screenW;
    frame = CGRectMake (posx, bounds.origin.y, bounds.size.width, bounds.size.height);
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setScrollGlobals:) userInfo:nil repeats:NO];
	
    int dayOfWeek = [DateUtil getDayOfWeekForDate:self.selectedDate];
    for( CalendarDayView *cView in self.itemViews )
    {
        int theCViewDayOfWeek = [DateUtil getDayOfWeekForDate:cView.focusDate];
        if( theCViewDayOfWeek == dayOfWeek)
        {
            self.selectedDate = cView.focusDate;
            self.preScrollDate = self.selectedDate;
            cView.selected = YES;
            //[self callDateCallback];
            [cView setNeedsDisplay];
            break;
        }
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	//Prevent this from being called multiple times. (didScroll is sent repeatedly while user is dragging)
	if ( !suspendScroll)
	{
		//Figure out the direction;
		CGFloat x, r;
		CGFloat iWidth = self.dayCellWidth;
		CGFloat padding = BorderPadding;
		CGFloat screenW = self.frame.size.width;//( [UIFactory sharedInstance].isLandscapeOrientation == YES ) ? CalendarWidthL : CalendarWidthP;
        
		CGRect bounds;
		
		bounds = [self bounds];
        if( self.preScrollDate != self.selectedDate)
            self.selectedDate = self.preScrollDate;         // premature selection... roll it back
        
		x = (bounds.origin.x + (iWidth*0.5) + (screenW*0.5))/(padding + iWidth);
		r = x - floor(x);
		self.pgn = ( r > 0.5 ) ? floor(x+1) : floor(x);
		int newTouch = scrollView.contentOffset.x;
		
		suspendScroll = YES;
		
		if (newTouch < originalTouch)
		{
			swipedRight = YES;
		}
		else
		{
			swipedLeft = YES;
		}
	}
}

//
// In response to a tap gesture, show the image view appropriately then make it fade out in place.
//
- (void) handleTapFrom:(UITapGestureRecognizer *)recognizer
{
	//CGPoint location = [recognizer locationInView:self];
    
}
-(void)testForHITvsSCROLL:(NSTimer *)timer                                          // test for scrolling versus tapping
{
    if( draggingScroll == NO)                                                       // its a hit vs a scroll
    {
        CalendarDayView *result = (CalendarDayView *)[timer userInfo];
        
        if( self.selectedDate && self.selectedDate != result.focusDate)
        {
            self.selectedDate = result.focusDate;
            [self callDateCallback];
        }
        else if (self.toggleSelection && (self.selectedDate && (self.selectedDate == result.focusDate)) )        // already seleced, now deselect if the property is set to toggle
        {
            self.selectedDate = nil;
        }
        else
        {
            self.selectedDate = result.focusDate;
            [self callDateCallback];
        }
        
        self.preScrollDate = self.selectedDate;
        for (CalendarDayView *cView in self.itemViews)
        {
            if( cView.selected )
            {
                cView.selected = NO;
            }
        }
        result.selected = YES;
        [self setNeedsLayout];
    }
    else
        draggingScroll = NO;
    
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event                                                    // normall overide of hittest
{
    if (![[super hitTest:point withEvent:event] isKindOfClass:[CalendarDayView class]])
        return nil;
    
    CalendarDayView *result = (CalendarDayView *)[super hitTest:point withEvent:event];
    if( result == nil)                                                                                          // if user selected outside the layout... leave
        return result;
    //NSLog(@"hit test point = (%f, %f)", point.x,point.y);
    if(point.y != self.touchLocation.y  )
    {
        self.touchLocation = point;
        if(self.calApperance == Cal_WeekView )
        {
            if( swipedRight || swipedLeft )
            {
                return result;
            }
            else        // no swiping
            {
                draggingScroll = NO;
                [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(testForHITvsSCROLL:) userInfo:result repeats:NO];  // testing for scrolling versus tapping
                return result;
            }
        }
        
        if( self.selectedDate && self.selectedDate != result.focusDate)
        {
            self.selectedDate = result.focusDate;
            [self callDateCallback];
        }
        else if (self.toggleSelection && (self.selectedDate && (self.selectedDate == result.focusDate)) )        // already seleced, now deselect
        {
            self.selectedDate = nil;
        }
        else
        {
            self.selectedDate = result.focusDate;
            [self callDateCallback];
        }
        self.pgn = result.itemCountInCalendar;
        [self callSelectionCallback];
    }
    return result;
}

#pragma mark -
#pragma mark CalendarLayoutView Properties & Methods

- (NSArray *)items                                              // the array that holds the dates
{
	return items;
}

- (void)setItems:(NSArray *)array
{
	[self clearItems];
	if( items != array )
	{
		items = array;
	}
	[self setNeedsLayout];
}

- (void) bkgroundColor:(UIColor *) color
{
	self.bckColor = color;
}

-(void)computeRangeForMonth:(NSDate *)monthOfDate
{
    int firstDay,daysInCurrentMonth,focusDayOfWeek,focusDayOfMonth;
	int daysInPreviousMonth,daysVisibleBeforeFocusDate;
	BOOL firstDayIsCurrentMonth;
	NSDate* startDate;
	
	self.currentMonth = monthOfDate;
	
	NSCalendar* calendar = [NSCalendar currentCalendar];
    
    focusDayOfWeek = [DateUtil getDayOfWeekForDate:monthOfDate];
    focusDayOfMonth = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:monthOfDate];
    daysInCurrentMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:monthOfDate].length;
    if ((focusDayOfMonth - focusDayOfWeek) % 7 == 0)
    {
        firstDay = 1;
        firstDayIsCurrentMonth = YES;
    }
    else
    {
        NSDate* dayInPreviousMonth = [monthOfDate dateByAddingTimeInterval:-(86400 * (focusDayOfMonth + 1))];
        daysInPreviousMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:dayInPreviousMonth].length;
        int weekdayOfFirstOfMonth = ((focusDayOfWeek + 7) - (focusDayOfMonth % 7)) % 7 + 1;
        firstDay = daysInPreviousMonth - weekdayOfFirstOfMonth + 2;
        firstDayIsCurrentMonth = NO;
    }
    daysVisibleBeforeFocusDate = firstDayIsCurrentMonth ? (focusDayOfMonth - firstDay) : (daysInPreviousMonth - firstDay + focusDayOfMonth);
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -daysVisibleBeforeFocusDate;
    startDate = [calendar dateByAddingComponents:dayComponent toDate:monthOfDate options:0];  //subtract day(s)
    startDate = [DateUtil getDateByIgnoringTimeComponant:startDate];
    
    dayComponent.day = 41;
	NSDate *endDate = [calendar dateByAddingComponents:dayComponent toDate:startDate options:0];
	self.items = [DateUtil getRangeOfDays:startDate toDate:endDate];
}

-(void)computeRangeForYearAboutDay:(NSDate *)date
{
	NSDate* startDate;
 	NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    int dayOfWeek = [DateUtil getDayOfWeekForDate:date] - 1;
    dayComponent.day = -182-dayOfWeek;
    startDate = [calendar dateByAddingComponents:dayComponent toDate:date options:0];  //subtract day(s)
    startDate = [DateUtil getDateByIgnoringTimeComponant:startDate];
    dayComponent.day = 365;
	NSDate *endDate = [calendar dateByAddingComponents:dayComponent toDate:startDate options:0];
	self.items = [DateUtil getRangeOfDays:startDate toDate:endDate];
    
}

- (void) implementWeekView
{
    [self computeRangeForYearAboutDay:(self.selectedDate)?self.selectedDate:[NSDate date]];                     // get a year worth of dates centered around the selected date
    [self CalendarLayoutWeekView];                                                                           // set the scrollView to handle weekly view
    if( self.selectedDate )                                                                                     // want to display the week of the selected day
    {
		CGRect frame, bounds;
		CGFloat screenW = self.frame.size.width;//( [UIFactory sharedInstance].isLandscapeOrientation == YES ) ? CalendarWidthL : CalendarWidthP;
		CGFloat posx;
		self.preScrollDate = self.selectedDate;
		bounds = [self bounds];
        for( int i = 0; i < [self.items count]; i++)
        {
            if( [self.selectedDate isEqualToDate:[self.items objectAtIndex:i]])
            {
                self.pgn = i;
                break;
            }
        }
        int row = self.pgn / 7;
        posx = row * screenW;
		frame = CGRectMake (posx, bounds.origin.y, bounds.size.width, bounds.size.height);
		[self scrollRectToVisibleFrame:frame animated:NO];
    }
}

- (void) implementMonthView
{
    [self computeRangeForMonth:(self.selectedDate)?self.selectedDate:[NSDate date]];                            // get the 42 dates for this month
    [self CalendarLayoutMonthView];                                                                                 // set the scrollView to handle monthly view
}

- (void) CalendarLayoutVertical                                                                                // ScrollView setup for vertical calendar display....TO BE DEFINED LATER
{
	CGRect bounds,frame;
	bounds = [self bounds];
	int minHeight;
	
	frame = bounds;
	frame.size.width = self.dayCellWidth + ColPadding;
	frame.origin.y = YOffset;
	cRight = frame.size.height/2;
	
	self.frame = frame;
	int item_count = [self.items count];
	minHeight = item_count*(self.dayCellHeight + ColPadding);
	self.calApperance = Cal_DayView;
	[self setContentSize:CGSizeMake (frame.size.width, minHeight)];
}

- (void) CalendarLayoutMonthView                                                                                    // ScrollView Month Parameters
{
	CGFloat xWidth = 0;
	CGFloat yHeight = 0;
    
    self.bounces = YES;
    self.alwaysBounceVertical = YES;
	self.calApperance = Cal_MonthView;
    xWidth = ( [UIFactory sharedInstance].isLandscapeOrientation == YES ) ? CalendarWidthL : CalendarWidthP;
    yHeight = CalendarHeightP;
    [self setContentSize:CGSizeMake(xWidth, yHeight)];
}

- (void) CalendarLayoutWeekView                                                                                     // ScrollView Week Parameters
{
	CGRect bounds,frame;
	if(self.supView)
		bounds = [self.supView bounds];
	else
		bounds = [self bounds];
    
	self.calApperance = Cal_WeekView;
    self.alwaysBounceVertical = NO;
    self.bounces = NO;
	CGFloat screenHeight, screenWidth;
	screenHeight = bounds.size.height;
	screenWidth = bounds.size.width;
	
	frame = bounds;
	frame.size.height = bounds.size.height;// viewHeight + ColPadding;
    
	frame.origin.x = 0.0;
	frame.size.width = screenWidth;
	frame.origin.y = screenHeight - ( ColPadding + frame.size.height);
	cBottom = screenWidth/2.0;
	
	self.frame = frame;
	int item_count;
    item_count = [self.items count];
	
	int minWidth;
	
    minWidth = item_count*(self.dayCellWidth + ColPadding);
	
	if( (self.zoomScale == 1.0) )
	{
		[self setContentSize:CGSizeMake (minWidth+40, screenHeight)];
	}
}


- (CGPoint)layoutMonth
{
    [self CalendarLayoutMonthView];                                                             // set the ScrollView to handle a month at a time
    CGFloat xWidth = ( [UIFactory sharedInstance].isLandscapeOrientation == YES ) ? CalendarWidthL : CalendarWidthP;
    CGFloat yHeight = CalendarHeightP;
    
	CGSize  newSize;
    
    if (_itemSize.width != xWidth || _itemSize.height != yHeight)
    {
        [self setContentSize:CGSizeMake(xWidth, yHeight)];                                      // set the scrollView Content size
        newSize = CGSizeMake(xWidth, yHeight);
        _itemSize = newSize;
        CGRect scrollFrame = self.frame;
        scrollFrame.size.width = xWidth;
        scrollFrame.size.height = yHeight;
        self.frame = scrollFrame;
    }
    return CGPointMake(xWidth, yHeight);
}

- (CGPoint)layoutWeek
{
    //[self CalendarDayViewHorizontal];
    CGRect bounds;
    if(self.supView)
        bounds = [self.supView bounds];
    else
        bounds = [self bounds];
    
    CGFloat xWidth = bounds.size.width;
    CGFloat yHeight = (1)*(dayCellHeight + ColPadding) + 10;
    return CGPointMake(xWidth, yHeight);
}

- (CGPoint)layoutVertical
{
    [self CalendarLayoutVertical];
    CGFloat yHeight = CalendarHeightP;
    CGFloat xWidth = dayCellWidth + ColPadding;
    return CGPointMake(xWidth, yHeight);
}

- (void)layoutSubviews                                                                  // Main work of laying out all the CalendarDayView, (date) cells
{
	[super layoutSubviews];
    
	CGFloat colSize,vSpacing;
	NSInteger i, j, item_count;
	NSInteger old_view_count;
	
	NSDate				*date;
	CalendarDayView		*cView = nil;
	
	CGFloat     x, y;
	CGRect      bounds, frame;
    
	CGFloat     xWidth = 0;
	CGFloat     yHeight = 0;
    
	CGFloat     borSize;
    
	NSMutableArray  *old_views;
	
    
    colSize = ColPadding;                                           // padding between cells, if any horizontally
    vSpacing = ColPadding;                                          // padding between cells, if any vertically
    borSize = BorderPadding;                                        // padding at the borders of the calendarLayout
    
	item_count = [self.items count];
	if(item_count == 0 ) return;                                    // if its empty...dont bother
    
	old_views = self.itemViews;                                     // cache CalendarDayView, as they come into view
	self.itemViews = [[NSMutableArray alloc] init];
	old_view_count = [old_views count];
	
	if( self.calApperance == Cal_MonthView)
	{
		CGPoint xy = [self layoutMonth];                            // size of the layout within the CalendarView
        xWidth = xy.x;
        yHeight = xy.y;
	}
	else if( self.calApperance == Cal_WeekView)
	{
		CGPoint xy = [self layoutWeek];
        xWidth = xy.x;
        yHeight = xy.y;
	}
	else if( self.calApperance == Cal_DayView)
	{
		CGPoint xy = [self layoutVertical];
        xWidth = xy.x;
        yHeight = xy.y;
	}
    
	bounds = [self bounds];
	x = borSize;
	y = borSize;
	int colCnt = 0;
	int loopstart = 0;
    ///*** LATER POSSIBLE OPTIMIZATION IN WEEK VIEW  ***///
    //    if( self.calApperance == kHorzizontal)
    //    {
    //        x = bounds.origin.x;
    //        for (i = 0; i < self.nCols; i++)
    //        {
    //            frame = CGRectMake (x, y, self.dayCellWidth, self.dayCellHeight);
    //            int index = x / self.dayCellWidth;
    //            date = [self.items objectAtIndex:index];
    //            for (j = 0; j < old_view_count; j++)
    //            {
    //                cView = [old_views objectAtIndex:j];
    //                if ([[cView focusDate] isEqual:date])
    //                {
    //                    [cView setFrame:frame];
    //                    [old_views removeObjectAtIndex:j];
    //                    old_view_count--;
    //                    goto got_viewH;
    //                }
    //            }
    //            cView = [[UIFactory sharedInstance] initializeCalendarDayView:frame];
    //            cView.focusDate = date;
    //
    //            cView.currentMonthDate = self.currentMonth;
    //            cView.dayOfWeek = [DateUtil getDayOfWeekForDate:date];
    //            cView.itemCountInCalendar = i;
    //            [self addSubview:cView];
    //
    //        got_viewH:
    //            [self.itemViews addObject:cView];
    //            if( [self.selectedDate isEqualToDate: date])
    //                cView.selected = YES;
    //            else
    //                cView.selected = NO;
    //            [cView setNeedsDisplay];
    //            x = x + self.dayCellWidth + colSize;
    //        }
    //    }
    //    else
    {
        for (i = 0; i < item_count; i++)                                                    // cycle through all the dates
        {
            frame = CGRectMake (x, y, self.dayCellWidth, self.dayCellHeight);               // move along left to right, top to bottom
            
            if ( !CGRectIntersectsRect(frame, bounds) )                                     // but only concern ourselves with those that are visible
                goto remove_oldView;
            
            date = [self.items objectAtIndex:i];
            for (j = 0; j < old_view_count; j++)
            {
                cView = [old_views objectAtIndex:j];                                        // if the CalendarDayView already exist, use it and move it into position
                if ([[cView focusDate] isEqual:date])
                {
                    [cView setFrame:frame];
                    [old_views removeObjectAtIndex:j];
                    old_view_count--;
                    goto got_view;
                }
            }
            
            cView = [[UIFactory sharedInstance] initializeCalendarDayView:frame];           // else, create the CalendarDayView
            cView.focusDate = date;
            
            cView.currentMonthDate = self.currentMonth;
            cView.calApperance = self.calApperance;
            //cView.dayOfWeek = [DateUtil getDayOfWeekForDate:date];
            cView.itemCountInCalendar = i;                                                  // all CalendarDayView will need this iVar for optimiztion, to locate selected dates
            [self addSubview:cView];
            
        got_view:
            [self.itemViews addObject:cView];                                               // store the CalendarDayView in an array for later use on selections
            if( self.calApperance == Cal_WeekView)
            {
                if( [self.selectedDate isEqualToDate: date])                                // in this version we only select Days in the Week View
                    cView.selected = YES;                                                   ///*** THIS WILL NEED UPDATING FOR DIFFERENT KIND OF CALENDARS, I.E TOGGLING SELECTION...***///
                else
                    cView.selected = NO;
            }
            else
                cView.selected = NO;
            
            [cView setNeedsDisplay];                                                        // need the CalendarDayView to redraw itself based to update its selection change
            
        remove_oldView:
            if (self.calApperance == Cal_WeekView)
            {
                x = x + dayCellWidth + colSize;                                             // in the Week mode we just move along horizontally
                loopstart++;
            }
            else
            {
                colCnt++;
                CGFloat delta;
                delta = (colCnt == self.nCols) ? borSize : colSize;
                x = x + dayCellWidth + delta;
                
                if ( self.byColandRow == YES )                                              // Typically all Calendars will use this
                {
                    if (colCnt == self.nCols)                                               // if the right limit has been reach
                    {
                        x = borSize;
                        colCnt = 0;
                        y += (dayCellHeight + vSpacing);                                    // move on down to the next row
                        loopstart = 0;
                    }
                    else
                    {
                        loopstart++;
                    }
                }
                else
                {
                    CGFloat endX = x + dayCellWidth;
                    if (endX > xWidth)
                    {
                        x = borSize;
                        colCnt = 0;
                        y += (dayCellHeight + vSpacing);
                        loopstart = 0;
                    }
                    else
                    {
                        loopstart++;
                    }
                }
            }
        }
    }
	
	if (!(self.calApperance == Cal_WeekView))
	{
		if (x > colSize)
			y += (dayCellHeight + vSpacing);
	}
	
	for (cView in old_views)                                                            // deQueing cells from the cache
		[cView removeFromSuperview];
}

@end
