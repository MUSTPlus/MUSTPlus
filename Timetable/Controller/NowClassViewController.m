//
//  NowClassViewController.m
//  MUSTPlus
//
//  Created by Cirno on 20/04/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import "NowClassViewController.h"
#import "BasicHead.h"
@interface NowClassViewController ()

@end

@implementation NowClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当前进行的课程";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,Width, Height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.myclass = [[NSArray alloc]init];
    self.faculty = (self.faculty==nil)?@"ALL":_faculty;
    [self getClass:self.faculty];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
    self.navigationController.navigationBarHidden=NO;
    [self.tabBarController.tabBar setHidden:YES];

}
-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];

}
-(void)getClass:(NSString*)faculty{
    NSDictionary *o1 =@{@"ec":@"9991",
                        @"faculty":faculty};
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
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];

        @try {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (json!=nil){
                self.myclass =json[@"ret"];
                
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
            [self.tableView reloadData];
        }



    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = self.myclass[indexPath.row][2];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",self.myclass[indexPath.row][7],self.myclass[indexPath.row][4]];
    //["1702", "CA1315", "高級麵包製作及實踐", "D1", "16:00 - 20:00", "四月10 -  四月29", "廚藝實驗廚房", "Mary Ote"]
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myclass count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
