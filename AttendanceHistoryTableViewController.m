//
//  AttendanceHistoryTableViewController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/8/16.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "AttendanceHistoryTableViewController.h"
#import "AFNetworking.h"
#import "CirnoError.h"
#import <MJRefresh.h>
@interface AttendanceHistoryTableViewController ()

@end

@implementation AttendanceHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.history = [[NSMutableArray alloc]init];

      self.title = @"签到历史";
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self getData];
    [self.tableView.mj_header beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getData{
    NSDictionary *o1 =@{@"stuid": [[Account shared]getStudentLongID]};
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@signHistoryAll",AttendanceURL]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){

        
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        if (result == nil)
            [CirnoError ShowErrorWithText:NSLocalizedString(@"网络错误", "")];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        @try {
            [_history removeAllObjects];
            for (id history in json){
                AttendanceHistory* dummy= [[AttendanceHistory alloc]init];
                [dummy initWithCid:history[@"cid"]
                     andCourseCode:history[@"course"][@"coursecode"]
                            andCls:history[@"course"][@"class"]
                       andSemester:history[@"course"][@"semester"]
                       andSigntime:history[@"signtime"]
                            andAid:history[@"aid"]
                         andSource:history[@"source"]
                         andStatus:history[@"status"]];
                [self.history addObject:dummy];
            }
        } @catch (NSException *exception) {
             [CirnoError ShowErrorWithText:@"解析数据时错误"];

        } @finally {
         [self.tableView reloadData];
             [self.tableView.mj_header endRefreshing];
        }

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:error.localizedDescription];
    }];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.history count];
}

-(NSString*)unixToNSDate:(NSString*)unix{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    return [formatter stringFromDate:
            [
             [NSDate alloc]initWithTimeIntervalSince1970:
             [unix doubleValue]
             ]
            ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.history[indexPath.row].coursecode,self.history[indexPath.row].coursename,self.history[indexPath.row].cls,self.history[indexPath.row].semester] ;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ 【%@】",
                                 [self unixToNSDate:self.history[indexPath.row].signTime] ,
                                  self.history[indexPath.row].source,self.history[indexPath.row].status ];
    cell.detailTextLabel.alpha = 0.5f;
    cell.userInteractionEnabled = NO;

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
