//
//  CalendarView.m
//  WorkBench
//
//  Created by John Basile on 6/26/12.
//
//

#import "CalendarView.h"
#import "CalendarDayView.h"
#import <QuartzCore/QuartzCore.h>
#import "CHLookAndFeelManager.h"
#import "DateUtil.h"

@implementation CalendarView

@synthesize monthLabel;
@synthesize leftButton;
@synthesize rightButton,focusDate;

@synthesize disclosureButton,headerViewTapButton,calendarHeader,calendarHeaderArrow;
@synthesize calendarView,calendarHeaderView,addedDisplay,startViewingDate,endViewingDate;



+ (NSString *)className
{
	return @"Calendar";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
 		[self setUpView];
    }
    return self;
}


- (void)prevCalMonth: (id) sender                                                       // leftbutton selection... previous month
{
    NSDateComponents* minusOneMonth = [NSDateComponents new];
    [minusOneMonth setMonth:-1];
	
    self.focusDate = [[NSCalendar currentCalendar] dateByAddingComponents:minusOneMonth toDate:self.focusDate options:0];
    [self.calendarView computeRangeForMonth:self.focusDate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertCalendarDaySelection" object:self.focusDate];
	self.calendarView.hidden = NO;
    
    self.startViewingDate = [self.calendarView.items objectAtIndex:0];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 42;
    self.endViewingDate = [calendar dateByAddingComponents:dayComponent toDate:self.startViewingDate options:0];  //subtract day(s)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarDateUpdate" object:self.focusDate];
}

- (void)nextCalMonth: (id) sender                                                                           // rightbutton selection... next month
{
    NSDateComponents* plusOneMonth = [NSDateComponents new];
    [plusOneMonth setMonth:1];
    self.focusDate = [[NSCalendar currentCalendar] dateByAddingComponents:plusOneMonth toDate:self.focusDate options:0];
    [self.calendarView computeRangeForMonth:self.focusDate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertCalendarDaySelection" object:self.focusDate];
	self.calendarView.hidden = NO;
    
    self.startViewingDate = [self.calendarView.items objectAtIndex:0];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 42;
    self.endViewingDate = [calendar dateByAddingComponents:dayComponent toDate:self.startViewingDate options:0];  //subtract day(s)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarDateUpdate" object:self.focusDate];
}

-(void)monthTitle:(NSNotification *)notification                                                            // set the month label
{
    NSDate* date = (NSDate*) [notification object];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar: [NSCalendar currentCalendar]];
    [dateFormatter setDateFormat: @"MMMM YYYY"];
    self.monthLabel.text = [[dateFormatter stringFromDate: date] uppercaseString];
}

- (void)setUpView                                                                                           // calendarView init
{
    UIView *bckView = [[UIView alloc] initWithFrame:CGRectMake(BCK_X, BCK_Y, BCK_W,  BCK_H)];               // create backing view
    bckView.clipsToBounds = YES;
    bckView.opaque = YES;
    bckView.backgroundColor = [[UIFactory sharedInstance] getBackgroundFromProperties:@"CalendarView"];
    //    NSDictionary *properties = [[UIFactory sharedInstance] getCalendarViewProperties];
    //    NSString *value = [properties objectForKey:@"backgroundColor"];
    //    bckView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: value]];
    [self addSubview:bckView];
	
    monthLabel = [[UILabel alloc] initWithFrame: CGRectMake(MON_X, MON_Y, MON_W, MON_H)];                   // create Month Label
    self.monthLabel.backgroundColor = [UIColor clearColor];
    self.monthLabel.textColor = [UIColor whiteColor];
    self.monthLabel.font = [[CHLookAndFeelManager sharedLookAndFeelManager] fontAtKey: @"T8"];
    self.monthLabel.text = @"MONTH NAME";
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    [bckView addSubview: monthLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver: self                                                 // set notification to update the month label
                                             selector: @selector(monthTitle:)
                                                 name: @"AlertCalendarDaySelection"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self                                                 // set notification to update the Calendar
                                             selector: @selector(updateCalendar:)
                                                 name: @"RefreshCalendar"
                                               object: nil];
    
    
	self.leftButton = [UIButton buttonWithType: UIButtonTypeCustom];                                        // create left button for Previous Month Selection
    leftButton.frame =  CGRectMake(LFT_X, LFT_Y, LFT_W, LFT_H);
    [self.leftButton setImage: [UIImage imageNamed: @"calendar_left"] forState: UIControlStateNormal];
    [self.leftButton setImage: [UIImage imageNamed: @"calendar_left"] forState: UIControlStateDisabled];
    [self.leftButton addTarget: self action: @selector(prevCalMonth:) forControlEvents: UIControlEventTouchDown];
    self.leftButton.hidden = YES;
    [bckView addSubview: leftButton];
    
    self.rightButton = [UIButton buttonWithType: UIButtonTypeCustom];                                       // create Right button for Next Month Selection
    rightButton.frame =  CGRectMake(RGT_X, RGT_Y, RGT_W, RGT_H);
    [self.rightButton setImage: [UIImage imageNamed: @"calendar_right"] forState: UIControlStateNormal];
    [self.rightButton setImage: [UIImage imageNamed: @"calendar_right"] forState: UIControlStateDisabled];
    [self.rightButton addTarget: self action: @selector(nextCalMonth:) forControlEvents: UIControlEventTouchDown];
    self.rightButton.hidden = YES;
    [bckView addSubview: rightButton];
    
	UIView* daysLabelView = [[UIView alloc] initWithFrame: CGRectMake(2, 35, FRM_W, 15)];                   // like P90X create look of the day labels
    daysLabelView.backgroundColor = [UIColor clearColor];
    [bckView addSubview: daysLabelView];
	
    UIView* dayOfWeekStrip = [[UIView alloc] initWithFrame: CGRectMake(2, 0, FRM_W, 8)];
    dayOfWeekStrip.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    [daysLabelView addSubview: dayOfWeekStrip];
    
    // day initials
    NSArray *dayLabelArray = [NSArray arrayWithObjects: @"S", @"M", @"T", @"W", @"T", @"F", @"S", nil];
    for (int dayIndex = 0; dayIndex < 7; dayIndex++)
    {
        UILabel *dayLabel = [[UILabel alloc] initWithFrame: CGRectMake((dayIndex * 46), 0, 45, 7)];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.textColor = [UIColor lightGrayColor];
        dayLabel.highlightedTextColor = [UIColor lightGrayColor];
        dayLabel.font = [[CHLookAndFeelManager sharedLookAndFeelManager] fontAtKey: @"T13"];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.text = (NSString *)[dayLabelArray objectAtIndex: dayIndex];
        [daysLabelView addSubview: dayLabel];
    }
    
    // black line
    UIView* separatorView = [[UIView alloc]initWithFrame: CGRectMake(2, 48, FRM_W, 1)];
    separatorView.contentMode = UIViewContentModeScaleToFill;
    separatorView.backgroundColor = [UIColor blackColor];
    [bckView addSubview: separatorView];
    
	self.focusDate = [NSDate date];                                                                     // set toDay has the fous date to start
    
	CGRect rect = CGRectMake(0, 0, Cal_W, Cal_HS);
    self.calendarView = [[CalendarLayoutView alloc] initWithFrame:rect thisWeek:self.focusDate];        // create the calendarLayoutView
    self.calendarView.backgroundColor = [UIColor clearColor];                                           // clear the calendarLayoutView
    [self.calendarView setSelectionCallBack:self theSelector:@selector(showWeekView:)];                 // set the selection call back
    [self.calendarView setFocusDateCallBack:self theSelector:@selector(updateFocus:)];                  // set the focus date call back, (ie. user selects/scrolls to new focus date)
    self.calendarView.frame = CGRectMake(CLV_Cx, CLV_Cy, Cal_W, Cal_HS);                                // reset the frame before moving into the backing view
    [bckView addSubview:self.calendarView];                                                             // add it to the backgroud view
    
    self.calendarHeaderView = [[UIView alloc]initWithFrame: CGRectMake(CHV_Cx, CHV_Wy, CHV_WD, CHV_HT)];// like P90X create the sliding headerView in code
    [bckView addSubview:calendarHeaderView];
    
    self.calendarHeader = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calendar_header.png"]];// add the graphic
    self.calendarHeader.frame =  CGRectMake(0, 0, FRM_W, 40);
    [self.calendarHeaderView addSubview:self.calendarHeader];
    
    self.headerViewTapButton = [UIButton buttonWithType: UIButtonTypeCustom];                            // add the tap button, and disclosure button to the headerView
    self.headerViewTapButton.backgroundColor = [UIColor clearColor];
    self.headerViewTapButton.frame =  CGRectMake(HBT_Cx, HBT_Wy, HBT_WD, HBT_HT);
    [self.headerViewTapButton addTarget: self action: @selector(showMonthView:) forControlEvents: UIControlEventTouchUpInside];
    [self.calendarHeaderView addSubview: self.headerViewTapButton];
    
    self.disclosureButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.disclosureButton setImage: [UIImage imageNamed: @"button_day_close"] forState: UIControlStateNormal];
    [self.disclosureButton addTarget: self action: @selector(showMonthView:) forControlEvents: UIControlEventTouchUpInside];
    self.disclosureButton.frame =  CGRectMake(DBT_Cx, DBT_Wy, DBT_WD, DBT_HT);
    [self.calendarHeaderView addSubview: self.disclosureButton];
    
    self.calendarHeaderArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calendar_header_arrow.png"]];    // lastly add the triangle graphic to point to the day of the week
    self.calendarHeaderArrow.frame = CGRectMake(CAR_Cx, CAR_Wy, CAR_WD, CAR_HT);
    [bckView addSubview:self.calendarHeaderArrow];
	
    [self updateFocus:nil];                                                                                 // update the focus of the week day of the calendar
    
}

