//
//  schoolTimetableViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/10/3.
//  Copyright © 2016年 zbc. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "schoolTimetableViewController.h"
#import "CirnoSideBarViewController.h"
#import "NewWeekTitleView.h"
#import "SchoolClassModel.h"
#import "YMSOpenNotifyDownView.h"
#import "AFNetworking.h"
#import "LeftViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "HeiHei.h"
#import "NSString+AES.h"
#import <UserNotifications/UserNotifications.h>
#import "ChangeIcon.h"
#import "TimetableLogic.h"//判断课程逻辑
#import "SchoolClassCoreDataManager.h" //课程表数据库
//#import "FLEXManager.h"
#import "Account.h"
#import "CirnoError.h"
#import "CourseDetailViewController.h"
#import "UserModel.h"
#import "ClassTool.h"
@interface schoolTimetableViewController ()<CardDownAnimationViewDelegate,WeakTtileButtonDelegate,AlertDelegate>;
@property (strong,nonatomic) UIViewController * leftViewController;

//侧边栏
@end

@implementation schoolTimetableViewController{
    YMSOpenNotifyDownView *openNotifyDownView; //点击课程显示详细页面
    NSMutableArray<ClassButton *> *ButtonArr;
    SchoolClassCoreDataManager *schoolClassManager;
    NSMutableArray *classArray;
    NSString* semester;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  //  NSLog(@"begin");
    //CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView.panGestureRecognizer.view];
    CGPoint translation = [scrollView.panGestureRecognizer  translationInView:scrollView.panGestureRecognizer.view];
   // NSLog(@"translation.x is %f velocity.x is %f",translation.x,velocity.x);
    //如果scrollview的偏移为0并且手势方向为从左向右滑,则显示左边SideBar
    if (scrollView.contentOffset.x == 0 && translation.x > 0) {
        [[CirnoSideBarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    }
}
- (void)btnLeft{
    CirnoSideBarViewController * sideBar = [CirnoSideBarViewController share];
    if (sideBar.sideBarShowing == YES) {
        [[CirnoSideBarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
    }
    else
    {
        [[CirnoSideBarViewController share]showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    }
}
- (WeekTool*)wt{
    WeekTool * weektool = [[WeekTool alloc]init];
    [weektool setStartDate:[self.sDate objectForKey:self.Semester]];
    [weektool setEndDate:[self.eDate objectForKey:self.Semester]];
    weektool.semester = self.Semester;
    return weektool;
}
- (void) AddToCalendar{
    for(MyClass *class in classArray){
        NSString* classRoom = class.class_Room;
        NSString* classweek = class.class_Week;
        NSString* classNum  = class.class_Number;
        NSString* classNo   = class.class_No;
        NSString* classStart= class.class_StartTime;
        NSString* className = class.class_Name;
        NSString* classStM  = class.class_StartMonth;
        NSString* classEnM  = class.class_EndMonth;
        NSString* classEnd  = class.class_EndTime;
        NSString* classTea  = class.class_Teacher;
        CirnoLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@",classRoom,classweek,classNum,classNo,classStart,className,classStM,classEnM,classEnd,classTea);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString* nowYear = [[[[Account shared]getSemester]stringByReplacingOccurrencesOfString:@"09" withString:@""]stringByReplacingOccurrencesOfString:@"02" withString:@""];
        CirnoLog(@"%@",nowYear);
        [formatter setDateFormat:@"yyM月d hh:mm"];
        NSDate * tmp1 =[formatter dateFromString:[NSString stringWithFormat:@"%@%@ %@",nowYear,[self fuckthedate:class.class_StartMonth],classStart]];
        NSDate * tmp2 =[formatter dateFromString:[NSString stringWithFormat:@"%@%@ %@",nowYear,[self fuckthedate:class.class_EndMonth],classEnd]];
        CirnoLog(@"%@ %@",tmp1,tmp2);
    }
}

-(NSString*)fucktheweek:(NSString*)week{
    week=[week stringByReplacingOccurrencesOfString:@"1" withString:NSLocalizedString(@"星期一","")];
    week=[week stringByReplacingOccurrencesOfString:@"2" withString:NSLocalizedString(@"星期二","")];
    week=[week stringByReplacingOccurrencesOfString:@"3" withString:NSLocalizedString(@"星期三","")];
    week=[week stringByReplacingOccurrencesOfString:@"4" withString:NSLocalizedString(@"星期四","")];
    week=[week stringByReplacingOccurrencesOfString:@"5" withString:NSLocalizedString(@"星期五","")];
    week=[week stringByReplacingOccurrencesOfString:@"6" withString:NSLocalizedString(@"星期六","")];
    week=[week stringByReplacingOccurrencesOfString:@"7" withString:NSLocalizedString(@"星期日","")];
    return week;
}
-(NSString*)weekthefuck:(NSString*)week{
    week=[week stringByReplacingOccurrencesOfString:@"星期一" withString:@"1"];
    week=[week stringByReplacingOccurrencesOfString:@"星期二" withString:@"2"];
    week=[week stringByReplacingOccurrencesOfString:@"星期三" withString:@"3"];
    week=[week stringByReplacingOccurrencesOfString:@"星期四" withString:@"4"];
    week=[week stringByReplacingOccurrencesOfString:@"星期五" withString:@"5"];
    week=[week stringByReplacingOccurrencesOfString:@"星期六" withString:@"6"];
    week=[week stringByReplacingOccurrencesOfString:@"星期日" withString:@"7"];
    return week;
}
-(NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString{

    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];

    [inputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *formatterDate=[inputFormatter dateFromString:dateString];

    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];

    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    [outputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];

    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];

    return [self weekthefuck:[weekArray objectAtIndex:0]];

}
-(void)AddtoCalendar{
    self.eventStore = [[EKEventStore alloc] init];


    EKEventStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error){
        if(granted) {
            EKCalendar * cal = [EKCalendar calendarWithEventStore:_eventStore];
            cal.title = NSLocalizedString(@"MUST+", "");
            NSArray*tempA=[self.eventStore calendarsForEntityType:EKEntityTypeEvent];
            for (EKCalendar* calendar in tempA){
                if ([calendar.title isEqualToString:NSLocalizedString(@"MUST+", "")]){
                    Alert * alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"提示", "") message:NSLocalizedString(@"已有日历存在", "") delegate:self cancelButtonTitle:UIKitLocalizedString(@"Cancel") otherButtonTitles:NSLocalizedString(@"确定",""), nil];
                    [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
                        NSError* error;
                        if (buttonIndex == 1) {
                            BOOL result = [self.eventStore removeCalendar:calendar commit:YES error:&error];
                            if (result) {
                                [JDStatusBarNotification showWithStatus:NSLocalizedString(@"删除成功", "") dismissAfter:1.0f];
                            } else {
                                [CirnoError ShowErrorWithText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"删除失败", ""),error.localizedDescription]];
                                CirnoLog(@"%@",error.localizedDescription);
                            }
                        }
                    }];
                    [alert show];
                    return;

                }
            }
            EKSource *theSource = nil;
            for (EKSource *source in _eventStore.sources) {


                if (source.sourceType == EKSourceTypeLocal||[source.title isEqualToString:@"iCloud"]) {
                    theSource = source;
                    break;
                }
            }

            if (theSource) {
                cal.source = theSource;

            } else {
                [CirnoError ShowErrorWithText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"写入日历失败", "")]];
                return;
            }
            NSError *error = nil;
            BOOL result1 ;
            BOOL result = [_eventStore saveCalendar:cal commit:YES error:&error];
            NSCalendarIdentifier calendarIdentifier;
            for(MyClass *class in classArray){
                @try {
                NSString* classRoom = class.class_Room;
                NSString* classweek = class.class_Week;
                NSString* classNum  = class.class_Number;
                NSString* classNo   = class.class_No;
                NSString* classStart= class.class_StartTime;
                NSString* className = class.class_Name;
                NSString* classStM  = class.class_StartMonth;
                NSString* classEnM  = class.class_EndMonth;
                NSString* classEnd  = class.class_EndTime;
                NSString* classTea  = class.class_Teacher;
                CirnoLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@",classRoom,classweek,classNum,classNo,classStart,className,classStM,classEnM,classEnd,classTea);

                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                NSString* nowYear = [[[[Account shared]getSemester]stringByReplacingOccurrencesOfString:@"09" withString:@""]stringByReplacingOccurrencesOfString:@"02" withString:@""];
             //   CirnoLog(@"%@",nowYear);
                    if (!nowYear) nowYear = @"17";
                    // TO DO
                [formatter setTimeZone:[NSTimeZone systemTimeZone]];
                [formatter setLocale:[NSLocale currentLocale]];
                [formatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
                 [formatter setDateFormat:@"yyMM月d HH:mm"];
                NSString*tmpdate = [NSString stringWithFormat:@"%@%@ %@",nowYear,[self fuckthedate:class.class_StartMonth],classStart];
                CirnoLog(@"tmpdate%@",tmpdate);
                NSDate * tmp1 =[formatter dateFromString:tmpdate];
                NSDateFormatter * form1 = [[NSDateFormatter alloc]init];
                [form1 setDateFormat:@"yyyy-MM-dd"];
                NSString* weekday = [self getTheDayOfTheWeekByDateString:[form1 stringFromDate:tmp1]];
                CirnoLog(@"date:%@ ,weekday:%@,classWeek:%d",tmp1,weekday,[classweek intValue]);

                NSDateComponents *dayComponent = [[NSDateComponents alloc] init];

                dayComponent.day = abs(7-[weekday intValue]+[classweek intValue]);
               // dayComponent.day = [classweek intValue]-1;
                NSCalendar *theCalendar = [NSCalendar currentCalendar];
                tmp1 = [theCalendar dateByAddingComponents:dayComponent toDate:tmp1 options:0];
                    NSString* endMonth =[self fuckthedate:class.class_EndMonth];
                NSDate * tmp2 =[formatter dateFromString:[NSString stringWithFormat:@"%@%@ %@",nowYear,endMonth,classEnd]];
                CirnoLog(@"%@ %@",tmp1,tmp2);
                NSDate * endToday =[theCalendar dateByAddingComponents:dayComponent toDate:[formatter dateFromString:[NSString stringWithFormat:@"%@%@ %@",nowYear,[self fuckthedate:class.class_StartMonth],classEnd]]options:0];

                EKEvent* event = [EKEvent eventWithEventStore:_eventStore];
                event.title = [NSString stringWithFormat:@"%@ @ %@ (%@)",className,classRoom,classNo];
                event.notes = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",className,classRoom,classNo,classTea,classNum,[self fucktheweek:[classweek stringByReplacingOccurrencesOfString:@"0" withString:@""]]];
                event.startDate = tmp1;
                event.endDate = endToday;
                EKRecurrenceRule *rule =[[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:tmp2]];
                event.recurrenceRules=[[NSArray alloc]initWithObjects:rule, nil];
                [event setCalendar:cal];
                event.calendar = cal;
                event.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                event.location = classRoom;
                EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:-900];
                event.alarms = [[NSArray alloc]initWithObjects:alarm1, nil];
                result1 = [_eventStore saveEvent:event span:EKSpanFutureEvents commit:YES error:&error];

                }
                @catch (NSException *exception) {
                    [CirnoError ShowErrorWithText:[NSString stringWithFormat:@"添加课程时由于%@失败",exception]];
                } @finally {
                    if (result1){

                    } else {
                        CirnoLog(@"%@",error.localizedDescription);
                    }
                }
            }
            cal.CGColor = navigationTabColor.CGColor;

            result = [_eventStore saveCalendar:cal commit:YES error:&error];
            if (result) {
                calendarIdentifier = cal.calendarIdentifier;
                Alert* alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"提示", "") message:NSLocalizedString(@"写入日历成功", "")  delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", "") otherButtonTitles:nil];
                [alert show];

            } else {
                 [CirnoError ShowErrorWithText:[NSString stringWithFormat:@"添加课程时由于%@失败",error.localizedDescription]];
            }

        } else {
            [CirnoError ShowErrorWithText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"写入日历失败", "")]];
        }
    };
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:handler];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self chekcNotification];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:delegate];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } //NSString* page = @"TimeTable";

}
-(void)gotoUpdate{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://must.plus/"]];
}
-(void)viewWillDisappear:(BOOL)animated{
//NSString* page = @"TimeTable";
    NSString* page = @"TimeTable";
    [MTA trackPageViewEnd:page];
}
-(NSDictionary*)sDate{
    NSDictionary*dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                        @"2014-09-08",@"1409",
                        @"2015-01-12",@"1502",
                        @"2015-09-07",@"1509",
                        @"2016-01-11",@"1602",
                        @"2016-09-05",@"1609",
                        @"2017-02-06",@"1702",
                        @"2017-09-04",@"1709",
                        @"2018-01-15",@"1802", nil ];
    return dic;
}
-(NSDictionary*)eDate{
    NSDictionary*dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                        @"2014-12-19",@"1409",
                        @"2015-05-17",@"1502",
                        @"2015-12-19",@"1509",
                        @"2016-05-15",@"1602",
                        @"2016-12-17",@"1609",
                        @"2017-05-20",@"1702",
                        @"2017-12-17",@"1709",
                        @"2018-05-20",@"1802", nil ];
    return dic;
}
-(NSString*)Semester{
    return @"1802";
}

