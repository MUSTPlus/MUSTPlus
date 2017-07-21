//
//  NewsViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/10/8.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController




- (void)viewDidLoad {
    self.url = [NSURL URLWithString:self.ToUrl];
    self.loadingBarTintColor = [UIColor greenColor];
    //上面这两个方法必须在super前，不然无法赋值
    //若要修改navigation的一些颜色，直接去轮子地方改
    
    [super viewDidLoad];
    // Do any additional setup after loading the view
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