- (void)updateCalendar:(id)sender                                                                          // refreshes the dates
{
    if(self.calendarView.calApperance == Cal_WeekView)
        [self.calendarView implementWeekView];
    else
        [self.calendarView implementMonthView];
}

- (void)updateFocus:(id)sender                                                                              // update the focus of the week day... animating the Arrow point to the day of the week
{
    self.focusDate = self.calendarView.selectedDate;
    int dayOfWeek = [DateUtil getDayOfWeekForDate:self.focusDate] - 1;
    
    if(self.calendarView.calApperance == Cal_WeekView)
    {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = -dayOfWeek;
        self.startViewingDate = [calendar dateByAddingComponents:dayComponent toDate:self.focusDate options:0];  //subtract day(s)
        dayComponent.day = 7;
        self.endViewingDate = [calendar dateByAddingComponents:dayComponent toDate:self.startViewingDate options:0];  //subtract day(s)
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarDateUpdate" object:self.focusDate];
    
    CGFloat slop = 0.5 * (self.calendarView.dayCellWidth - CAR_WD);
    CGFloat offset = slop + dayOfWeek * self.calendarView.dayCellWidth;
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.calendarHeaderArrow.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         self.calendarHeaderArrow.frame = CGRectMake(offset, CAR_Wy, CAR_WD, CAR_HT);
                         self.calendarHeaderArrow.alpha = 1;
                     }];
    
}