-(NSArray<UIColor*>*)colorArray{
    if (!_colorArray){
        _colorArray =[[NSArray alloc]initWithObjects:
                      kColor(84,188,225),
                      kColor(240,132,134),
                      kColor(124,214,149),
                      kColor(248,152,115),
                      kColor(120,210,209),
                      kColor(209,150,133),
                      kColor(118,156,228),
                      kColor(109,191,166),
                      kColor(161,142,215),
                      kColor(247,187,98),
                      kColor(229,128,162),
                      kColor(165,202,98),
                      kColor(240,132,134),
                      kColor(132,174,210), nil];
    }
    return _colorArray ;
}
- (void)viewDidLoad {

    [super viewDidLoad];
    //////



















    //////
    [self getRongCloudToken];
    _colorArray =[[NSArray alloc]initWithObjects:
                  kColor(84,188,225),
                  kColor(240,132,134),
                  kColor(124,214,149),
                  kColor(248,152,115),
                  kColor(120,210,209),
                  kColor(209,150,133),
                  kColor(118,156,228),
                  kColor(109,191,166),
                  kColor(161,142,215),
                  kColor(247,187,98),
                  kColor(229,128,162),
                  kColor(165,202,98),
                  kColor(240,132,134),
                  kColor(132,174,210), nil];
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);

        @try {
            NSString *urls = @"https://must.plus/settings.cirno";
            NSError *error = nil;
            NSURL *url = [NSURL URLWithString:urls];
            semester = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
            if (semester == nil){
            }

        } @catch (NSException *exception) {
            [CirnoError ShowErrorWithText:exception.description];
        } @finally{
            if (semester!= nil){
            }
        }
        dispatch_group_leave(group);
    });
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    self.nowSemester = [
                        [Semester alloc]initWithStartDate:
                        [self.sDate objectForKey:self.Semester]
                        andEndDate:
                        [self.eDate objectForKey:self.Semester]
                        andSemester:self.Semester];
    dispatch_group_async(group, queue2, ^{
        NSDictionary *o1 =@{@"ec":@"9992",
                            @"getBannedStatus": [[Account shared]getStudentLongID]};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *secret = jsonString;
        NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
        NSDictionary *parameters = @{@"ec":data};

        NSURL *URL = [NSURL URLWithString:BaseURL];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

        [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"json%@",json);
            //1
            if([json[@"state"] isEqualToString:@"1"]){
                id arr = json[@"ret"];
                NSString* time = arr[@"Time"];
                NSString* reason = arr[@"Reason"];
                NSString* Untildate = arr [@"UntilDate"];
                NSString* studentID = arr[@"studentID"];
                Alert *alert = [[Alert alloc] initWithTitle:NSLocalizedString(@"已被封禁","") message:[NSString stringWithFormat:@"%@已被封禁 原因%@,封禁时间%@,截止时间%@,请联系管理员获得更多情况",studentID,reason,time,Untildate]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定","")
                                          otherButtonTitles:nil];
                [alert setCancelBlock:^(Alert *alertView) {
                    UIWindow *window = [UIApplication sharedApplication].delegate.window;
                    [UIView animateWithDuration:0.4f animations:^{
                        window.alpha = 0;
                    } completion:^(BOOL finished) {
                        exit(0);
                    }];
                }];
                [alert show];

            }
            else{


            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {

        }];

    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:@"https://must.plus/xmas.html"];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:
                                          ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                              NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              if ([s length] == 1){
                                                  BOOL flag = [[NSUserDefaults standardUserDefaults]boolForKey:@"Xmas"];
                                                  if (flag)
                                                      return;

                                                  if ([[UIApplication sharedApplication] supportsAlternateIcons]) {
                                                                      [[UIApplication sharedApplication] setAlternateIconName:@"Xmas" completionHandler:^(NSError * _Nullable error) {

                                                                          if (error) {
                                                                              NSLog(@"更换app图标发生错误了 ： %@",error);
                                                                          } else {
                                                                               [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Xmas"];
                                                                          }
                                                                      }];
                                                  }

                                              } else {
                                                  BOOL flag = [[NSUserDefaults standardUserDefaults]boolForKey:@"Xmas"];
                                                  if (!flag)
                                                      return;
                                                  if ([[UIApplication sharedApplication] supportsAlternateIcons]) {
                                                      [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                                                          [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"xmas"];
                                                          if (error) {
                                                              NSLog(@"更换app图标发生错误了 ： %@",error);
                                                          } else {
                                                               [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Xmas"];
                                                          }
                                                      }];
                                                  }


                                              }

                                          }];
        [dataTask resume];
