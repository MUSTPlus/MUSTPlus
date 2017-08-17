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
#import "Attendance.h"
#import "AttendanceCourse.h"
#import "MessageController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface AttendanceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate,CBCentralManagerDelegate>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UIButton* attendance;
@property (nonatomic,strong) UILabel* status;
@property  (nonatomic,strong) NSString* server;
@property BOOL found;
@property (nonatomic,strong) AttendanceCourse* nowcourse;

@property (nonatomic,strong) NSString* major;
@property (nonatomic,strong) NSString* minor;
@property (nonatomic,strong) NSString* ssid;
@property (nonatomic,strong) NSString* uuid;
@property (nonatomic,strong) NSString* macaddress;
@property (nonatomic,strong) NSString* leapboxid;
@property (nonatomic,strong) NSString* lastaid;
@property (nonatomic) CBCentralManager* centralManager;

@property (nonatomic,strong) NSString * teacher;
@property (nonatomic,strong) NSString* teacherEn;
@property (nonatomic,strong) NSString* signstatus;
@property (nonatomic,strong) NSString* leapboxstatus;
@property (nonatomic,strong) NSMutableArray<Attendance*>*attendanceHistory;

@end
