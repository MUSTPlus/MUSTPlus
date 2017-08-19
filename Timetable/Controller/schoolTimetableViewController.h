//
//  schoolTimetableViewController.h
//  MUST_Plus
//
//  Created by zbc on 16/10/3.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekTitleScrollView.h"
#import "NewWeekTitleView.h"
#import "NewTimeView.h"
#import "WeekTool.h"
#import "Semester.h"
#import "NewClassView.h"
#import "TimeScrollView.h"
#import "SchoolTimeTableHeadView.h"
#import "SchoolClassScrollView.h"
#import "ClassButton.h"
#import "NirKxMenu.h"
#import "SubLBXScanViewController.h"
#import <EventKit/EventKit.h>
#import "CZPicker.h"
#import "Semester.h"
#import "AttendanceViewController.h"
@interface schoolTimetableViewController : UIViewController<HeadButtonDelegate,SchoolClassScrollDelegate,SchoolClassClickDelegate,MenuDelegate,CZPickerViewDataSource, CZPickerViewDelegate>

@property (nonatomic,strong) WeekTitleScrollView *weakTitle;

@property (nonatomic,strong) SchoolTimeTableHeadView *head;
@property (nonatomic,strong) TimeScrollView *time;
@property (nonatomic,strong) Semester* nowSemester;
@property (nonatomic,strong) SchoolClassScrollView *scroll;

@property (nonatomic,strong) UIImageView *backgroudView;
@property (strong,nonatomic) UIView * contentView;
@property (strong,nonatomic) UIView * navBackView;
@property (assign,nonatomic) BOOL sideBarShowing;
/////////////////////////////////////////////////////////
@property (nonatomic,strong) NewClassView* classView;
@property (strong,nonatomic) NSArray<UIColor*>* colorArray;
@property (nonatomic,strong) NewWeekTitleView *weeekTitle;
@property (nonatomic,strong) NewTimeView *timeview;
@property (nonatomic,strong) EKEventStore* 	eventStore;
@end

