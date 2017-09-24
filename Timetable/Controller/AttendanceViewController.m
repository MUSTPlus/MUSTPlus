//
//  AttendanceViewController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/4/30.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "AttendanceViewController.h"
#import "AttendanceHistoryTableViewController.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "WSGetWifi.h"
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif


@interface AttendanceViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic)   CLLocationManager *locationManager;
@property (nonatomic)               CLBeaconRegion      *beaconRegion;
@end

@implementation AttendanceViewController{
    BOOL flag;
}

-(NSString*)today{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
- (void)viewWillAppear:(BOOL)animated{
    flag = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _server = @"未连接";
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //[self startMonitoring];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-250) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:self.tableView];
    self.attendance = [[UIButton alloc]initWithFrame:CGRectMake((Width-100)/2, Height-250, 100, 100)];
    [self.attendance setTitle:@"开始签到" forState:UIControlStateNormal];
    [self.attendance setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.attendance addTarget:self action:@selector(startSign) forControlEvents:UIControlEventTouchDown];
    self.attendance.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.attendance.backgroundColor=navigationTabColor;
    self.status = [[UILabel alloc]initWithFrame:CGRectMake(0, Height-150, Width, 100)];
    self.status.textAlignment = NSTextAlignmentCenter;
    self.status.numberOfLines = 0;

    [self.attendance.layer setMasksToBounds: YES];
    [self.attendance.layer setCornerRadius:50.0f];
    [self.view addSubview:self.attendance];
    self.title = NSLocalizedString(@"签到", "");
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = doneButton;



    self.attendanceHistory = [[NSMutableArray alloc]init];

    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshStatus) userInfo:nil repeats:YES];

    [timer fire];
    [self.view addSubview:self.status];


    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        //定位功能可用
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        Alert* alert = [[Alert alloc]initWithTitle:@"提示" message:@"请给予此应用地理位置权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        //定位不能用
    }

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"签到历史" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHistory)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    self.centralManager= [[CBCentralManager alloc] initWithDelegate:self queue:nil];

}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:{
            Alert* alert = [[Alert alloc]initWithTitle:@"提示" message:@"请打开蓝牙以签到" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            self.found = NO;
            [self refreshStatus];
        }
            break;
        case CBCentralManagerStatePoweredOn:

            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            break;
        default:
            break;
    }

}
-(NSString*)WiFi{
    NSString* wifi = [WSGetWifi getSSIDInfo][@"SSID"];
    if (wifi)
        return wifi;
    else
        return @"未连接Wi-Fi";
}

-(NSString*)Bluetooth{
    if (self.found)
        return self.leapboxstatus;
    return @"未找到";

}

-(void)gotoHistory{
    AttendanceHistoryTableViewController* ctr = [[AttendanceHistoryTableViewController alloc]init];
    [self.navigationController pushViewController:ctr animated:YES];
}


-(NSArray<NSString*>*)TrustedWiFi{
    return @[@"MUST-DOT1X", @"MUST-STUDENT-S", @"eduoram",@"ABCDEFG"];
}
-(NSArray<NSString*>*)attendanceStatus{
    return [[NSArray alloc]initWithObjects:@"未签到",@"已签到",@"已签到-迟到",@"补签",@"缺勤",@"请假", nil];

}

