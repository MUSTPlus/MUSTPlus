//
//  CourseViewController.m
//  Currency
//
//  Created by Cirno on 01/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseDetailViewController.h"
#import "Account.h"
#import "AFNetworking.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "CirnoError.h"
#import "NowClassViewController.h"
@interface CourseViewController ()<CloseDelegate>

@end

@implementation CourseViewController
-(void)hideMenu{
    // dispatch_sync(dispatch_get_main_queue(), ^{
    _shadowView.hidden = YES;

    // });
}
-(void)refresh{
    [self searchBar:self.searchBar textDidChange:@""];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    [_menu close];

}-(void)initCourse{
    dispatch_group_t group = dispatch_group_create();
    NSString* nowSemester= [[Account shared]getGradeType];
    nowSemester = [NSString stringWithFormat:@"%@%@",[nowSemester substringFromIndex:8],@"09"];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSDictionary *o1 =@{@"ec":@"1038",
                            @"studentID": [[Account shared]getStudentLongID]};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                           options:NSJSONWritingPrettyPrinted
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
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            _str = @"";
            CirnoLog(@"Res%@",result);
            if([json[@"state"] isEqualToString:@"1"]){
                json = json[@"ret"];
                NSArray* a = json;
                for (int i =0;i<[a count];i++){
                    NSLog(@"%@",a[i][@"CourseCode"]);
                    if ([_str length]==0) _str = a[i][@"CourseCode"]; else
                        _str = [NSString stringWithFormat:@"%@;%@",_str,a[i][@"CourseCode"]];
                }
                dispatch_group_leave(group);
            }
            else{
                dispatch_group_leave(group);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {

            [CirnoError ShowErrorWithText:[error localizedDescription]];
            dispatch_group_leave(group);
        }];

    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (_str!=nil){
            [[Account shared]setAllCourse:_str];
            CirnoLog(@"All Course%@",_str);
        }
        else
            [CirnoError ShowErrorWithText:@"下载失败"];
    });

}
-(void)showMenu{
    _shadowView.hidden = YES;
    if (_menu.isOpen){
        NSLog(@"hidden");
        _shadowView.hidden = YES;
        return [_menu close];
    } else{
        _shadowView.hidden =NO;
    }

    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString([[Account shared]getFaculty], "")
                                                    subtitle:nil
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          ClassTool * classTool = [[ClassTool alloc]init];
                                                          NSString *t = [NSString stringWithFormat:@"%@1",[[Account shared]getFaculty]];

                                                          _tableData = [classTool searchFaculty:NSLocalizedString(t, "")];
                                                          _basic = [NSString stringWithFormat:@"Faculty = \"%@\"",NSLocalizedString(t, "")];
                                                          [self hideMenu];
                                                          [_tableView reloadData];

                                                          [self refresh];

                                                      }];

    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"显示全部", "")
                                                       subtitle:nil
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             _basic = [NSString stringWithFormat:@""];
                                                             NSLog(@"Item: %@", item);
                                                             [self hideMenu];
                                                             [_tableView reloadData];
                                                             [self refresh];


                                                         }];

    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"我上过的课", "")
                                                       subtitle:nil
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSString* query = [NSString stringWithFormat:@"CourseCode in ("];

                                                             if (_str!=nil){
                                                                 NSArray* class = [_str componentsSeparatedByString:@";"];
                                                                 for (NSString*str in class){
                                                                     query = [query stringByAppendingFormat:@"\'%@\',",str];

                                                                 }
                                                                 query = [[query substringToIndex:[query length]-1]stringByAppendingString:@")"];
                                                                 CirnoLog(@"%@",query);
                                                                 _basic = query;
                                                             }
                                                                                                                        [self hideMenu];
                                                             [self refresh];
                                                             [_tableView reloadData];
                                                         }];

    homeItem.tag = 0;
    exploreItem.tag = 1;
    //activityItem.tag = 2;
    profileItem.tag = 3;

    _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, profileItem]];
    _menu.closeDelegate = self;
    _menu.cornerRadius = 4;
    //  _menu.shadowColor = [UIColor blackColor];
    //  _menu.shadowOffset = CGSizeMake(0, 1);
    //   _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);

    [_menu showFromNavigationController:self.navigationController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _basic = [NSString stringWithFormat:@""];
    _str = [[Account shared]getAllCourse];
    if (_str!=nil&&[_str length]!=0){
        NSString* query = [NSString stringWithFormat:@"CourseCode in ("];
        CirnoLog(@"读取成功!%@!,%lu",_str,(unsigned long)[_str length]);
        NSArray* class = [_str componentsSeparatedByString:@";"];
        for (NSString*str in class){
            query = [query stringByAppendingFormat:@"\'%@\',",str];

        }
        query = [[query substringToIndex:[query length]-1]stringByAppendingString:@")"];
       // CirnoLog(@"%@",query);
        _basic = query;
    } else {
        [self initCourse];

    }
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = NSLocalizedString(@"课程", "");
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.placeholder = NSLocalizedString(@"课程名或课程编号", "");
    _searchBar.delegate = self;
    //_searchBar.showsCancelButton =YES;
    _tableView.tableHeaderView = _searchBar;
    ClassTool * classTool = [[ClassTool alloc]init];
    _tableData = [classTool search:@"" andPlus:_basic];



    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //[btn setTitle:NSLocalizedString(@"刷新", "") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

    //[btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.navigationItem.rightBarButtonItems = @[rewardItem];

 //   if ([preferredLang hasPrefix:@"zh-Hans"]){
       // _s2t = [[OpenCCService alloc]initWithConverterType:OpenCCServiceConverterTypeS2T];

   // else{
     //   _t2s = [[OpenCCService alloc]initWithConverterType:OpenCCServiceConverterTypeT2S];
  //  }
    _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    _shadowView.backgroundColor = [UIColor blackColor];
    _shadowView.alpha = 0.35f;
    [self.view addSubview:_shadowView];
    _shadowView.hidden = YES;
}

