//
//  CalendarView.h
//  WorkBench
//
//  Created by John Basile on 6/26/12.
//
//

#import <UIKit/UIKit.h>
#import "CalendarLayoutView.h"
#import "DateUtil.h"

#define FRM_X	100                     // Main Frame/position where the calendar is set.
#define FRM_Y	100
#define FRM_W	320
#define FRM_H	366

#define BCK_X	FRM_X - 2               // BackgroundView, slightly larger than the calendar - for effect
#define BCK_Y	FRM_Y
#define BCK_W	FRM_W + 4
#define BCK_H	FRM_H + 2

#define MON_X	2                       // Month Label
#define MON_Y	0
#define MON_W	FRM_W
#define MON_H	35

#define LFT_X	0                      // Left Button
#define LFT_Y	3
#define LFT_W	33
#define LFT_H	29

#define RGT_X	284                     // Right Button
#define RGT_Y	3
#define RGT_W	33
#define RGT_H	29

#define Cal_X	FRM_X                   // The Calendar
#define Cal_Y	FRM_Y + 50
#define Cal_W	FRM_W
#define Cal_H	344
#define Cal_HS	53

#define CLV_WD  FRM_W                   // calendarView
#define CLV_MH  Cal_H
#define CLV_WH  Cal_HS
#define CLV_Cx  2
#define CLV_Cy  49

#define DBT_WD  22                      // disclosureButton
#define DBT_HT  21
#define DBT_Cx  290
#define DBT_My  10
#define DBT_Wy  10


#define CHV_WD  FRM_W                   // calendarHeaderView
#define CHV_HT  40
#define CHV_Cx  2
#define CHV_My  CLV_Cy + Cal_H + 20
#define CHV_Wy  CLV_Cy + Cal_HS - 2

#define HBT_WD  287                    // headerViewTapButton
#define HBT_HT  37
#define HBT_Cx  2
#define HBT_My  0
#define HBT_Wy  0

#define CAR_WD  45                    // calendarHeaderArrow
#define CAR_HT  14
#define CAR_Cx  2
#define CAR_My  CHV_My - CAR_HT
#define CAR_Wy  CHV_Wy - CAR_HT +1



@interface CalendarView : UIView
{
    UILabel				*monthLabel;
    UIButton			*leftButton;
    UIButton			*rightButton;
    
    UIView				*calendarHeaderView;
    UIImageView         *calendarHeader;
    UIImageView         *calendarHeaderArrow;
    UIButton			*disclosureButton;
    UIButton			*headerViewTapButton;
	
	NSDate				*focusDate;
	CalendarLayoutView	*calendarView;
    UITableView         *addedDisplay;
	NSDate				*startViewingDate;
	NSDate				*endViewingDate;
}

@property (nonatomic, strong) UIView        *calendarHeaderView;
@property (nonatomic, strong) UITableView   *addedDisplay;
@property (nonatomic, strong) UILabel       *monthLabel;
@property (nonatomic, strong) UIButton      *leftButton;
@property (nonatomic, strong) UIButton      *rightButton;
@property (nonatomic, strong) NSDate        *focusDate;
@property (nonatomic, strong) NSDate        *startViewingDate;
@property (nonatomic, strong) NSDate        *endViewingDate;

@property (nonatomic, strong) UIButton      *disclosureButton;
@property (nonatomic, strong) UIButton      *headerViewTapButton;
@property (nonatomic, strong) UIImageView	*calendarHeader;
@property (nonatomic, strong) UIImageView	*calendarHeaderArrow;

@property (nonatomic, strong) CalendarLayoutView   *calendarView;


- (void)prevCalMonth: (id) sender;
- (void)nextCalMonth: (id) sender;
- (void)setUpView;

@end
