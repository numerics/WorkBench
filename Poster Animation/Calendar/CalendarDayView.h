//
//  CalendarDayView.h
//  WorkBench
//
//  Created by John Basile on 6/27/12.
//
//

#import <UIKit/UIKit.h>
#import "CalendarLayoutView.h"


@protocol DayDataSource <NSObject>
@required
- (void) drawDate:(NSDate*)date inRect:(CGRect)rect calendarView:(int)calAppearance currentMonth:(BOOL)inCurrentMonth selected:(BOOL)selected;
@end

@interface CalendarDayView : UIView
{
    CalendarAppearance          calApperance;
    NSDate                      *focusDate;
    NSDate                      *currentMonthDate;
    
    NSString                    *title;
    UILabel                     *topLabel;
    
    int                         itemCountInCalendar;
    BOOL                        selected;
    id                          dataObj;
}
@property CalendarAppearance            calApperance;

@property(nonatomic, strong) id         dataObj;
@property(nonatomic, strong) NSDate		*focusDate;
@property(nonatomic, strong) NSDate		*currentMonthDate;
@property(nonatomic, strong) NSString	*title;
@property(nonatomic, strong) UILabel	*topLabel;


@property(nonatomic) int				itemCountInCalendar;


@property(nonatomic) BOOL				selected;

@end