//
//  CurrencyViewController.m
//  Currency
//
//  Created by Cirno on 30/12/2016.
//  Copyright © 2016 Umi. All rights reserved.
//

#import "CurrencyViewController.h"
#import "BasicHead.h"
#import "CurrencyTableViewCell.h"
#import "AFNetworking.h"

@interface CurrencyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray<CurrencyTableViewCell *> *displayingArray;
@property (nonatomic) int selected;
@property (nonatomic) float basePrice;
@end

@implementation CurrencyViewController
/*
 作用:截取从value1到value2之间的字符串
 str:要处理的字符串
 value1:左边匹配字符串
 value2:右边匹配字符串
 */
-(NSString *)str:(NSString *)str value1:(NSString *)value1 value2:(NSString *)value2{
    //i:左边匹配字符串在str中的下标
    int i;
    //j:右边匹配字符串在str1中的下标
    int j;
    //该类可以通过value1匹配字符串
    NSRange range1 = [str rangeOfString:value1];
    //判断range1是否匹配到字符串
    if(range1.length>0){
        //把其转换为NSString
        NSString *result1 = NSStringFromRange(range1);
        i = [self indexByValue:result1];
        //原因:加上匹配字符串的长度从而获得正确的下标
        i = i+[value1 length];
    }
    //通过下标，删除下标以前的字符
    NSString *str1 = [str substringFromIndex:i];
    NSRange range2 = [str1 rangeOfString:value2];
    if(range2.length>0){
        NSString *result2 = NSStringFromRange(range2);
        j = [self indexByValue:result2];
    }
    NSString *str2 = [str1 substringToIndex:j];
    return str2;
}

//过滤获得的匹配信息的下标
-(int)indexByValue:(NSString *)str{
    //使用NSMutableString类，它可以实现追加
    NSMutableString *value = [[NSMutableString alloc] initWithFormat:@""];
    NSString *colum2 = @"";
    int j = 0;
    //遍历出下标值
    for(int i=1;i<[str length];i++){
        NSString *colum1 = [str substringFromIndex:i];
        [value appendString:colum2];
        colum2 = [colum1 substringToIndex:1];
        if([colum2 isEqualToString:@","]){
            j = [value intValue];
            break;
        }
    }
    return j;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selected = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrice) name:@"DataDone" object:nil];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = navigationTabColor;
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.navigationItem.title = @"汇率";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:_tableView];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    NSURL *URL = [NSURL URLWithString:@"http://www.kuaiyilicai.com/uprate"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *pageSource = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        _basePrice =
        [
         [
          [self str:pageSource value1:@"<span style=\"font-size:26px;\">汇率:&nbsp;&nbsp;&nbsp;<span style=\"color:Red;\">" value2:@"</span></span>"]
            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]
         ]
            floatValue
        ]
        ;

    } failure:^(NSURLSessionTask *operation, NSError *error) {


    }];
    @try {
        while (_basePrice==0){
            NSLog(@"+1s");
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
        }
    } @catch (NSException *exception) {

    } @finally {

    }

    CurrencyTableViewCell *cell1 =[[CurrencyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 90)];
                                cell1=[cell1 initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:@"cell"
                                                                      price:1.0f
                                                                       name:@"CNY"
                                                                       desc:@"人民币"
                                                                       icon:@"CNY"];

    CurrencyTableViewCell *cell2 =[[CurrencyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 90)];
    cell2=[cell2 initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:@"cell"
                         price:_basePrice*1.03
                          name:@"MOP"
                          desc:@"澳门币"
                          icon:@"MOP"];
    CurrencyTableViewCell *cell3 =[[CurrencyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 90)];
    cell3=[cell3 initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:@"cell"
                         price:_basePrice
                          name:@"HKD"
                          desc:@"港币"
                          icon:@"HKD"];
    cell1.selectionStyle=UITableViewCellSelectionStyleNone;
    cell2.selectionStyle=UITableViewCellSelectionStyleNone;
    cell3.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell1.textField addTarget:self action:@selector(changed:) forControlEvents:UIControlEventEditingChanged];
    [cell2.textField addTarget:self action:@selector(changed:) forControlEvents:UIControlEventEditingChanged];
    [cell3.textField addTarget:self action:@selector(changed:) forControlEvents:UIControlEventEditingChanged];
        _displayingArray = [[NSMutableArray
                             alloc]initWithObjects:cell1,cell2,cell3, nil];


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    _selected = (int)indexPath.row;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSInteger row = indexPath.row;
    return _displayingArray[row];
}
-(void)updateAll:(float)num
           name:(NSString*)name{
    for (int i=0;i<3;i++)
        if ([_displayingArray[i].textField.placeholder isEqual:name]){
        }
            else
        [_displayingArray[i] update:[NSNumber numberWithFloat:num]];
  //  [self updatePrice];
}
-(void)updatePrice{
  //  [_tableView reloadData];
}
-(void)changed:(UITextField *)textField{
    float baseNumber = [textField.text floatValue] / [textField.placeholder floatValue];
    [self updateAll:baseNumber name:textField.placeholder];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

@end
