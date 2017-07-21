//
//  AttendanceViewController.h
//  MUSTPlus
//
//  Created by Cirno on 2017/4/30.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicHead.h"
#import "AFNetworking.h"
#import "Account.h"
#import "AttendanceHeaderView.h"
#import "AttendanceTableViewCell.h"
#import "TimeLineView.h"
#import "Attendance.h"
#define kCellHeight             90
#define kDelayFactor            0.3
#define kAnimationDuration      0.6
@interface AttendanceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate,AttendanceDelegate>
@property (nonatomic,strong) AttendanceHeaderView* headerView;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic,strong) UILabel* ibeaconStatus;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, weak) TimeLineView *timeLineView;
@property (nonatomic, strong) TimeLineView *tableLine;
@property (nonatomic,strong) NSString* str;
@property (nonatomic,strong) NSString* studentID;
@property (nonatomic,strong) NSString* courseCode;
@property (nonatomic,strong) NSString* teacherName;
@property (nonatomic,strong) NSString* status;
@property (nonatomic,strong) NSString* email;
@property (nonatomic, strong) NSMutableArray<Attendance*> *attendanceArrays;
@end
