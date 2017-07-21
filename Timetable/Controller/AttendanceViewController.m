//
//  AttendanceViewController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/4/30.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "AttendanceViewController.h"
#import "HeiHei.h"
#import "NSString+AES.h"
@import CoreLocation;

@interface AttendanceViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic)   CLLocationManager *locationManager;
@property (nonatomic)               CLBeaconRegion      *beaconRegion;
@end

@implementation AttendanceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self startMonitoring];
    
    self.title = NSLocalizedString(@"签到", "");
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = doneButton;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"AttendanceHeaderView" owner:nil options:nil];

    self.headerView = [nibContents lastObject];
    self.headerView.frame = CGRectMake(0,StatusBarAndNavigationBarHeight, Width, 200);
    self.view.backgroundColor = kColor(242, 242, 242);
    self.courseCode = @"暂无课程";
    [self.headerView initWithDate:@"" andCourse:@"" andStatus:@""];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, Width, Height-200) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AttendanceTableViewCell" bundle:nil] forCellReuseIdentifier:@"attendanceTableViewCell"];
    self.tableView.backgroundColor = kColor(242, 242, 242);
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    self.headerView.delegate = self;
    self.studentID = [[Account shared] getStudentLongID];
    NSTimer * timer =  [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(getStatus) userInfo:nil repeats:YES];
    self.ibeaconStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, (Height-300)/2, Width, 50)];
    self.ibeaconStatus.textAlignment=NSTextAlignmentCenter;
    self.ibeaconStatus.font = [UIFont systemFontOfSize:25 weight:UIFontWeightUltraLight];
    self.ibeaconStatus.textColor = navigationTabColor;
    self.ibeaconStatus.alpha = 0.3f;
    self.ibeaconStatus.hidden = YES;
    [self.tableView addSubview:self.ibeaconStatus];
    [self setButtonOff];
    // [timer setFireDate:[NSDate date]];
    [timer fire];
    //每1秒运行一次function方法。
}
- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}


- (void)startMonitoring
{
    //uuid、major、minor跟iBeacon的参数对应。
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"]
                                                            major:1001
                                                            minor:1000
                                                       identifier:@"test"];
    [self.locationManager startMonitoringForRegion:_beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:_beaconRegion];
}
-(void)endMonitoring{
    [self.locationManager stopMonitoringForRegion:_beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:_beaconRegion];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self endMonitoring];
}
-(void)didClickSign{
    [self signIn:self.studentID and:self.courseCode];
    [self attendanceCenterClick];
}
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attendanceArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendanceTableViewCell"];
    cell.timeLabel.text = _attendanceArrays[indexPath.row].time;
    cell.addressLabel.text = _attendanceArrays[indexPath.row].label;
    cell.backgroundColor = kColor(242, 242, 242);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell.tag == 11) {
        cell.tag = 0;
        [cell setNeedsDisplay];
    }
    if (indexPath.row == self.attendanceArrays.count-1) {
        cell.tag = 11;
        [cell setNeedsDisplay];
    }
    return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

-(void)ibeaconFind{

   // self.ibeaconStatus.hidden = NO;
    self.headerView.bluetooth.text = @"蓝牙状态 ⭕️";
    if ([self.status isEqualToString:@"已签到"]||[self.courseCode isEqualToString:@"暂无课程"]){
        [self setButtonOff];
    }else
    [self setButtonOn];
}
-(void)ibeaconNotFound{

  //  self.ibeaconStatus.hidden = NO;
    self.headerView.bluetooth.text =@"蓝牙状态 ❌";
    if ([self.status isEqualToString:@"已签到"]||[self.courseCode isEqualToString:@"暂无课程"]){
        [self setButtonOff];
    }else
    [self setButtonOff];
}