//        [manager GET:@"https://must.plus/xmas.html" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject){
//            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            if ([[UIApplication sharedApplication] supportsAlternateIcons]) {
//                [[UIApplication sharedApplication] setAlternateIconName:@"Xmas" completionHandler:^(NSError * _Nullable error) {
//                    if (error) {
//                        NSLog(@"更换app图标发生错误了 ： %@",error);
//                    }
//                }];
//            }
//        } failure:^(NSURLSessionTask *operation, NSError *error) {
//            [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
//                if (error) {
//                    NSLog(@"更换app图标发生错误了 ： %@",error);
//                }
//            }];
//        }];

    });


    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSString *decode = [semester AES256_Decrypt:[HeiHei toeknNew_key]];
        decode =[decode stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\"" ];
        NSData *data = [decode dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //CirnoLog(@"接收到的学期为%@ %@ %@",json,data,decode);
//CirnoLog(@"JSON:%@",json);
        @try {
            float ver = [json[@"lastestversion"]floatValue];
            id type = [NSBundle.mainBundle infoDictionary][@"CFBundleShortVersionString"];
            if ([type respondsToSelector:@selector(floatValue)]) {
                if (ver > [type floatValue]){
                    if ([json[@"forceupdate"] isEqual:@"yes"]){
                        Alert* alert = [[Alert alloc]initWithTitle:[NSString stringWithFormat:@"紧急版本更新 %@",json[@"lastestversion"]] message:json[@"updatelog"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即升级", nil];
                        [alert setClickBlock:^(Alert *alertView,NSInteger d) {
                            UIWindow *window = [UIApplication sharedApplication].delegate.window;

                            [UIView animateWithDuration:0.4f animations:^{
                                window.alpha = 0;
                            } completion:^(BOOL finished) {
                                exit(0);
                            }];
                        }];
                        [alert show];
                    } else {
                        Alert* alert = [[Alert alloc]initWithTitle:[NSString stringWithFormat:@"紧急版本更新 %@",json[@"lastestversion"]] message:json[@"updatelog"] delegate:self cancelButtonTitle:NSLocalizedString(@"取消","") otherButtonTitles:@"立即升级", nil];
                        [alert show];
                    }
                }
            }
        } @catch (NSException *exception) {

        } @finally {

        }

    });

    //初始化根控制器
    self.navigationItem.title = NSLocalizedString(@"课程表", "");
    self.tabBarItem.title = NSLocalizedString(@"课程表", "");
    self.title = NSLocalizedString(@"课程表", "");
    _head = [[SchoolTimeTableHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, StatusBarAndNavigationBarHeight)];
    NSString *weekstr = @"假期";
    NSInteger week = [self nowSemesterWeek];
    if (week!=-1) weekstr = [NSString stringWithFormat:@"第%ld周",week];
    [_head drawHeadViewWithTtile:NSLocalizedString(@"课程表", "") buttonImage:@"more"
                        subTitle:[NSString stringWithFormat:@"%@%@ %@",self.Semester,NSLocalizedString(@"学期", ""),weekstr]];
    //下面这个delegate一定要声明是谁        执行方法，一般都是self，一定要写！
    _head.headButtonDelegate = self;
    //[self.navigationController.navigationBar addSubview:_head];
    [self.view addSubview:_head];
    _weeekTitle = [[NewWeekTitleView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Width, 30)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMdd"];


    [_weeekTitle drawTitleWithDate:[formatter stringFromDate:[NSDate date]]];
    //_weeekTitle.backgroundColor = navigationTabColor;
    [self.view addSubview:_weeekTitle];
    _timeview = [[NewTimeView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+_weeekTitle.size.height, _weeekTitle.MonthView.size.width, Height-StatusBarAndNavigationBarHeight-_weeekTitle.size.height-TabbarHeight)];
    [_timeview drawLeftTime];
    [self.view addSubview:_timeview];

    classArray = [[NSMutableArray alloc] init];
    schoolClassManager = [[SchoolClassCoreDataManager alloc] init];
    _classView = [[NewClassView alloc]initWithFrame:CGRectMake(_timeview.size.width, StatusBarAndNavigationBarHeight+_weeekTitle.size.height, Width-_timeview.size.width, Height-StatusBarAndNavigationBarHeight-_weeekTitle.size.height-TabbarHeight)];
    [self.view addSubview:_classView];
    classArray = [schoolClassManager selectData:0 andOffset:0];
//    
    if([classArray count] == 0){
        [self getClassInfo];
    }
    else{
        //添加课程
        [self saveDataFromServer];
    }

    [self setTarBar];
    [_head bringSubviewToFront:_head.tableView];
    [self.view bringSubviewToFront:_head];
}

-(void) setTarBar{
    NSString* studid = [[Account shared]getStudentLongID];

    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"课程表", @"")];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"资讯", @"")];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"校友圈", @"")];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setTitle:NSLocalizedString(@"小纸条", @"")];
    [[self.tabBarController.tabBar.items objectAtIndex:4] setTitle:NSLocalizedString(@"校园", @"")];

    if ([studid isEqual:@"1409853D-I011-0107"]){
        [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"学神圈", @"")];
    }

}


