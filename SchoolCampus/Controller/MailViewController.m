//
//  MailViewController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/11/30.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "MailViewController.h"
#import "BasicHead.h"
@interface MailViewController ()

@end

@implementation MailViewController
- (void) loadView{
    WKWebViewConfiguration* webConfiguration = [[WKWebViewConfiguration alloc]init];
    self.wkwebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Width, Height-StatusBarAndNavigationBarHeight)configuration:webConfiguration];
    self.wkwebView.UIDelegate = self;
    self.wkwebView.navigationDelegate = self;
    self.view = self.wkwebView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = false;

    self.url = @"https://outlook.office365.com/owa/?realm=student.must.edu.mo";
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:self.url]];
    [self.wkwebView loadRequest:request];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)webView:(WKWebView *)webView
didFinishNavigation:(WKNavigation *)navigation{
    NSString* account = [[Account shared]getStudentShortID];
    NSString* pw = [[Account shared]getPassword];
    NSString* js1 = [NSString stringWithFormat:
                     @"document.getElementById(\"userNameInput\").value=\"%@@student.must.edu.mo\"",account];
    NSString* js2 = [NSString stringWithFormat:@"document.getElementById(\"passwordInput\").value=\"%@\"",pw];
    [webView evaluateJavaScript:js1 completionHandler:^(id item, NSError * _Nullable error) {
    }];
    [webView evaluateJavaScript:js2 completionHandler:^(id item, NSError * _Nullable error) {
    }];
    [webView evaluateJavaScript:@"Login.submitLoginRequest();" completionHandler:^(id item, NSError * _Nullable error) {
    }];
}
@end