#pragma UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    CourseDetailViewController *cdvc = [[CourseDetailViewController alloc]init];
    cdvc.course = _tableData[row];
    [self.navigationController pushViewController:cdvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma UITableViewDataSource
// 设置每个段的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableData count];
};
// 设置每个行单元格的内容等
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseCellTableViewCell* cell = [CourseCellTableViewCell instanceCell];
    NSInteger section = indexPath.row;
    cell.frame = CGRectMake(0, 0, Width, 100);
    NSUserDefaults* d1efault = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [d1efault objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];

if ([preferredLang hasPrefix:@"en"]){
        [cell initWithTitle:_tableData[section].courseEnName
              andCourseCode:_tableData[section].coursecode
                 andFaculty:_tableData[section].faculty
                  andCredit:_tableData[section].credit];
    } else
        if ([preferredLang hasPrefix:@"zh-Hans"]){
            XGSim2Tra* con = [[XGSim2Tra alloc]init];
            [cell initWithTitle:[con big5ToGb:NSLocalizedString(_tableData[section].courseName, "")]
                  andCourseCode:_tableData[section].coursecode
                     andFaculty:_tableData[section].faculty
                      andCredit:_tableData[section].credit];
        } else
   [cell initWithTitle:NSLocalizedString(_tableData[section].courseName, "")
         andCourseCode:_tableData[section].coursecode
            andFaculty:_tableData[section].faculty
             andCredit:_tableData[section].credit];
//    if (indexPath.row == 1)
//    [cell initWithTitle:@"藥劑學實驗" andCourseCode:@"BP12204" andFaculty:@"资讯科技学院" andCredit:@"3.0"];
//    else
//[cell initWithTitle:@"藥物化學實驗" andCourseCode:@"BPAZ0023" andFaculty:@"药学院" andCredit:@"1.0"];
    return cell;
};
// 有多少个段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
};
// 设置每个段的标题
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma UISearchBarDelegate
// 设置搜索框文本变化时的事件响应函数
-(void)getNowClass:(NSString*)faculty{
    NowClassViewController* vc = [[NowClassViewController alloc]init];
    vc.faculty = faculty;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NSString*)keywords{
    return @"⬆️⬆️⬇️⬇️⬅️➡️⬅️➡️BABA";
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    ClassTool * classTool = [[ClassTool alloc]init];
   // searchText = [NSString stringWithFormat:@"%@%@",searchText,_basic];
    XGSim2Tra* con = [[XGSim2Tra alloc]init];
    searchText = [con gbToBig5:searchText];
    _tableData = [classTool search:searchText andPlus:_basic];
    NSLog(@"basic=%@",_basic);
    [_tableView reloadData];
    if ([searchText isEqualToString:self.keywords]){
        NSString* str = [searchText stringByReplacingOccurrencesOfString:self.keywords withString:@""];
        if ([str length]==0) str = @"ALL";
        [self getNowClass:str];
    }
};
// 点击取消搜索按钮事件响应函数
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

};
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
    self.navigationController.navigationBarHidden=NO;
     [self.tabBarController.tabBar setHidden:YES];

}

-(void) close{
    _shadowView.hidden = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

@end