///////////////////////////////////////////////////////


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* page = @"TimeTable";
    [MTA trackPageViewBegin:page];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


-(void)selectWeek:(NSInteger)week{
    WeekTool* wt = [self wt];
    NSDate* d = [wt WeekDateAt:(int)week+1 On:1];
    [self changeWeek:d];
}



-(void)changeWeek:(NSDate*)date{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    [self.classView removeAllSubviews];
    [self.weeekTitle removeAllSubviews];
    for(MyClass *class in classArray){
        SchoolClassModel *schoolClass = [[SchoolClassModel alloc] init];
        [schoolClass setSchoolClassInfoData:class.class_Room class_Week:class.class_Week class_Number:class.class_Number class_StartTime:class.class_StartTime class_Name:class.class_Name class_StartMonth:class.class_StartMonth class_EndMonth:class.class_EndMonth class_EndTime:class.class_EndTime class_No:class.class_No class_Teacher:class.class_Teacher];

        [array addObject:schoolClass];
    }

    array = [TimetableLogic CheckClassInMonth:array WithDate:date];


    ButtonArr = [[NSMutableArray alloc] init];

    for(SchoolClassModel *eachArray in array){
        ClassButton *button = [[ClassButton alloc] init];
        button.schoolClassClickDelegate= self;
        
        NSUInteger len = arc4random()%[_colorArray count];

        [button drawClassButton:eachArray backGroudColor:
         _colorArray[len]];
        button.alpha=0.85f;

        [ButtonArr addObject:button];
    }
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    [self.weeekTitle drawTitleWithDate:[formatter stringFromDate:
                                        [formatter1 dateFromString:[formatter1 stringFromDate:date]]
                                        ]
                        ];
    [self.classView addClassesInScrollView:ButtonArr];
}
//传递数据
-(void) saveDataFromServer{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    for(MyClass *class in classArray){
        SchoolClassModel *schoolClass = [[SchoolClassModel alloc] init];
        [schoolClass setSchoolClassInfoData:class.class_Room class_Week:class.class_Week class_Number:class.class_Number class_StartTime:class.class_StartTime class_Name:class.class_Name class_StartMonth:class.class_StartMonth class_EndMonth:class.class_EndMonth class_EndTime:class.class_EndTime class_No:class.class_No class_Teacher:class.class_Teacher];
        
        [array addObject:schoolClass];
    }
    
    array = [TimetableLogic CheckClassInMonth:array];
    
    
    ButtonArr = [[NSMutableArray alloc] init];
    
    for(SchoolClassModel *eachArray in array){
        ClassButton *button = [[ClassButton alloc] init];
        button.schoolClassClickDelegate= self;
        NSUInteger len = arc4random()%[_colorArray count];

        [button drawClassButton:eachArray backGroudColor:
         _colorArray[len]];
        button.alpha=0.85f;

        [ButtonArr addObject:button];
    }
    
    //传进SchoolClassScrollView里
    [self.classView addClassesInScrollView:ButtonArr];
}



