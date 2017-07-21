//
//  UserChangeDetailsController.m
//  MUST_Plus
//
//  Created by Cirno on 07/12/2016.
//  Copyright © 2016 zbc. All rights reserved.
//
//
//  更改用户详细资料
#import "BasicHead.h"
#import "UserChangeDetailsController.h"
#import "CirnoTextView.h"
#import "Account.h"
#import "AFNetworking.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "CirnoError.h"
#define offset 120
@interface UserChangeDetailsController ()<UITableViewDelegate,UITableViewDataSource,ChangeDelegate,UITextFieldDelegate>{
    
}
@property (nonatomic,strong) UITableView* tableview;
@property (nonatomic,strong) CirnoTextView* nickname;
@property (nonatomic,strong) CirnoTextView* whatsup;
@end

@implementation UserChangeDetailsController
-(void)passValue:(NSString *)str{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"我的资料", "");
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, Width, Height-NavBarHeight) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _nickname = [[CirnoTextView alloc]initWithFrame:CGRectMake(offset, 0, Width-offset, 44)];
    _nickname.placeholder = NSLocalizedString(@"昵称", "");
    _nickname.text = _usrmodel.nickname;
    _whatsup =[[CirnoTextView alloc]initWithFrame:CGRectMake(offset, 0, Width-offset*1.4, 88)];
    _whatsup.placeholder = NSLocalizedString(@"个性签名", "");
    _whatsup.text = _usrmodel.whatsup;
    [_whatsup textViewDidChange:_whatsup];
    
    _myButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", "") style:UIBarButtonItemStylePlain target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = _myButton;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:UITextFieldTextDidChangeNotification object:self.nickname];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:UITextFieldTextDidChangeNotification object:self.whatsup];
    [self.view addSubview:_tableview];
}
-(void)change{
    _myButton.enabled= self.nickname.text.length>0?true:false;

}
-(void) clickEvent{
    if ([_nickname.text length]!=0){
        [self changeName:_nickname.text];
        [self changeSignText:_whatsup.text];
        [self back1];
    } else {
        [CirnoError ShowErrorWithText:NSLocalizedString(@"不能为空", "")];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]init];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"昵称", "");
            [cell addSubview:_nickname];
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"个性签名", "");
            [cell addSubview:_whatsup];
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)back1{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [_nickname resignFirstResponder];
    [_whatsup resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) return 44;
        else return 88;
}


-(void) changeName:(NSString *)name{
    
    NSDictionary *o1 =@{@"ec":@"1028",
                        @"studentID":[[NSUserDefaults standardUserDefaults] valueForKey:@"studentID"],
                        @"name":name};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([json[@"state"] isEqualToString:@"1"]){
            [[Account shared]setNickname:name];
            [self.nickname resignFirstResponder];
        }
        else{
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
    }];
}


-(void) changeSignText:(NSString *)name{
    
    NSDictionary *o1 =@{@"ec":@"1030",
                        @"studentID":[[Account shared] getStudentLongID],
                        @"signText":name};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    
    NSLog(@"%@",data);
    
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([json[@"state"] isEqualToString:@"1"]){
            [[Account shared]setWhatsup:name];
            [self.nickname resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
        self.navigationController.navigationBarHidden=NO;
}


@end