- (void)showWeekView:(id)sender                                                                             // delegate response to selection of a day
{
    self.focusDate = self.calendarView.selectedDate;
    
    
    [UIView animateWithDuration:0.4                                                                         // animate the UI to slide up to show a week view
                     animations:^{
                         self.calendarView.frame         = CGRectMake(CLV_Cx, CLV_Cy, CLV_WD, CLV_WH);
                         self.calendarHeaderView.frame   = CGRectMake(CHV_Cx, CHV_Wy, CHV_WD, CHV_HT);
                         self.calendarHeaderArrow.frame  = CGRectMake(CAR_Cx, CAR_Wy, CAR_WD, CAR_HT);
                         if( self.addedDisplay)
                         {
                             self.addedDisplay.frame = CGRectMake(self.addedDisplay.frame.origin.x, self.calendarHeaderView.frame.size.height + self.calendarHeaderView.frame.origin.y + 1, self.addedDisplay.frame.size.width, self.addedDisplay.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         self.leftButton.hidden = YES;
                         self.rightButton.hidden = YES;
                         [self.calendarView implementWeekView];                                             // change the CalendarLayoutView to Week Mode
                         self.calendarView.frame         = CGRectMake(CLV_Cx, CLV_Cy, CLV_WD, CLV_WH);
                     }];
}


#pragma mark Event Handlers

- (void)showMonthView:(id)sender                                                                            // response from headerViewTapButton or disclosureButton
{
    [self.calendarView implementMonthView];                                                                 // change the CalendarLayoutView to Month Mode
    
    [UIView animateWithDuration:0.4                                                                         // animate the UI to slide down to show a month view
                     animations:^{
                         self.calendarView.frame             = CGRectMake(CLV_Cx, CLV_Cy, CLV_WD, CLV_MH);
                         self.calendarHeaderView.frame       = CGRectMake(CHV_Cx, CHV_My, CHV_WD, CHV_HT);
                         self.calendarHeaderArrow.frame      = CGRectMake(CAR_Cx, CAR_My, CAR_WD, CAR_HT);
                         if( self.addedDisplay)
                         {
                             self.addedDisplay.frame = CGRectMake(self.addedDisplay.frame.origin.x, self.calendarView.frame.size.height + self.calendarView.frame.origin.y, self.addedDisplay.frame.size.width, self.addedDisplay.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         self.leftButton.hidden = NO;
                         self.rightButton.hidden = NO;
                     }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