//======背景方法=============


//滑动事件delegate
-(void)scroll:(UIScrollView *)scrollView
{
    [_time setContentOffset:CGPointMake(0,scrollView.contentOffset.y)];
    //    _backgroudView.frame = CGRectMake(0, -scrollView.contentOffset.y , self.view.frame.size.width, self.view.frame.size.height);
}

-(void)ClickFace:(id)button{
    [self attendance];
}

//右边ADD加键点击事件delegate
-(void) ClickAdd:(id)button{
    NSArray *itemArr = [[NSArray alloc]init];
    //扫一扫 [UIImage imageNamed:@"ScanQRCodeAction"]
    //同步课表 [UIImage imageNamed:@"SyncTimeTable"]
    //我就是新世界的神 [UIImage imageNamed:@"fox"]
    KxMenuItem *item1 = [KxMenuItem menuItem:NSLocalizedString(@"扫一扫", "") image:[UIImage imageNamed:@"ScanQRCodeAction"] target:self action:@selector(click:)];
    KxMenuItem *item2 = [KxMenuItem menuItem:NSLocalizedString(@"同步课表", "") image:[UIImage imageNamed:@"SyncTimeTable"] target:self action:@selector(click:)];
    KxMenuItem * item3 =[KxMenuItem menuItem:NSLocalizedString(@"添加到日历", "") image:[UIImage imageNamed:@"toolbar-add"] target:self action:@selector(click:)];
    KxMenuItem * item4 =[KxMenuItem menuItem:NSLocalizedString(@"选择其他周", "") image:[UIImage imageNamed:@"toolbar-changeweek"] target:self action:@selector(click:)];
//    KxMenuItem * item5 =[KxMenuItem menuItem:NSLocalizedString(@"签到", "") image:[UIImage imageNamed:@"toolbar-sign"] target:self action:@selector(click:)];
//#if defined(DEBUG)||defined(_DEBUG)
//    KxMenuItem *item4 = [KxMenuItem menuItem:@"我就是新世界的神" image:[UIImage imageNamed:@"fox"] target:self action:@selector(click:)];
//#endif
    itemArr = [[NSArray alloc]initWithObjects:item1,item2,item3,item4,nil];
 //   itemArr = [[NSArray alloc]initWithObjects:item1,item2,item3,item4,item5,nil];
//#if defined(DEBUG)||defined(_DEBUG)
  //  itemArr = [[NSArray alloc] initWithObjects:item1,item2,nil];


    [KxMenu setTitleFont:[UIFont systemFontOfSize:15.0]];
    OptionalConfiguration a;
    Color b;
    b.B = 241.0f/255;
    b.G = 167.0f/255;
    b.R = 95.0f/255;
    Color c;
    c.R = c.B =c.G = 1;

    a.maskToBackground = true;
    a.arrowSize = 9;  //指示箭头大小
    a.marginXSpacing=7;  //MenuItem左右边距
    a.marginYSpacing=9;  //MenuItem上下边距
    a.intervalSpacing=25;  //MenuItemImage与MenuItemTitle的间距
    a.menuCornerRadius=6.5;  //菜单圆角半径
    a.maskToBackground=true;  //是否添加覆盖在原View上的半透明遮罩
    a.shadowOfMenu=false;  //是否添加菜单阴影
    a.hasSeperatorLine=true;  //是否设置分割线
    a.seperatorLineHasInsets=false;  //是否在分割线两侧留下Insets
    a.textColor = c;//menuItem字体颜色
    a.menuBackgroundColor = b;//菜单的底色
     UIButton *clickButton = (UIButton *)button;
    [KxMenu showMenuInView:self.view fromRect:clickButton.frame menuItems:itemArr withOptions:a];
}
-(NSString*)fuckthedate:(NSString*)date{
    date=[date stringByReplacingOccurrencesOfString:@"十二" withString:@"12"];
    date=[date stringByReplacingOccurrencesOfString:@"十一" withString:@"11"];
    date=[date stringByReplacingOccurrencesOfString:@"十" withString:@"10"];
    date=[date stringByReplacingOccurrencesOfString:@"一" withString:@"01"];
    date=[date stringByReplacingOccurrencesOfString:@"二" withString:@"02"];
    date=[date stringByReplacingOccurrencesOfString:@"三" withString:@"03"];
    date=[date stringByReplacingOccurrencesOfString:@"四" withString:@"04"];
    date=[date stringByReplacingOccurrencesOfString:@"五" withString:@"05"];
    date=[date stringByReplacingOccurrencesOfString:@"六" withString:@"06"];
    date=[date stringByReplacingOccurrencesOfString:@"七" withString:@"07"];
    date=[date stringByReplacingOccurrencesOfString:@"八" withString:@"08"];
    date=[date stringByReplacingOccurrencesOfString:@"九" withString:@"09"];



    return date;
}
//点击课程事件
-(void)schoolButtonDidClick:(id)button{
    ClassButton *a = (ClassButton *)button;
    SchoolClassModel* class = a.schoolClass;
    ClassTool * tool = [[ClassTool alloc]init];
    Course* tmp = [tool searchCode:class.class_Number][0];
    CourseDetailViewController *cdvc = [[CourseDetailViewController alloc]init];
    cdvc.course = tmp;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M月d"];
    NSDate * tmp1 =[formatter dateFromString:[self fuckthedate:class.class_StartMonth]];
    NSDate * tmp2 =[formatter dateFromString:[self fuckthedate:class.class_EndMonth]];
    NSString*locale = [NSDateFormatter dateFormatFromTemplate:@"dMMM" options:0 locale:formatter.locale];

    formatter.dateFormat = locale;
    NSString* start = [formatter stringFromDate:tmp1];
    NSString* end = [formatter stringFromDate:tmp2];
    [formatter setDateFormat:@"hh:mm"];
    cdvc.DateAndTime = [NSString stringWithFormat:@"%@~%@ %@~%@",start,end,class.class_StartTime,class.class_EndTime];
    cdvc.Room = class.class_Room;
    cdvc.Class = class.class_No;
    cdvc.isBack =YES;
    cdvc.teachers =  [[NSMutableArray alloc]initWithObjects:class.class_Teacher, nil];
    cdvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:cdvc];
    [self presentViewController:nc animated:YES completion:^{
    }];

}

