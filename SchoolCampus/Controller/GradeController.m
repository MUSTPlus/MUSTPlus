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
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-NavigationBarHeight-StatusBarHeight)];
    [self.view addSubview:self.webView];
    NSError *error;
    NSDictionary *o1 =@{@"ec":@"9988",
                        @"studentID": [[Account shared]getStudentLongID],
                        @"password":[[Account shared]getPassword],
                        @"semester":@"0000"};
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
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(more)];
    UIBarButtonItem * t = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(js)];
    self.navigationItem.rightBarButtonItems=@[right,t];
    // Do any additional setup after loading the view.
}
-(void)js{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择操作" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"展开成绩详细" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"show();"];
        NSLog(@"点击取消");
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"缩起成绩详细" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"hide();"];
        NSLog(@"点击确认");
    }]];
    NSString* vip = [[[NSUserDefaults standardUserDefaults] objectForKey:Vip]stringValue];
    if (![vip isEqualToString:@"1"])
    [alertController addAction:[UIAlertAction actionWithTitle:@"神秘按钮" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"display();"];

        NSLog(@"点击警告");
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    

}
-(void)more{
    //UIActivityViewController
    self.webView.frame=CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.scrollView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(self.webView.frame.size, NO, 0.0f);
    [self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    NSArray *activityItems = @[screenshot];
    self.av = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:self.av animated:YES completion:nil];
}
-(void)captureImage:(UIWebView *)webvw
{
    webvw.frame=CGRectMake(webvw.frame.origin.x, webvw.frame.origin.y, webvw.frame.size.width, webvw.scrollView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(webvw.frame.size, NO, 0.0f);
    [webvw.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshot,self,@selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    Alert * alert = [[Alert alloc]initWithTitle:@"保存图片提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.tabBarController.tabBar.hidden =YES;
}

@end
