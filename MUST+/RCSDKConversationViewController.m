//
//  RCSDKConversationViewController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/8/17.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "RCSDKConversationViewController.h"

@interface RCSDKConversationViewController ()

@end

@implementation RCSDKConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTapCellPortrait:(NSString *)userId{
    [super didTapCellPortrait:userId];
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    udc.isSelf = NO;
    udc.studID = userId;
    udc.naviGo = YES;
    [self.navigationController pushViewController:udc animated:YES];
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