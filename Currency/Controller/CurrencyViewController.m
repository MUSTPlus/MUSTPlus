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
#import "UIImage+CYButtonIcon.h"
@interface CurrencyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray<CurrencyTableViewCell *> *displayingArray;
@property (nonatomic) int selected;
@property (nonatomic) float basePrice;
@property (nonatomic,strong) UIButton* backbutton;
@end

@implementation CurrencyViewController
-(void)back1{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSString *)str:(NSString *)str value1:(NSString *)value1 value2:(NSString *)value2{
    int i=0;
    int j=0;
    NSRange range1 = [str rangeOfString:value1];
    if(range1.length>0){
        NSString *result1 = NSStringFromRange(range1);
        i = [self indexByValue:result1];
        i = i+(int)[value1 length];
    }
    NSString *str1 = [str substringFromIndex:i];
    NSRange range2 = [str1 rangeOfString:value2];
    if(range2.length>0){
        NSString *result2 = NSStringFromRange(range2);
        j = [self indexByValue:result2];
    }
    NSString *str2 = [str1 substringToIndex:j];
    return str2;
}

-(int)indexByValue:(NSString *)str{
    NSMutableString *value = [[NSMutableString alloc] initWithFormat:@""];
    NSString *colum2 = @"";
    int j = 0;
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
-(void)downloadData{
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
        [self updateData];
        _basePrice = 1 / _basePrice;
    } failure:^(NSURLSessionTask *operation, NSError *error) {


    }];


}
-(void)updateData{

    CurrencyTableViewCell *cell1 =[[CurrencyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 90)];
    cell1=[cell1 initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:@"cell"
                         price:1.0f
                          name:@"CNY"
                          desc:NSLocalizedString(@"人民币","")
                          icon:@"CNY"];

    CurrencyTableViewCell *cell2 =[[CurrencyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 90)];
    cell2=[cell2 initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:@"cell"
                         price:_basePrice*1.03
                          name:@"MOP"
                          desc:NSLocalizedString(@"澳门币","")
                          icon:@"MOP"];
    CurrencyTableViewCell *cell3 =[[CurrencyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 90)];
    cell3=[cell3 initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:@"cell"
                         price:_basePrice
                          name:@"HKD"
                          desc:NSLocalizedString(@"港币","")
                          icon:@"HKD"];
    cell1.selectionStyle=UITableViewCellSelectionStyleNone;
    cell2.selectionStyle=UITableViewCellSelectionStyleNone;
    cell3.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell1.textField addTarget:self action:@selector(changed:) forControlEvents:UIControlEventEditingChanged];
    [cell2.textField addTarget:self action:@selector(changed:) forControlEvents:UIControlEventEditingChanged];
    [cell3.textField addTarget:self action:@selector(changed:) forControlEvents:UIControlEventEditingChanged];
    _displayingArray = [[NSMutableArray
                         alloc]initWithObjects:cell1,cell2,cell3, nil];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selected = 0;
    _backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, NavBarHeight-StatusBarHeight)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrice) name:@"DataDone" object:nil];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor blackColor];
//    [_backbutton setImage:[UIImage imageNamed:@"story_back" ]forState:UIControlStateNormal];
//    [_backbutton setImage:[UIImage imageNamed:@"story_back_pres"] forState:UIControlStateSelected];
    [_backbutton setTitle:UIKitLocalizedString(@"Done") forState:UIControlStateNormal];
    [_backbutton addTarget:self action:@selector(back1) forControlEvents:UIControlEventTouchDown];
    if (_dontShowBack==0)
    [self.navigationController.navigationBar addSubview:_backbutton];
    self.navigationItem.title = NSLocalizedString(@"汇率", "");
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:_tableView];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _tableView.tableFooterView = footerView;
    
    _basePrice = 0.01f;
    [self updateData];
    [self downloadData];


}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
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
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
        [self boomShakalaka:textField];
    }
    float baseNumber = [textField.text floatValue] / [textField.placeholder floatValue];
    [self updateAll:baseNumber name:textField.placeholder];
}
- (void)boomShakalaka:(UIView *) view

{
    static int numberOfShakes = 4;
    // 晃动幅度（相对于总宽度）
    static float vigourOfShake = 0.04f;
    // 晃动延续时常（秒）
    static float durationOfShake = 0.5f;

    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 方法二：关键帧（点）
    CGPoint layerPosition = view.layer.position;

    // 起始点
    NSValue *value1=[NSValue valueWithCGPoint:view.layer.position];
    // 关键点数组
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:value1, nil];
    for (int i = 0; i<numberOfShakes; i++) {
        // 左右晃动的点
        NSValue *valueLeft = [NSValue valueWithCGPoint:CGPointMake(layerPosition.x-view.frame.size.width*vigourOfShake*(1-(float)i/numberOfShakes), layerPosition.y)];
        NSValue *valueRight = [NSValue valueWithCGPoint:CGPointMake(layerPosition.x+view.frame.size.width*vigourOfShake*(1-(float)i/numberOfShakes), layerPosition.y)];

        [values addObject:valueLeft];
        [values addObject:valueRight];
    }
    // 最后回归到起始点
    [values addObject:value1];

    shakeAnimation.values = values;
    shakeAnimation.duration = durationOfShake;

    [view.layer addAnimation:shakeAnimation forKey:kCATransition];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

@end
