//
//  CourseDetailViewController.m
//  Currency
//
//  Created by Cirno on 02/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "CourseDetailViewController.h"
#import "UIImage+CYButtonIcon.h"
#import "UIButton+WHE.h"
#import "AFNetworking.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "CirnoError.h"
#import "CurrencyViewController.h"
#import "ClassTool.h"
#import "JDStatusBarNotification.h"
@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController{
    UIImage *backIcon;
}
-(void)Click:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self pressButton:nil];
    return YES;
}
- (IBAction)pressButton:(UIButton *)sender {
    if([_typecomment isFirstResponder]){
        [_typecomment resignFirstResponder];
    }
    CirnoLog(@"名称%@",_typecomment.text);
    if ([_typecomment.text length]>100){
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"超出字数", "") dismissAfter:2.0f];
        return;
    }
    [self sendComment:_typecomment.text andCoursecode:_course.coursecode];
     _typecomment.text = @"";

}
-(void)setEditOn{
    NSLog(@"editon");
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)setEditOff{
    NSLog(@"editoff");
    self.navigationItem.rightBarButtonItem = nil;
    [self.tableView setEditing:NO animated:YES];
}
-(void)deleteCommentWithCourseCode:(NSString*)coursecode
                           andDate:(NSString*)date{
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSDictionary *o1 =@{@"ec":@"9997",
                            @"courseCode": _course.coursecode,
                            @"studentID":[[Account shared]getStudentLongID],
                            @"date":date};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *secret = jsonString;
        NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
        //POST数据
        NSDictionary *parameters = @{@"ec":data};

        NSURL *URL = [NSURL URLWithString:@"https://must.plus/api/"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        //转成最原始的data,一定要加
        manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

        [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
              NSLog(@"！！！%@",json);
            if([json[@"state"] isEqualToString:@"1"]){
                //发送成功
                [JDStatusBarNotification showWithStatus:NSLocalizedString(@"删除成功", "") dismissAfter:2];
                dispatch_group_leave(group);
            }
            else{
                //发送失败
                [JDStatusBarNotification showWithStatus:NSLocalizedString(@"删除失败", "")dismissAfter:2];
                dispatch_group_leave(group);

            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            dispatch_group_leave(group);
            [CirnoError ShowErrorWithText:error.localizedDescription];
            [JDStatusBarNotification showWithStatus:NSLocalizedString(@"删除失败", "")dismissAfter:2];
            NSLog(@"%@",error.description);
        }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self initComment];
    });

}
-(void)sendComment:(NSString*)com
        andCoursecode:(NSString*)coursecode{
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSDictionary *o1 =@{@"ec":@"9998",
                            @"courseCode": _course.coursecode,
                            @"comment":com,
                            @"studentID":[[Account shared]getStudentLongID]};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *secret = jsonString;
        NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
        //POST数据
        NSDictionary *parameters = @{@"ec":data};

        NSURL *URL = [NSURL URLWithString:@"https://must.plus/api/"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        //转成最原始的data,一定要加
        manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

        [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //  NSLog(@"%@",json);
            if([json[@"state"] isEqualToString:@"1"]){
                //发送成功
                [JDStatusBarNotification showWithStatus:NSLocalizedString(@"发送成功", "") dismissAfter:2];
                dispatch_group_leave(group);
            }
            else{
                //发送失败
                [JDStatusBarNotification showWithStatus:NSLocalizedString(@"发送失败", "")dismissAfter:2];
                dispatch_group_leave(group);

            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            dispatch_group_leave(group);
            [CirnoError ShowErrorWithText:error.localizedDescription];
            [JDStatusBarNotification showWithStatus:NSLocalizedString(@"发送失败", "")dismissAfter:2];
            NSLog(@"%@",error.description);
        }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self initComment];
    });
}
- (void)getPermission{
    NSDictionary *o1 =@{@"ec":@"9999",
                        @"courseCode": _course.coursecode,
                        @"studentID":[[Account shared]getStudentLongID]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    //POST数据
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:@"https://must.plus/api/"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          NSLog(@"%@",json);
        if([json[@"state"] isEqualToString:@"1"]){
            //成功
            if ([json[@"ret"] isEqualToString:@"1"]){
                _sendPermission = NO;
                [self setCommentOff];
                [self setEditOn];
            } else if ([json[@"ret"] isEqualToString:@"-1"]){
                NSString*course = [[Account shared]getAllCourse];
                NSLog(@"course%@",course);
                NSUInteger result =[course containsString:_course.coursecode];
                NSLog(@"result%lu",(unsigned long)result);

                if (result!=0){
                    _sendPermission =YES;
                     [self setCommentOn];
                    [self setEditOff];
                }
                else{
                    _sendPermission =NO;
                     [self setCommentOff];
                    [self setEditOff];
                }
            }
        }
        else{
            //失败
            _sendPermission = NO;
            [self setCommentOff];
            [self setEditOff];

        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:error.localizedDescription];
        NSLog(@"%@",error.description);
    }];

}
-(void)setCommentOff{
    _typecomment.userInteractionEnabled =NO;
    _typecomment.placeholder = NSLocalizedString(@"无权发表评论", "");
    self.navigationItem.rightBarButtonItem = nil;

}
-(void)setCommentOn{
    _typecomment.userInteractionEnabled =YES;
    _typecomment.placeholder = NSLocalizedString(@"请输入评论", "");
   //  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_typecomment resignFirstResponder];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];

    _average = [[NSMutableDictionary alloc]init];
    _now = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    if (_isBack){
        backIcon = [UIImage cy_backButtonIcon:[UIColor whiteColor]];
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [backBtn setTitle:UIKitLocalizedString(@"Done") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchDown];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backBtn.tag = 100;
        backBtn.frame = CGRectMake(0, 0, 44, 44);
        UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(15, StatusBarHeight, 40, 40)];
        [customView addSubview:backBtn];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
    //_comments = [[NSMutableArray alloc]init];
    _typecomment = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, Width-20, 44)];
    _typecomment.placeholder = NSLocalizedString(@"输入评论", "");
    _typecomment.delegate = self;
    _typecomment.returnKeyType = UIReturnKeySend;
    _str = [[Account shared]getAllCourse];
    if (_str!=nil&&[_str length]!=0){
       CirnoLog(@"读取成功");
    } else {
        [self initCourse];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = NSLocalizedString(@"课程详细", "");

    _tableView.delegate =self;
    _tableView.dataSource = self;
    //1.创建队列组
    if (_teachers==nil){
        dispatch_group_t group = dispatch_group_create();
    //2.创建队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_async(group, queue, ^{
            dispatch_group_enter(group);
            NSDictionary *o1 =@{@"ec":@"9994",
                                @"courseCode": _course.coursecode};
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSString *secret = jsonString;
            NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
            //POST数据
            NSDictionary *parameters = @{@"ec":data};

            NSURL *URL = [NSURL URLWithString:@"https://must.plus/api/"];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

            //转成最原始的data,一定要加
            manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

            [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
              //  NSLog(@"%@",json);
                if([json[@"state"] isEqualToString:@"1"]){
                    NSArray * teacher = json[@"ret"];
                    if ([teacher isKindOfClass:[NSString class]]){
                        goto yes;
                    }

                    _teachers = [[NSMutableArray alloc]init];
                    for (NSString* str in teacher){
                      //  Teacher * tea= [[Teacher alloc]initWithName:str andEnName:nil andFtp:nil andFtpPassword:nil andEmail:nil andSubjects:nil andFaculty:nil andAvatar:nil];
                        [_teachers addObject:str];
                    }
                    dispatch_group_leave(group);
                }
                else{
                yes:{
                    dispatch_group_leave(group);
                }
                }
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                dispatch_group_leave(group);
                [CirnoError ShowErrorWithText:error.localizedDescription];
                NSLog(@"%@",error.description);
            }];
        });
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"teacher OK");
            if (_teachers !=nil)
                [self.tableView reloadData];
        });
    }
    [self initComment];
    _baseFrame=_tableView.frame;
    
    [self addToolSender];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==2) return YES;
    if (indexPath.section==1&&_teachers==nil) return YES;
    return NO;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    /** 首先调用父类的方法. */
    [super setEditing:editing animated:animated];

    /** 使tableView处于编辑状态. */
    [self.tableView setEditing:editing animated:animated];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  //  return [_tableData count];
    if (section == 0) {
        if (_DateAndTime)
            return 7;
        else
            return 4;
    }
    if (section == 1){
        if (_teachers!=nil){
            return [_teachers count];
        } else {
            return [_comments count]+1;
        }
    }
    if (section ==2 ){
        return [_comments count]+1;
    }
    return [_teachers count];
};
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_teachers!=nil&&indexPath.section==1){
    NSUInteger row = indexPath.row;
    TeacherViewController * tvc = [[TeacherViewController alloc]init];
    tvc.teacherName = _teachers[row];
    [self.navigationController pushViewController:tvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return NSLocalizedString(@"课程详细", "");
    if (section == 1){
        if (_teachers !=nil){
            return NSLocalizedString(@"任教教师", "");
        }
        else{
            return NSLocalizedString(@"课程评价", "");
        }
    }
    return NSLocalizedString(@"课程评价", "");

}
-(void)initCourse{
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
// 设置每个行单元格的内容等
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;

    if (section == 0){
        if (row == 0){
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.textLabel.text = _course.courseName;
            cell.detailTextLabel.text = _course.courseEnName;
            cell.detailTextLabel.alpha = 0.5;
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.userInteractionEnabled =NO;
            return cell;
        } else if (row == 1){
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = NSLocalizedString(@"课程编号", "");
            cell.detailTextLabel.text = _course.coursecode;
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.userInteractionEnabled =NO;
            return cell;
        } else if (row == 2){
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = NSLocalizedString(@"所属学院", "");
            cell.detailTextLabel.text = _course.faculty;
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.userInteractionEnabled =NO;
            return cell;
        } else if (row == 3){
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = NSLocalizedString(@"学分", "");
            cell.detailTextLabel.text = _course.credit;
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.userInteractionEnabled =NO;
            return cell;
        } else if (row == 4){
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = NSLocalizedString(@"上课时间", "");
            cell.detailTextLabel.text = _DateAndTime;
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.userInteractionEnabled =NO;
            return cell;
        } else if (row == 5){
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = NSLocalizedString(@"教室", "");
            cell.detailTextLabel.text = _Room;
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.userInteractionEnabled =NO;

            return cell;
        } else if (row == 6){
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = NSLocalizedString(@"班级", "");
            cell.detailTextLabel.text = _Class;
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.userInteractionEnabled =NO;
            return cell;
        }

    } else if (section == 1){
        if (_teachers[row]!=nil){
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.textLabel.text = _teachers[row];
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.userInteractionEnabled =YES;
            NSString* value =[self.average valueForKey:_teachers[row]];
            NSString* vip = [NSString stringWithFormat:@"%@",[[Account shared]getVip]];;
            NSLog(@"vip is %@",vip);
            if ([vip isEqualToString:@"2"]||[vip isEqualToString:@"3"]){
                if (value){
                    cell.detailTextLabel.text = value;
                } else {
                    [self initAverage:cell andTeacherName:_teachers[row]];
                }
            }
            return cell;
        } else {
            if ([_comments count] == row){
                UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                [cell addSubview:_typecomment];
                return cell;
            } else {
                UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                cell.textLabel.text = _comments[row].content;
                NSString* encry = [self encrypt:_comments[row].userID];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %@",encry,_comments[row].date]];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, [encry length])];
                cell.detailTextLabel.attributedText = attrStr;
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.adjustsFontSizeToFitWidth =YES;
                cell.userInteractionEnabled =NO;
                return cell;
            }

        }
    } else if (section ==2 ){
        if ([_comments count] == row){
            UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell addSubview:_typecomment];
            return cell;
        } else {
            UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.textLabel.text = _comments[row].content;
            NSString* encry = [self encrypt:_comments[row].userID];
             NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %@",encry,_comments[row].date]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, [encry length])];
            cell.detailTextLabel.attributedText = attrStr;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.adjustsFontSizeToFitWidth =YES;
            //cell.userInteractionEnabled =NO;
            return cell;
        }

    }
  //  NSLog(@"section = %lu,row=%lu",(unsigned long)section,(unsigned long)row);
    return nil;
};
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{

    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        NSLog(@"复制");
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; // 黏贴板
        [pasteBoard setString:cell.textLabel.text];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        NSLog(@"%@",[cell.detailTextLabel.text substringFromIndex:11]);
        //[self.tableView setEditing:NO animated:YES];
         [self deleteCommentWithCourseCode:_course.coursecode andDate:[cell.detailTextLabel.text substringFromIndex:11]];
        [self.comments removeObjectAtIndex:indexPath.row];  //删除数组里的数据
        [_tableView   deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell


    }
}
-(void)initComment{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
    NSDictionary *o1 =@{@"ec":@"9993",
                        @"courseCode": _course.coursecode};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:MirrorURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"json!%@",json);
        if([json[@"state"] isEqualToString:@"1"]){
            id comm = json[@"ret"];
            if ([comm isKindOfClass:[NSString class]]){
                 _comments = [[NSMutableArray alloc]init];
                dispatch_group_leave(group);
                return;

            }
            else{
                 _comments = [[NSMutableArray alloc]init];
                NSArray* com = comm;
                for (int i=0;i<[com count];i++){
                    CourseComment* comment = [[CourseComment alloc]initWithcontent:com[i][1] andDate:com[i][3] andUsername:com[i][2] ];
                    [_comments addObject:comment];

                }
            }
        }
        else{
        }
        NSLog(@"%@",_comments);
        dispatch_group_leave(group);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"%@",error.description);
        }];

    });


    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (_comments !=nil)
        [self.tableView reloadData];
        [self setCommentOff];
        [self getPermission];
    });
}
const NSString *chars=@"zxcvbnmasdfghjklqwertyuiopZXCVBNMASDFGHJKLQWERTYUIOP9638527410";
-(NSString *) md5:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}
-(void)initAverage:(UITableViewCell*)cell
    andTeacherName:(NSString*)Teacherstr{
    NSDictionary *o1 =@{@"ec":@"9996",
                        @"courseCode": _course.coursecode,
                        @"teacher":Teacherstr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};
    NSURL *URL = [NSURL URLWithString:@"https://must.plus/api/"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",json);
        if([json[@"state"] isEqualToString:@"1"]){
            id ret = json[@"ret"];
            if ([ret isKindOfClass:[NSString class]]){
                NSLog(@"failed");
            } else {
                id dummy = ret;
                //for (id dummy in class){
                NSString* str1 = dummy[@"average"];
                NSInteger num = (NSInteger)[dummy[@"numbers"] integerValue] ;
              //  NSString* teacher = dummy[@"teacher"];
              //  NSLog(@"%@,%ld,%@",str,(long)num,teacher);
                //   }
                [_average setValue:[NSString stringWithFormat:@"%@ / %ld",str1,(long)num] forKey:Teacherstr];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %ld",str1,(long)num];

            }
            //发送成功
        }
        else{
            //发送失败
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"%@",error.description);
    }];

}
-(NSString*)encrypt:(NSString*)str{
    NSString* md5 = [self md5:str];
    int tmp=0;
    NSString* ID =[[NSString alloc]init];
    for (int i=0;i<[md5 length];i++){
        tmp+=[md5 characterAtIndex:i]*[md5 characterAtIndex:i]*[md5 characterAtIndex:i]*[md5 characterAtIndex:i];
        ID = [ID stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"%C",[chars characterAtIndex:tmp%62]]];
        if ([ID length]==8) break;
    }
    while ([ID length]<8)
        ID = [ID stringByAppendingFormat:@"9"];
    return ID;
}

