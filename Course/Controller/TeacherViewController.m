//
//  TeacherViewController.m
//  Currency
//
//  Created by Cirno on 04/01/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "TeacherViewController.h"
#import "CourseDetailViewController.h"
#import "BasicHead.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "NSString+AES.h"
#import "HeiHei.h"
#import "CirnoError.h"
#import "ClassTool.h"
@interface TeacherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UIImageView* headerview;
@end

@implementation TeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationItem.title = @"教师详情";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;

   // _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:_tableView];
    //_teacherName = @"羅少龍";
 [self.tabBarController.tabBar setHidden:YES];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSDictionary *o1 =@{@"ec":@"1037",
                            @"teacherName":[NSString stringWithFormat:@"%@",_teacherName]};

        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *secret = jsonString;
        NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];

        NSLog(@"!!%@",data);
        //POST数据
        NSDictionary *parameters = @{@"ec":data};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
        NSURL *URL = [NSURL URLWithString:BaseURL];
        [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([json[@"state"] isEqualToString:@"1"]){
                id content = json[@"content"];
                NSString*name = _teacherName;
                NSString*enName = content[@"enName"];
                NSString*faculty = content[@"faculty"];
                NSString*ftp=content[@"ftp"];
                NSString*ftppassword=content[@"ftppassword"];
                NSString*email=content[@"email"];
                NSString*class=content[@"classes"];
                NSMutableArray<Course*>* subject = [[NSMutableArray alloc]init];
                NSArray* tmp = [[class componentsSeparatedByString:@";"]mutableCopy];
                ClassTool * classTool = [[ClassTool alloc]init];
                for (int _=0;_<[tmp count];_++){
                    [subject addObject:[classTool searchCode:tmp[_]][0] ];
                }
                _teacher = [[Teacher alloc]initWithName:name
                                              andEnName:enName
                                                 andFtp:ftp
                                         andFtpPassword:ftppassword
                                               andEmail:email
                                            andSubjects:subject
                                             andFaculty:faculty
                                              andAvatar:nil];

                [self updateTableView];
                dispatch_group_leave(group);
                //[self saveData:studentID userName:userName password:password otherInfo:json[@"ret"]];
               // [HUD dismiss];
            }
            else{
                dispatch_group_leave(group);
                [CirnoError ShowErrorWithText:NSLocalizedString(@"未查询到此教师", "")];
            }
            NSLog(@"json!!%@",json);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            dispatch_group_leave(group);
            
        }];

    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (_teacher)
            [self updateTableView];
        else
            [CirnoError ShowErrorWithText:@"下载失败"];
    });

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4){
    NSUInteger row = indexPath.row;
    CourseDetailViewController *cdvc = [[CourseDetailViewController alloc]init];
    cdvc.course = _teacher.subjects[row];
    [self.navigationController pushViewController:cdvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 80;
    else return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) return [_teacher.subjects count];
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"section%lu",(unsigned long)[_teacher.subjects count]);
    
    if([_teacher.subjects count] >0) return 5;
    return 4;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return nil;

            break;
        case 1:
            return NSLocalizedString(@"学院", "");
            break;
        case 2:
            return @"FTP";
            break;
        case 3:
            return @"E-mail";
            break;
        case 4:
            return NSLocalizedString(@"科目", "");
            break;
        default:
            return @"";
            break;
    }
    return @"cirno";

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
//    switch (indexPath.row){
//        case 0:
            if (indexPath.section == 0){
                NSArray *views = [cell subviews];
                for(UIView* view in views)
                    [view removeFromSuperview];
                _headerview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 65, 65)];
                _headerview.layer.cornerRadius = _headerview.frame.size.width/2;
                _headerview.clipsToBounds = YES;
                if (!_teacher.avatar)
                    _headerview.image = [UIImage imageNamed:@"defaultTeacher"];
                else
                    [_headerview sd_setImageWithURL:[NSURL URLWithString:_teacher.avatar]];
                _headerview.contentMode = UIViewContentModeScaleAspectFit;
                _label = [[UILabel alloc]initWithFrame:CGRectMake(100, 6, Width-80, 40)];
                if (![_teacher.enName isEqualToString:_teacher.Name]){
                    _labelen = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, Width-80, 40)];
                    _labelen.text = _teacher.enName;
                    _labelen.font = [UIFont systemFontOfSize:17];
                    _labelen.adjustsFontSizeToFitWidth = YES;
                    _labelen.textColor =[UIColor blackColor];
                    _label.font = [UIFont systemFontOfSize:25];

                    [cell addSubview:_labelen];
                }

                _label.text =_teacher.Name;

                _label.adjustsFontSizeToFitWidth  =YES;

                _label.textColor = [UIColor blackColor];
                [cell addSubview:_headerview];
                [cell addSubview:_label];
                cell.userInteractionEnabled =NO;
                 _labelen.alpha = 0.5;

            }else if (indexPath.section == 1){
                if (_teacher.Faculty)
                    cell.textLabel.text = NSLocalizedString(_teacher.Faculty, "");
                else
                    cell.textLabel.text = NSLocalizedString(@"暂无", "");
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.adjustsFontSizeToFitWidth  =YES;
                cell.userInteractionEnabled = NO;
            }
            else if (indexPath.section == 2){


                if ((NSNull*)_teacher.ftp!=[NSNull null]&&(NSNull*)_teacher.ftpPassword!=[NSNull null]){
                    NSArray *views = [cell subviews];
                    for(UIView* view in views)
                        [view removeFromSuperview];
                    _button = [[PressButton alloc]initWithFrame:CGRectMake(-1,0, Width+2, 44)];
                    _button.delegate = self;
                    _button.font = [UIFont systemFontOfSize:15];
                    _button.normalTextColor = [UIColor blackColor];
                    _button.highlightTextColor = [UIColor whiteColor];
                    _button.animationColor = navigationTabColor;
                    _button.animationWidth = Width;
                    _button.text = [NSString stringWithFormat:@"%@:%@",_teacher.ftp,_teacher.ftpPassword];
                    cell.textLabel.hidden =YES;
                }
                else{
                    _button.hidden =YES;
                    cell.textLabel.hidden =NO;
                    cell.textLabel.text = NSLocalizedString(@"暂无", "");
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    _button.userInteractionEnabled = NO;
                    cell.userInteractionEnabled = NO;

                }

                [cell addSubview:_button];
                _button.tag = 999;
            } else if(indexPath.section == 3){
                NSArray *views = [cell subviews];
                for(UIView* view in views)
                    [view removeFromSuperview];
                if (_teacher.email){
                    _emailbutton = [[PressButton alloc]initWithFrame:CGRectMake(-1,0, Width+2, 44)];
                    _emailbutton.delegate = self;
                    _emailbutton.font = [UIFont systemFontOfSize:15];
                    _emailbutton.normalTextColor = [UIColor blackColor];
                    _emailbutton.highlightTextColor = [UIColor whiteColor];
                    _emailbutton.animationColor = navigationTabColor;
                    _emailbutton.animationWidth = Width;
                    _emailbutton.tag = 888;
                    _emailbutton.text = [NSString stringWithFormat:@"%@",_teacher.email];
                    cell.textLabel.hidden =YES;
                }
                else{
                    _emailbutton.text = NSLocalizedString(@"暂无", "");
                    _emailbutton.hidden =YES;
                    cell.textLabel.text = NSLocalizedString(@"暂无", "");
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    _emailbutton.userInteractionEnabled = NO;
                }
                [cell addSubview:_emailbutton];
            } else if (indexPath.section == 4){
                if (_teacher.subjects[indexPath.row].courseName){
                    cell.textLabel.text = _teacher.subjects[indexPath.row].courseName;
                     cell.detailTextLabel.text = _teacher.subjects[indexPath.row].courseEnName;
                    cell.detailTextLabel.adjustsFontSizeToFitWidth =YES;
                    cell.detailTextLabel.alpha = 0.3f;
                }
                else
                    cell.textLabel.text = _teacher.subjects[indexPath.row].coursecode;
            }
    cell.textLabel.adjustsFontSizeToFitWidth  =YES;
    return cell;
}
-(void)updateTableView{
    [self.tableView reloadData];
    _labelen.alpha = 0.3f;
}
- (void)finishedEventByPressAnimationButton:(PressButton *)button {
    if (_button.tag ==999){
        [self copyToClipBoard:[NSString stringWithFormat:@"ftp://%@%@",button.text,@"@ftp.must.edu.mo"]];

    } else{
        [self copyToClipBoard:button.text];
    }
    [button buttonTouchDragExit];
}

-(void)copyToClipBoard:(NSString*)str{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:str];
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"已复制到剪贴板", "") dismissAfter:1.0f ];
    

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
    self.navigationController.navigationBarHidden=NO;
    [self.tabBarController.tabBar setHidden:YES];

}
-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}
@end
