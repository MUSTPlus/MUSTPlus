//
//  SubLBXScanViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/10/6.
//  Copyright © 2016年 zbc. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "SubLBXScanViewController.h"
#import "WSGetWifi.h"
#import "NSString+AES.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "BasicHead.h"

@interface SubLBXScanViewController ()

@end

@implementation SubLBXScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qqStyle];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    [returnButton setTitle:NSLocalizedString(@"返回", "") forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:returnButton];
}

- (void)qqStyle
{
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    self.style = style;

}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if(array.count > 0){
        NSString *string = [array[0].strScanned AES256_Decrypt:[HeiHei toeknNew_key]];
        if([string length] > 0){
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self funAbouQR:json];
        }
        else{
            __weak __typeof(self) weakSelf = self;
            [weakSelf reStartDevice];
        }
    }
    [LBXScanWrapper systemVibrate];
}


-(void) funAbouQR:(id)json{
    NSString *ec = [json objectForKey:@"ec"];
    
    //签到方法
    if([ec  isEqual: @"sign"]){
        [self signFunc:[json objectForKey:@"classID"]];
    }
}



//签到方法
-(void) signFunc:(NSString *) classID{
    NSString *wifiSSID = [WSGetWifi getSSIDInfo][@"SSID"];
    NSLog(@"%@",[NSString stringWithFormat:@"当前连接Wifi名称: %@",wifiSSID]);
    NSLog(@"%@",classID);
    
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1013",
                        @"classID": @"MA001",
                        @"studentID": [[NSUserDefaults standardUserDefaults] valueForKey:@"studentID"],
                        @"device" : [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceID"],
                        @"autokey": wifiSSID};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    
    
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    //差个URL
    [session POST:BaseURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",json);
        [self signSuccess:json[@"state"]];
//        __weak __typeof(self) weakSelf = self;
//        [weakSelf reStartDevice];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
//        __weak __typeof(self) weakSelf = self;
//        [weakSelf reStartDevice];
    }];
    
}


-(void) signSuccess:(NSString *)state{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil];
    
    int stateValue = [state intValue];
    switch (stateValue) {
        case signCantFindClassID:
            [alert setMessage:@"服务器出问题了~"];
            break;
        case signDateBroken:
            [alert setMessage:@"服务器出问题了~"];
            break;
        case signSqlBroken:
            [alert setMessage:@"服务器出问题了~"];
            break;
        case signOutOfTime:
            [alert setMessage:@"签到时间已过"];
            break;
        case signSigned:
            [alert setMessage:@"请勿重复签到"];
            break;
        case signOutSchool:
            [alert setMessage:@"请连上校内wifi签到"];
            break;
        case signDeviceSigned:
            [alert setMessage:@"请不要帮助签到"];
            break;
        case signSuccess:
            [alert setMessage:@"签到成功"];
            break;
        case signTooFast:
            [alert setMessage:@"签到速度太快"];
            break;
        default:
            break;
    }
    [alert show];
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) returnClick{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
#pragma clang diagnostic pop
