//
//  CalendarLayoutView.h
//
//  Created by John Basile.
//  Copyright 2010 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayView.h"

#define ColPadding			  0.0
#define BorderPadding	      0.0
#define XOffset				  0.0
#define YOffset				  0.0	// NavBar
#define BOffset				  0.0	// HistoryBar
#define SOffset				  0.0	// StatusBar

#define DaysPerRow		7.0
#define DaysPerCol		6.0

#define CalendarWidthP	320.0
#define CalendarHeightP	318.0
#define CalendarWidthL  320.0


typedef enum
{
    Cal_MonthView = 0,
	Cal_WeekView,
    Cal_DayView
} CalendarAppearance;

@interface CalendarLayoutView : UIScrollView <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGPoint                     touchLocation;
	NSDate						*selectedDate;              // date prsently selected
	NSDate						*preScrollDate;             // previous selection date
    
	id							selectionDelegate;          // for updating cell selection to the parent
	SEL							callback;
    
	id							dateDelegate;               // for updating the focus date to the parent
	SEL							dcallback;
    
	NSArray						*items;
	NSMutableArray				*itemViews;
	CGSize						_itemSize;
	NSDate						*currentMonth;
	UIColor						*bckColor;					// Color for the Background... Default Clear Color
	BOOL						byColandRow;
	BOOL						toggleSelection;            // if on = Selection of a Cell goes on and off
	int							pgn;
	int							SelectedItem;				// good for selecting Dates
	CGFloat						dayCellWidth;					// used when the UIView is bigger than the content
	CGFloat						dayCellHeight;
	int							nCols;
	int							nRows;
	CalendarAppearance          calApperance;
    
	UIView						*__weak supView;            // the superView the ScrollView is to be added. (if nil, already in XIB)
}

@property (nonatomic) CGPoint touchLocation;

@property (nonatomic) BOOL byColandRow;

@property (nonatomic, getter=toggleSelection) BOOL toggleSelection;

@property (nonatomic, strong) NSMutableArray       *itemViews;

@property (nonatomic, strong) UIColor               *bckColor;
@property (nonatomic, strong) NSDate                *selectedDate;
@property (nonatomic, strong) NSDate                *preScrollDate;

@property (nonatomic, strong) NSDate                *currentMonth;
@property (nonatomic, weak)   UIView                *supView;
@property (nonatomic, strong) id                    selectionDelegate;
@property (nonatomic, strong) id                    dateDelegate;

@property (nonatomic) SEL                           callback;
@property (nonatomic) SEL                           dcallback;

@property CalendarAppearance                  calApperance;

@property int				nCols;
@property int				nRows;
@property int				pgn;
@property CGFloat			dayCellWidth;
@property CGFloat			dayCellHeight;
@property int				SelectedItem;

@property (nonatomic, strong) NSArray *items;

- (id)initWithFrame:(CGRect)frame thisMonth:(NSDate *)thisMonth;
- (id)initWithFrame:(CGRect)frame thisWeek:(NSDate *)thisWeek;
- (void) setPagingMode;
- (void) clearItems;
- (void) CalendarLayoutVertical;
- (void) CalendarLayoutMonthView;
- (void) CalendarLayoutWeekView;
- (void) setUp;
- (void) setSelectionCallBack:(id)theDelegate theSelector:(SEL)requestSelector;
- (void) setFocusDateCallBack:(id)theDelegate theSelector:(SEL)requestSelector;
- (void) bkgroundColor:(UIColor *) color;
- (void) initWithSize:(CGSize)iSize withMonth:(NSDate *)thisMonth withPosition:(CalendarAppearance)pos withView:(UIView *)sView;
- (void) initByColAndRows:(int)nCol rows:(int)nRow withMonth:(NSDate *)thisMonth withView:(UIView *)sView;
- (void) computeRangeForMonth:(NSDate *)monthOfDate;
- (void) implementWeekView;
- (void) implementMonthView;

@end