-(void)signIn:(NSString*)studID
          and:(NSString*)courseCode{
    NSString * udid = [[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"];
    NSDictionary *o1 =@{@"studentID":self.studentID,
                        @"UDID":udid,
                        @"courseid":courseCode};
    
    NSURL *URL = [NSURL URLWithString:@"http://www.ohurray.com/api/sign"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager GET:URL.absoluteString parameters:o1 progress:nil success:^(NSURLSessionTask *task, id responseObject) {

       
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"result=%@",error);
    }];

}
-(void)getStatus{
    NSDictionary *o1 =@{@"studentID":self.studentID};
    NSURL *URL = [NSURL URLWithString:@"http://www.ohurray.com/getUserInfo"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager GET:URL.absoluteString parameters:o1 progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.attendanceArrays = [[NSMutableArray alloc]init];
        //NSLog(@"result=%@",json);
        if([json count] > 0){
            id h= json[0];
            NSString *teacherName = h[@"teacherName"];
            NSString *email       = h[@"email"];
            NSString *courseCode  = h[@"courseCode"];
            NSArray* history = h[@"signHistory"];
            for (id test in history){
                Attendance * t = [[Attendance alloc]init];
                t.time = test[@"time"];
                t.label = test[@"classRoom"];
                [self.attendanceArrays addObject:t];
            }
            self.email = email;
            self.teacherName = teacherName;
            self.courseCode = courseCode;
            
            if([h[@"isSigned"] isEqualToString:@"0"]){
                self.status = @"已签到";
            }
            
            if ([h[@"isSigned"] isEqualToString:@"1"])
                self.status = @"未签到";
            if ([self.attendanceArrays count]==0){
                self.status = @"暂未开启签到";
            }
        }
        else{
    
        }
        [self reloadView];
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"%@",error);

    }];

}
-(void)reloadView{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.headerView.Date.text = [formatter stringFromDate:[NSDate date]];
    self.headerView.Course.text= self.courseCode;
    self.headerView.Status.text = self.status;
    if ([self.status isEqualToString:@"已签到"]){
        [self setButtonOff];
    }
}
#pragma mark -Button attendanceCenter click event
-(void)setButtonOn{
    NSLog(@"on");
    self.headerView.Attendance.backgroundColor = navigationTabColor;
    self.headerView.Attendance.userInteractionEnabled = YES;
}
-(void)setButtonOff{
    NSLog(@"off");
    self.headerView.Attendance.backgroundColor = [UIColor grayColor];
    self.headerView.Attendance.userInteractionEnabled = NO;
}
- (IBAction)attendanceCenterClick {
    if (self.isAnimating) {
        NSLog(@"正在动画...");
        return;
    }
    [self setButtonOff];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
   // [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
    self.coverView.hidden = NO;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    Attendance* t = [[Attendance alloc]init];
    t.label = @"C302";
    t.time=[formatter stringFromDate:[NSDate date]];
    [self.attendanceArrays insertObject:t atIndex:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

    AttendanceTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    UIView *newCell = [cell snapshotViewAfterScreenUpdates:YES];
    newCell.frame = CGRectMake(0, -kCellHeight, cell.frame.size.width, kCellHeight);
    [self.coverView insertSubview:newCell aboveSubview:self.timeLineView];
    [self markerImageViewBeginAnimation];
    [self cellAnimation];
}

#pragma mark -Button attendanceSuccess click event

- (IBAction)attendanceSuccessClick
{
//    CALayer *layer = self.markerImageView.layer;
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y-15)];
//    animation.autoreverses = YES;
//    animation.duration = kAnimationDuration;
//    animation.repeatCount = 2;
//    animation.removedOnCompletion = NO;
//    [layer addAnimation:animation forKey:nil];
}

#pragma mark -Cell animation