//点击more按钮事件
-(void)click:(KxMenuItem *)item{
    if([item.title isEqualToString:NSLocalizedString(@"扫一扫", "")]){
        SubLBXScanViewController *controller = [[SubLBXScanViewController alloc] init];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else if([item.title isEqualToString:NSLocalizedString(@"同步课表", "")]){
        [self refreshTimetable];
    } else if ([item.title isEqualToString:@"我就是新世界的神"]){
        #if defined(DEBUG)||defined(_DEBUG)
      //  [[FLEXManager sharedManager] showExplorer];
    #endif

    } else if ([item.title isEqualToString:NSLocalizedString(@"添加到日历", "")]){
        [self AddtoCalendar];
    } else if ([item.title isEqualToString:NSLocalizedString(@"选择其他周", "") ]){
        [self ChangeAnotherWeek];
    }
    //else if ([item.title isEqualToString:NSLocalizedString(@"签到", "") ]){
    //   [self attendance];
    //}
}
-(void)attendance{

    AttendanceViewController* avc = [[AttendanceViewController alloc]init];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:avc];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    
}
-(void)ChangeAnotherWeek{

    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:[NSString stringWithFormat:@"%@学期 - 选择周",self.Semester] cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.headerTitleFont = [UIFont systemFontOfSize: 25];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = NO;
    [picker show];
}
#pragma mark datasource
- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row{

    WeekTool * weektool = [self wt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd"];
    NSString* str = [NSString stringWithFormat:@"第%ld周(%@-%@)",
                     row+1,
                     [formatter stringFromDate:[weektool WeekDateAt:(int)row+1 On:1]],
                     [formatter stringFromDate:[weektool WeekDateAt:(int)row+1 On:7]]];
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:str
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
                                            }];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{

//    NSString* str = [NSString stringWithFormat:@"第%ld周(%@-%@)",(long)row,[weektool WeekDateAt:(int)row On:1],[weektool WeekDateAt:(int)row On:7]];
//

    return @"str";
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView {
    WeekTool * weektool = [self wt];
    return [weektool weeks];
}


- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row {
    [self.navigationController setNavigationBarHidden:YES];
    [self selectWeek:row];
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows {

}
#pragma mark delegateCzpicker
#pragma mark events


#pragma mark - 弹出视图消失或者选择了相应delegate



#pragma mark - 拿到课程信息
-(void) getClassInfo{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = NSLocalizedString(@"Loading", "");
    [HUD showInView:self.view];
    
 //   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1008",
                        @"password":[[Account shared]getPassword],
                        @"studentID":[[Account shared]getStudentLongID]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    
    //NSLog(@"%@",[data AES256_Decrypt:[HeiHei toeknNew_key]]);
    
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        @try {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self handleJson:json];
        }
        @catch (NSException *exception) {
            CirnoLog(@"捕捉异常：%@,%@",exception.name,exception.reason);
            [_scroll addClassesInScrollView:ButtonArr];
        }
        @finally {
            [HUD dismiss];
        }
        
        

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
       // [alert show];
        [HUD dismiss];
    }];
}