// 有多少个段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return 3-(_teachers==nil)-(_comments==nil);

    if (_teachers!=nil&&_comments ==nil) return 2;
    if (_teachers==nil&&_comments!=nil) return 2;
    if (_teachers==nil&&_comments==nil) return 1;
    if (_teachers!=nil&&_comments!=nil) return 3;
    return 2;
};
// 设置每个段的标题
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1){
        if (_teachers==nil&&(indexPath.row!=[_comments count])){
            NSInteger row = indexPath.row;
            UIFont *font = [UIFont systemFontOfSize:14];
            NSString* content = [_comments objectAtIndex:row].content;
            CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(Width, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
            return size.height+80;
        } else {
            return 44;
        }
    }
    if (indexPath.section ==2&&(indexPath.row!=[_comments count])){
        NSInteger row = indexPath.row;
        UIFont *font = [UIFont systemFontOfSize:14];
        NSString* content = [_comments objectAtIndex:row].content;
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(Width, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+80;
    }
    return 44;

}
-(void)viewWillAppear:(BOOL)animated{
     [self.tabBarController.tabBar setHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
     //[self.tabBarController.tabBar setHidden:NO];
}
-(void)dealloc{

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return UITableViewCellEditingStyleNone;
    //    return UITableViewCellEditingStyleInsert;
    NSString*studID = [[Account shared]getStudentLongID];
    if (_comments!=nil&&indexPath.row<[_comments count]){
           if (indexPath.section==1&&_teachers==nil){
               CirnoLog(@"%@ %@",studID,_comments[indexPath.row].userID);

        if ([_comments[indexPath.row].userID isEqualToString:studID]){
            NSLog(@"YES");
            return UITableViewCellEditingStyleDelete;
        }
    } else if (indexPath.section ==2){
        CirnoLog(@"%@ %@ %d",studID,_comments[indexPath.row].userID,[_comments[indexPath.row].userID isEqualToString:studID]);

        if ([_comments[indexPath.row].userID isEqualToString:studID]){
            NSLog(@"YES");
            return UITableViewCellEditingStyleDelete;
        }
    }
    }
    return UITableViewCellEditingStyleNone;
}
// 2.键盘弹出时候，调整视图高度
-(void)keyboardWillAppear:(NSNotification *)notification{
    NSLog(@"app");
    if (_ok) {
        NSLog(@"app1");
        _tableView.frame = _changeFrame;
        return;
    } else {
        NSLog(@"app2");
        CGRect currentFrame = _tableView.frame;
        CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
        currentFrame.origin.y = currentFrame.origin.y - change ;
        _tableView.frame = currentFrame;
        _changeFrame=currentFrame;
        _ok = YES;
    }

}
// 3.当键盘消失后，视图需要恢复原状。
-(void)keyboardWillDisappear:(NSNotification *)notification{
    NSLog(@"dis");
   // while (_now!=0){
//    _now--;
    //CGRect currentFrame = _tableView.frame;
 //   CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
  //  currentFrame.origin.y = currentFrame.origin.y + change ;
    _tableView.frame = _baseFrame;
  //  }

}
// 4.计算键盘的高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo{

    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [_typecomment convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    NSLog(@"height%f",keyboardEndingFrame.size.height);
    return keyboardEndingFrame.size.height;
}
-(void)addToolSender{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, Width, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                                  UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(end) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:UIKitLocalizedString(@"Done") forState:UIControlStateNormal];
    [btn setTitleColor:navigationTabColor forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    _typecomment.inputAccessoryView = topView;
}
-(void)end{
    [_typecomment endEditing:YES];
}
@end

#pragma clang diagnostic pop
