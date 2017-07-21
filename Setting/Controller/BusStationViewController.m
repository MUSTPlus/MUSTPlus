//
//  BusStationViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/11/12.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "BusStationViewController.h"
#import "BasicHead.h"
@interface BusStationViewController ()

@end

@implementation BusStationViewController{
}

- (void)viewDidLoad {
    if (_baseUrl==nil)
        self.url = [NSURL URLWithString:@"http://202.175.87.15:7012/macauweb/"];
    self.loadingBarTintColor = [UIColor greenColor];
    //上面这两个方法必须在super前，不然无法赋值
    //若要修改navigation的一些颜色，直接去轮子地方改
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
 }






@end