-(void)checkServer{
    NSDictionary *o1 =@{@"stuid": [[Account shared]getStudentLongID]};
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@nowSchedule",AttendanceURL]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){
        
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        if (result == nil)
            [CirnoError ShowErrorWithText:NSLocalizedString(@"网络错误", "")];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        @try {
            if ([[json[@"status"]stringValue] isEqual:@"0"]){
                id result = json[@"result"];
                id course = result[@"course"];
                if (course!= NULL){
                    if (!_nowcourse)
                            self.nowcourse = [[AttendanceCourse alloc]init];
                NSString* cid = [course[@"id"] stringValue];
                NSString* coursecode =course[@"coursecode"];
                NSString* cls = course[@"class"];
                NSString* semester= [course[@"semester"]stringValue];
                NSString* starttime= [result[@"start_time"]stringValue];
                NSString* endtime = [result[@"end_time"]stringValue];
                NSString* sid = [result[@"id"]stringValue];
                [self.nowcourse initWithCid:cid
                                                        andCourseCode:coursecode
                                                               andCls:cls
                                                          andSemester:semester
                                                         andStartTime:starttime
                                                           andEndTime:endtime
                                                               andSid:sid
                                                andAid:result[@"lastaid"]
                                  ];
                id leapbox = result[@"leapBox"];
                self.leapboxid = leapbox[@"id"];
                self.macaddress = leapbox[@"macaddress"];
                self.major = leapbox[@"major"];
                self.minor = leapbox[@"minor"];
                self.ssid = leapbox[@"ssid"];
                self.uuid = leapbox[@"uuid"];
                self.lastaid = result[@"lastaid"];
                if ([result[@"status"] intValue] == -1)
                    self.signstatus = @"未开启签到";
                else
                    self.signstatus = [
                                   self.attendanceStatus objectAtIndex:[result[@"status"] intValue]
                                   ];
                id teacher = result[@"teacher"];
                self.teacher = teacher[@"chn_name"];
                self.teacherEn = teacher[@"eng_name"];

                [self startMonitoring];

                }
            } else self.signstatus = @"未开启签到";
        } @catch (NSException *exception) {
            _server = @"未连接";
        } @finally {
            [self.tableView reloadData];
        }
        _server = @"已连接";
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        _server = error.localizedDescription;
    }];
    [self checkHistory];
}

-(void)checkHistory{
    if (!self.nowcourse) return;
    NSDictionary *o1 =@{@"stuid": [[Account shared]getStudentLongID],
                        @"sid":     self.nowcourse.sid};
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@signHistory",AttendanceURL]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        if (result == nil)
            [CirnoError ShowErrorWithText:NSLocalizedString(@"网络错误", "")];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        @try {
            if ([json[@"status"] isEqual:@"0"]){
                id result = json[@"result"];
                self.attendanceHistory = [[NSMutableArray alloc]init];
                for (id attendance in result){
                    [self.attendanceHistory addObject:[[Attendance alloc]initWithLabel:
                                                      [self.attendanceStatus objectAtIndex:[attendance[@"status"]intValue]
                                                       ]
                                                                              andTime:[attendance[@"signtime"]stringValue]]];

                }
            }
        } @catch (NSException *exception) {

        } @finally {
            [self.tableView reloadData];
        }
        _server = @"已连接";
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        _server = error.localizedDescription;
    }];

}
-(void)checkStatus{
    if (!_nowcourse) return;
    NSDictionary *o1 =@{@"stuid": [[Account shared]getStudentLongID],
                        @"aid":     self.nowcourse.aid};
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@signStatus",AttendanceURL]];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){

        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        if (result == nil)
            [CirnoError ShowErrorWithText:NSLocalizedString(@"网络错误", "")];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        @try {
            if ([json[@"status"] isEqual:@"0"]){
                id result = json[@"result"];
                self.attendanceHistory = [[NSMutableArray alloc]init];
                for (id attendance in result){
                    [self.attendanceHistory addObject:[[Attendance alloc]initWithLabel:
                                                       [self.attendanceStatus objectAtIndex:[attendance[@"status"]intValue]
                                                        ]
                                                                               andTime:[attendance[@"signtime"]stringValue]]];

                }
            }
        } @catch (NSException *exception) {

        } @finally {
            [self.tableView reloadData];
        }
        _server = @"已连接";
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        _server = error.localizedDescription;
    }];

}
-(NSString*)unixToNSDate:(NSString*)unix{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    return [formatter stringFromDate:
            [
             [NSDate alloc]initWithTimeIntervalSince1970:
             [unix doubleValue]
             ]
            ];
}

