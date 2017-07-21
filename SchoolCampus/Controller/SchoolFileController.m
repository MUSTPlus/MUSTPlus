//
//  SchoolFileController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/7/4.
//  Copyright © 2017年 zbc. All rights reserved.
//
//
//  校园文件Controller
//

#import "SchoolFileController.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "AFNetworking.h"
#import "BasicHead.h"
#import <MJRefresh.h>
#import <SafariServices/SafariServices.h>
@interface SchoolFileController ()<UIDocumentInteractionControllerDelegate,SFSafariViewControllerDelegate>

@end

@implementation SchoolFileController
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStyleGrouped];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.files = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"校园文件";
    [self.view addSubview:self.tableview];
    [self.tableview.mj_header beginRefreshing];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refresh{
    NSDictionary *o1 =@{@"ec":@"9990"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data!=nil){
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([json[@"state"] isEqualToString:@"1"]){
                //CirnoLog(@"%@",json);
                id re = json[@"ret"];
                [self.files removeAllObjects];
                for (NSDictionary* a in re){
                    SchoolFile* file = [[SchoolFile alloc]initWithDesc:a[@"desc"]
                                                            andUrl:a[@"url"]
                                                     andUpdateTime:[a[@"updatetime"] stringValue ]andType:[a[@"type"] lowercaseString]];
                    [self.files addObject:file];
            }
        }
        }
        else{
            // [HUD dismiss];
        }
        [self.tableview reloadData];
        [self.tableview.mj_header endRefreshing];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
    }];


}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.files count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSInteger row = indexPath.row;
    cell.textLabel.text = self.files[row].desc;
    cell.detailTextLabel.text = self.files[row].updatetime;
    cell.imageView.image = [UIImage imageNamed:self.files[row].type];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    if ([self.files[row].url length]==0){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled =NO;
        cell.alpha = 0.5f;
        cell.detailTextLabel.text = @"不可用";
    }

    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    [self openDocument:self.files[row].url];

}
-(void)openDocument:(NSString*)url{
    SFSafariViewController *new = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:url]];
    new.delegate = self;
    new.view.tintColor = navigationTabColor;
    [self presentViewController:new animated:YES completion:^{
    }];



}

@end
