//
//  T-RexRunner.m
//  MUST_Plus
//
//  Created by Cirno on 15/03/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import "T-RexRunner.h"

@interface T_RexRunner ()

@end

@implementation T_RexRunner

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    _webview.scalesPageToFit = NO;
    _webview.multipleTouchEnabled = NO;
    _layerview = [[UIView alloc]initWithFrame:CGRectMake(0, Height-100, Width, 100)];
    _layerview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webview];
    [self.view addSubview:_layerview];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"inDirectory:@"t-rex"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webview loadRequest:request];
    _webview.scrollView.bounces =NO;
    _webview.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _webview.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