-(void)refreshStatus{
    [self checkServer];
    BOOL enabled = TRUE;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:
    [NSString stringWithFormat:@"当前Wi-Fi:%@ \n当前Leapbox状态:%@ \n当前服务器状态:%@",[self WiFi],[self Bluetooth],self.server]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, [str length])];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, [[self WiFi] length])];
    enabled = NO;
    for (NSString* s in [self TrustedWiFi])
        if ([[self WiFi] isEqualToString:s]){
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(8, [[self WiFi] length])];
            enabled = YES;
        }




    if ([[self Bluetooth] isEqualToString:@"未找到"]){
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([[str string]rangeOfString:@"当前Leapbox状态:"].location+[@"当前Leapbox状态:" length], 3)];
        enabled = NO;
    }
    else
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange([[str string]rangeOfString:@"当前Leapbox状态:"].location+[@"当前Leapbox状态:" length], [self.leapboxstatus length])];
    if ([self.server isEqualToString:@"已连接"])
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange([[str string]rangeOfString:@"当前服务器状态:"].location+[@"当前服务器状态:" length], 3)];
    else{
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([[str string]rangeOfString:@"当前服务器状态:"].location+[@"当前服务器状态:" length], [self.server length])];
        enabled = NO;
    }


    self.status.attributedText = str;
    [self.attendance setTitle:self.signstatus forState:UIControlStateNormal];

    if ([self.signstatus isEqualToString:self.attendanceStatus[0]]&&enabled){
        self.attendance.backgroundColor = navigationTabColor;
        self.attendance.enabled = YES;
    } else {
        self.attendance.backgroundColor = kColor(166, 166, 166);
        self.attendance.enabled = NO;
    }

    
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}


- (void)startMonitoring
{
    if(flag)
        return;
    flag = true;
    //uuid、major、minor跟iBeacon的参数对应。
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:self.uuid]
                                                            major:[self.major intValue]
                                                            minor:[self.minor intValue]
                                                       identifier:@"C301"];
    if (!_beaconRegion)
        return;
//  //  _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"]
//                                                            major:1000
//                                                            minor:1001
//                                                       identifier:@"C301"];

    [self.locationManager startMonitoringForRegion:_beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:_beaconRegion];
}
-(void)endMonitoring{
    if (_beaconRegion){
    [self.locationManager stopMonitoringForRegion:_beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:_beaconRegion];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [self endMonitoring];
}
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
        return [_attendanceHistory count];
    if (self.nowcourse)
        return 2;
    else
        return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"当前进行的课程";
    if (section==1)
        return @"本节课签到历史";

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.detailTextLabel.alpha = 0.5;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row ==0){
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",self.nowcourse.coursecode,self.nowcourse.coursename];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ~ %@",
                                             [self unixToNSDate:self.nowcourse.startTime],[self unixToNSDate:self.nowcourse.endTime]];
            }
            else {
                cell.textLabel.text = self.teacher;
                cell.detailTextLabel.text = self.teacherEn;
            }
            break;
        case 1:

            cell.textLabel.text = _attendanceHistory[indexPath.row].label;
            cell.detailTextLabel.text = [self unixToNSDate:_attendanceHistory[indexPath.row].time];
            break;
        default:
            break;
    }

    //if (indexPath.section == 0)
        cell.userInteractionEnabled = NO;
    return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



#pragma mark -Button attendanceSuccess click event

- (void)startSign
{
    if (!_nowcourse) return;
    NSDictionary *o1 =@{@"stuid": [[Account shared]getStudentLongID],
                        @"sid":     self.nowcourse.sid,
                        @"token":   [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceID"],
                        @"aid":     self.nowcourse.aid,
                        @"source":@"1"};
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@startSign",AttendanceURL]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){

        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        if (result == nil)
            [CirnoError ShowErrorWithText:NSLocalizedString(@"网络错误", "")];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        @try {
            id result = json[@"msg"];
            Alert* alert = [[Alert alloc]initWithTitle:@"提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.attendance.enabled = NO;
        } @catch (NSException *exception) {

        } @finally {
            self.attendance.backgroundColor = kColor(166, 166, 166);
            self.attendance.enabled = NO;
            [self.tableView reloadData];

        }

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        Alert* alert = [[Alert alloc]initWithTitle:@"提示" message:error.localizedDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];

}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"!!!");
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion");

}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CirnoLog(@"%@",beacons);
    self.found = [beacons count]!=0 ;

    for (CLBeacon* beacon in beacons){
    //    CirnoLog(@"%@",beacons);
     //    CirnoLog(@"强度为:%ld",(long)beacon.rssi);
        self.leapboxstatus = [NSString stringWithFormat:@"信号强度:%ld",(long)beacon.rssi];

    }
    self.found = [beacons count]!=0 ;
    //CirnoLog(@"%lu,%d",(unsigned long)[beacons count],[beacons count]!=0);

}

@end