#pragma mark - 处理课程信息
-(void) handleJson:(id)json{
    CirnoLog(@"json is %@",json);
    NSMutableArray *array = json[@"class"];
    NSMutableArray *insertArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array){
        NSString *startMonth = [[dic[@"classMonth"] substringToIndex:5] stringByReplacingOccurrencesOfString:@"'" withString:@""];
       // NSLog(@"now is %@",startMonth);
        NSString *endMonth = [[dic[@"classMonth"] substringFromIndex:15] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *className = [dic[@"className"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *classRoom = [dic[@"classRoom"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *classEndTime = [dic[@"classEndTime"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *classNo = [dic[@"classNo"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *classTeacher = [dic[@"classTeacher"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *classWeek = [dic[@"classWeek"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *classStartTime = [dic[@"classStartTime"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *classNumber = [dic[@"classNumber"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSMutableDictionary *b = [[NSMutableDictionary alloc] init];
        [b setValue:startMonth forKey:@"class_StartMonth"];
        [b setValue:endMonth forKey:@"class_EndMonth"];
        [b setValue:className forKey:@"class_Name"];
        [b setValue:classRoom forKey:@"class_Room"];
        [b setValue:classEndTime forKey:@"class_EndTime"];
        [b setValue:classNo forKey:@"class_No"];
        [b setValue:classTeacher forKey:@"class_Teacher"];
        [b setValue:classWeek forKey:@"class_Week"];
        [b setValue:classStartTime forKey:@"class_StartTime"];
        [b setValue:classNumber forKey:@"class_Number"];
        [insertArray addObject:b];
    }
    [schoolClassManager insertCoreData:insertArray];
    classArray = [schoolClassManager selectData:0 andOffset:0];
    
    [self saveDataFromServer];
}
-(NSInteger)nowSemesterWeek{
    WeekTool * weektool = [[WeekTool alloc]init];
    [weektool setStartDate:[self.sDate objectForKey:self.Semester]];
    [weektool setEndDate:[self.eDate objectForKey:self.Semester]];
    weektool.semester = self.Semester;
    NSInteger result = [weektool WeekForDate:[NSDate date]];
    if ((result>0) && (result<=[weektool weeks])){
        return result;
    } else
        return -1;
}
#pragma mark - 刷新课表
-(void) refreshTimetable{
    classArray = [[NSMutableArray alloc] init];
    [schoolClassManager deleteData];
    [_classView removeAllSubviews];
    [_weeekTitle removeAllSubviews];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMdd"];
    [_weeekTitle drawTitleWithDate:[formatter stringFromDate:[NSDate date]]];
    _scroll.week = [self getWeek];
    [_scroll addLine];
    [self getClassInfo];
}

-(void)ClickWhichWeek:(int)Which{
    [_scroll removeAllSubviews];
    [_scroll addLine];
    _scroll.week = Which;
    [_scroll addClassesInScrollView:ButtonArr];
}
-(void)didSelectMenuItem:(NSString *)string{
    NSLog(@"%@",string);
}
-(int) getWeek{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    int weekday = (int)[comps weekday];
    if(weekday == 1){
        weekday = 6;
    }
    else if(weekday == 7){
        weekday = 5;
    }
    else{
        weekday = weekday - 2;
    }
    return weekday;
}


-(void)RongCloudLogin:(NSString*)token{
    [[RCIM sharedRCIM] initWithAppKey:@"z3v5yqkbz6ob0"];
    //  [[RCIM sharedRCIM] initWithAppKey:@"lmxuhwaglz8gd"];

    [[RCIM sharedRCIM] connectWithToken:token
                                success:^(NSString *userId) {
                                    NSLog(@"登录成功！");
                                } error:^(RCConnectErrorCode status) {
                                    [CirnoError ShowErrorWithText:[NSString stringWithFormat:@"小纸条登录失败！错误码为:%ld",(long)status]];
                                } tokenIncorrect:^{

                                    [CirnoError ShowErrorWithText:@"小纸条登录失败！Token错误"];

                                }];
    [[RCIM sharedRCIM]setUserInfoDataSource:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [[RCIM sharedRCIM] setGroupInfoDataSource:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [[RCIM sharedRCIM]setGroupUserInfoDataSource:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [[RCIM sharedRCIM]setGroupMemberDataSource:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [RCIM sharedRCIM].enablePersistentUserInfoCache=YES;
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [[RCIM sharedRCIM]setEnableMessageMentioned:YES];
    

}
-(void)chekcNotification{
    NSString* check = [[Account shared]getLoginStatus];
    if (TARGET_IPHONE_SIMULATOR)
        return;
    if (![check isEqual:@"1"]){
        return;
    }
    NSInteger status = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    if (status == 0){
        NSInteger a = arc4random()%100;
        if (a>78){
            if ([[UIDevice currentDevice] systemVersion].floatValue<11){
            Alert * alert = [[Alert alloc]initWithTitle:@"提示" message:@"推送未开启，请开启推送以获取最新消息。"
                                               delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];

            [alert setCancelBlock:^(Alert* alert){
                NSString * identifier = [NSBundle mainBundle].bundleIdentifier;
                NSString * str = [NSString stringWithFormat:@"App-Prefs:root=NOTIFICATIONS_ID&path=%@",identifier];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
                [alert show];
            } else {
            UIAlertController* a = [UIAlertController alertControllerWithTitle:@"提示" message:@"推送未开启，请开启推送以获取最新消息。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    NSString * identifier = [NSBundle mainBundle].bundleIdentifier;
                    NSString * str = [NSString stringWithFormat:@"App-Prefs:root=NOTIFICATIONS_ID&path=%@",identifier];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
            [a addAction:ac];
            [self presentViewController:a animated:YES completion:nil];
            }

        }
    } else {
        NSString *GradeType = [[[Account shared]getGradeType] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        NSString *MajorType = [[Account shared]getMajorType];
        NSString *vip = [NSString stringWithFormat:@"vip%@",[[Account shared]getVip]];
        NSSet* tags = [NSSet alloc];
        tags = [NSSet setWithObjects:GradeType,MajorType,vip,nil];
        NSString *alia =  [[Account shared] getStudentShortID] ;

        [JPUSHService setTags:tags alias:alia fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSString* vip = [NSString stringWithFormat:@"%@",[[Account shared]getVip]];
            if (![vip isEqualToString:@"1"]){
                NSString *mess =[[NSString alloc]initWithFormat:@"返回代码%d,tags%@,别名%@",iResCode,tags,iAlias];
                 NSLog(@"%@",mess);
            } else {
                if (iResCode==0){

                    NSString *mess =[[NSString alloc]initWithFormat:NSLocalizedString(@"注册成功", "")];
                    NSLog(@"%@",mess);
                } else {
                    NSString *mess =[[NSString alloc]initWithFormat:@"%@%d",NSLocalizedString(@"注册失败", ""),iResCode];
                    NSLog(@"%@",mess);
                }

            }

        }];

    }
}


-(void)getRongCloudToken{
    [RCIM sharedRCIM].receiveMessageDelegate = self;

    NSDictionary *o1 =@{@"ec":@"9987",
                        @"studentID": [[Account shared]getStudentLongID]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        result = [result stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [self RongCloudLogin:result];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:error.localizedDescription];
    }];
}

-(void)onRCIMMessageRecalled:(long)messageId{
    NSLog(@"%ld",messageId);
}
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 3;//自动跳转到消息窗口

    });

}
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName{
    NSLog(@"%@",message);
    NSLog(@"%@",senderName);
    [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:@""];
    return NO;
}
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message{
    NSLog(@"%@",message);
     dispatch_sync(dispatch_get_main_queue(), ^{
         UITabBarItem* item =[self.tabBarController.tabBar.items objectAtIndex:3];
          [item setBadgeValue:@" "];
     });
    return NO;
}
@end

#pragma clang diagnostic pop
