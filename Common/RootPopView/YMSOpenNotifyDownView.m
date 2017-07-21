//
//  YMSOpenNotifyDownView.m
//  yimashuo
//
//  Created by imqiuhang on 15/12/18.
//  Copyright © 2015年 imqiuhang. All rights reserved.
//

#import "YMSOpenNotifyDownView.h"
#import "CirnoError.h"
#import "BasicHead.h"

@implementation YMSOpenNotifyDownView{
    UITableView *classTableView;
//    NSString *ftp;
//    NSString *content;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    if (row == 0) {

    }
    else if (row == 1){
        
    }
}
- (void)prepareForContentSubView {
//    ftp = @"信息还在外太空";
//    content = @"信息还在外太空";
    contentView.backgroundColor = [UIColor whiteColor];
    
    classTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,260,308) style:UITableViewStylePlain];
    classTableView.delegate = self;
    classTableView.dataSource = self;
    
    UIView *footerView  = [[UIView alloc] init];
    classTableView.tableFooterView = footerView;
    
    [contentView addSubview:classTableView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 308 + 9, contentView.width - 40, 40)];
    [btn setTitle:NSLocalizedString(@"OK", "") andFont:defaultFont(16) andTitleColor:[UIColor whiteColor] andBgColor:YMSBrandColor andRadius:5];
    [contentView addSubview:btn];
    [btn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"CellIdentifier";//以indexPath来唯一确定cell
    NSLog(@"%@",_schoolClass.class_Number);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:CellIdentifier];
            }

    
    if(indexPath.row == 0){
        cell.textLabel.text = NSLocalizedString(@"教师", "");

        cell.detailTextLabel.text = _schoolClass.class_Teacher;
    }
    else if(indexPath.row == 1){
        cell.textLabel.text = NSLocalizedString(@"课程", "");
        cell.detailTextLabel.text = _schoolClass.class_Name;
    }
    else if(indexPath.row == 2){
        cell.textLabel.text = NSLocalizedString(@"教室", "");
        cell.detailTextLabel.text = _schoolClass.class_Room;
    }
    else if(indexPath.row == 3){
        cell.textLabel.text = NSLocalizedString(@"上课时间", "");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@~%@",_schoolClass.class_StartMonth,_schoolClass.class_EndMonth];
    }


    cell.selectionStyle = NO;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}


#pragma mark - 拿到课程信息
-(void) getClassInfo{
    // TODO 等写好了再说吧
// 
//    //数据流加密
//    NSDictionary *o1 =@{@"ec":@"1014",
//                        @"ClassID":_schoolClass.class_Number};
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSString *secret = jsonString;
//    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
//    
//    NSLog(@"%@",[data AES256_Decrypt:[HeiHei toeknNew_key]]);
//    
//    //POST数据
//    NSDictionary *parameters = @{@"ec":data};
//    
//    NSURL *URL = [NSURL URLWithString:BaseURL];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    //转成最原始的data,一定要加
//    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
//    
//    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
//        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
//        
//        
//        @try {
//            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            [self handle:json];
//            CirnoLog(@"%@",result);
//        }
//        @catch (NSException *exception) {
//            CirnoLog(@"捕捉异常：%@,%@",exception.name,exception.reason);
//        }
//        @finally {
//
//        }
//
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        [CirnoError ShowErrorWithText:[error localizedDescription]];
//    }];
}

-(void) handle:(id) json{
//    ftp = [json[@"classcontent"][@"ftp"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
//    content = [json[@"classcontent"][@"content"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
    [classTableView reloadData];
}

@end