- (void)cellAnimation
{
    NSInteger tableViewH = [UIScreen mainScreen].bounds.size.height -100 -64 -100;
    NSInteger cellCount = 2 + tableViewH / kCellHeight;
    self.isAnimating = YES;
    NSInteger index = 0;
    NSInteger count = self.coverView.subviews.count -1;
    if (count > cellCount) {
        count = cellCount;
    }
    self.timeLineView.frame = CGRectMake(1, 0, 40, (count-1) *kCellHeight);
    for (NSInteger i=count; i>=0; i--) {
        if (i == 0) {
            return;
        }
        UIView *subview = self.coverView.subviews[i];
        if ([subview isKindOfClass:[TimeLineView class]]) {
            continue;
        }
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.layer.position.x, subview.layer.position.y+kCellHeight)];
        animation.duration = kAnimationDuration -0.1;
        animation.removedOnCompletion = NO;
        if (i == 1) {
            animation.delegate = self;
        }
        animation.fillMode = kCAFillModeForwards;
        animation.beginTime = CACurrentMediaTime()+kDelayFactor*index +kAnimationDuration;
        [subview.layer addAnimation:animation forKey:nil];
        index++;
    }
}

#pragma mark -CAAnimationDelegate

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    self.coverView.hidden = YES;
    self.isAnimating = NO;
    for (UIView *subview in self.coverView.subviews) {
        if ([subview isKindOfClass:[TimeLineView class]]) {
            continue;
        }
        [subview.layer removeAllAnimations];
        subview.frame = CGRectOffset(subview.frame, 0, kCellHeight);
    }
}

#pragma mark -MarkerImageView animation

- (void)markerImageViewBeginAnimation
{
//    CALayer *layer = self.markerImageView.layer;
//    CABasicAnimation *animTranslate = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
//    animTranslate.toValue = @(-46-15);
//    CABasicAnimation *animScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animScale.toValue = @(1.5);
//
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.animations = @[animTranslate];
//    group.duration = kAnimationDuration;
//    group.autoreverses = YES;
//    [layer addAnimation:group forKey:nil];
}


#pragma mark -lazy coverView

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.tableView.frame];
//        _coverView.backgroundColor = [UIColor whiteColor];
        _coverView.backgroundColor = kColor(242, 242, 242);
        self.tableView.backgroundColor = kColor(242, 242, 242);
//        self.tableView.backgroundColor = [UIColor whiteColor];
        TimeLineView *timeLineView = [[TimeLineView alloc] initWithFrame:CGRectMake(1, 0, 40, _coverView.frame.size.height -35)];
        self.timeLineView = timeLineView;
    //    timeLineView.backgroundColor = [UIColor whiteColor];
        timeLineView.backgroundColor = kColor(242, 242, 242);
        [_coverView addSubview:timeLineView];
        NSArray *visibleCells = [self.tableView visibleCells];
        for (AttendanceTableViewCell *cell in visibleCells) {
            UIView *copyCell = [cell snapshotViewAfterScreenUpdates:YES];
            copyCell.frame = cell.frame;
            [_coverView addSubview:copyCell];
        }

    }
    [self.view bringSubviewToFront:self.headerView];
    return _coverView;
}

#pragma mark -lazy attendanceArrays

- (NSMutableArray *)attendanceArrays
{
    if (!_attendanceArrays) {
        _attendanceArrays = [NSMutableArray array];
     //   [_attendanceArrays addObject:@"1"];
    //    [_attendanceArrays addObject:@"1"];
    }
    return _attendanceArrays;
}

#pragma mark -TableView timeLine

- (TimeLineView *)tableLine
{
    if (!_tableLine) {
        _tableLine = [[TimeLineView alloc] init];
        _tableLine.backgroundColor = self.tableView.backgroundColor;
        [self.tableView addSubview:_tableLine];
    }
    return _tableLine;
}

#pragma  mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        self.tableLine.frame = CGRectMake(1, scrollView.contentOffset.y, 40, -scrollView.contentOffset.y);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isAnimating) {
        return;
    }
    [self markerImageViewBeginAnimation];
  //  [self earthImageViewBeginAnimation];
}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    BOOL find = NO;
    for (CLBeacon *beacon in beacons) {
        NSLog(@"find");
        [self ibeaconFind];
        find = YES;
    }
    if (!find)
        [self ibeaconNotFound];
}

@end
