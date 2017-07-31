//
//  GradeController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/7/31.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "GradeController.h"
#import "HeiHei.h"
#import "NSString+AES.h"
@interface GradeController ()

@end

@implementation GradeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"成绩";
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    NSError *error;
    NSDictionary *o1 =@{@"ec":@"9988",
                        @"studentID": [[Account shared]getStudentLongID],
                        @"password":[[Account shared]getPassword],
                        @"semester":@"1702"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data1 = [secret AES256_Encrypt:[HeiHei toeknNew_key]];

    NSString *postStr = [NSString stringWithFormat:@"ec=%@",data1];


    NSData *data = [postStr dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:BaseURL]];

    [request setHTTPMethod: @"POST"];

    [request setHTTPBody: data];

    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden =YES;
}

@end
