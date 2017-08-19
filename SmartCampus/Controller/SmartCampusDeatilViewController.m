//
//  SmartCampusDeatilViewController.m
//  Currency
//
//  Created by Cirno on 03/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "SmartCampusDeatilViewController.h"
#import "WebViewController.h"
#import "MTA.h"
#import <SafariServices/SafariServices.h>
@interface SmartCampusDeatilViewController ()
@property (nonatomic) NSInteger height;

@end

@implementation SmartCampusDeatilViewController
-(void)viewDidAppear:(BOOL)animated{
    [MTA trackPageViewBegin:@"SmartCampusDetail"];
}
-(void)viewDidDisappear:(BOOL)animated{
    [MTA trackPageViewEnd:@"SmartCampusDetail"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = NSLocalizedString(self.places.name, "");
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-NavBarHeight) style:UITableViewStyleGrouped];
   // _tableView.backgroundColor = [UIColor redColor];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer1) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    self.week = [[NSArray alloc]initWithObjects:NSLocalizedString(@"星期一", ""),NSLocalizedString(@"星期二", ""),NSLocalizedString(@"星期三", ""),NSLocalizedString(@"星期四", ""),NSLocalizedString(@"星期五", ""),NSLocalizedString(@"星期六", ""),NSLocalizedString(@"星期日", ""), nil];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 67, 0);

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 1){
        if (row == 1){
            if (self.places.Url!=nil)
                [self gotoWeb];
            else if (self.places.tel!=nil)
                [self phoneNumberLabelTap];

        }
        else{
            if (row == 2){
                if (self.places.tel!=nil){
                    [self phoneNumberLabelTap];
                }
        }
    }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0)
        switch (row) {
            case 0:
                return 60;
                break;
            case 1:
                return 160;
                break;
            case 2:
                return 160;
                break;
            case 3:{
                return self.height;
                break;
            }
            default:
                break;
        }
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        if ([self.places.Special count]==0) return 3;
        else return 4;
    }
    if (section ==1)
            return 1+(self.places.Url!=nil)+(self.places.tel!=nil);

    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1)
        return 0.1;
    return 40;
}
// 获取 label 实际所需要的高度
- (CGFloat)textHeight:(NSString *)labelText {
    UIFont *tfont = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [labelText boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return sizeText.height;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
       return [NSString stringWithFormat:@"%@%@       ",NSLocalizedString(@"当前时间", ""),[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterMediumStyle]];
    }
    else
        return @"";

}
-(void)timer1{
    [self.tableView headerViewForSection:0].textLabel.text =
    [
     [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"当前时间", ""),
      [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterMediumStyle]]uppercaseStringWithLocale:[NSLocale currentLocale] ];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSString * holiday = [MacauHoliday getHolidays:[NSDate date]];
    cell.textLabel.numberOfLines=0;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    switch (section){
        case 0:
            switch (row){
                case 0:{
                    cell.textLabel.text=self.places.name;
                    cell.textLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];

                    break;
                }
                case 1:{
                    cell.textLabel.text=NSLocalizedString(@"工作日时间", "");
                    for (int i =0;i<7;i++){
                        if (i==6)
                            cell.textLabel.text=[cell.textLabel.text stringByAppendingFormat:@"%@: %@",NSLocalizedString(self.week[i], ""),self.places.Work[i]];
                        else
                            cell.textLabel.text=[cell.textLabel.text stringByAppendingFormat:@"%@: %@\n",NSLocalizedString(self.week[i], ""),self.places.Work[i]];
                    }
                    cell.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
                    if ([holiday length]==0)
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    cell.userInteractionEnabled = NO;
                    return cell;
                    break;
                }
                case 2:{
                    cell.textLabel.text=NSLocalizedString(@"节假日时间", "");
                    for (int i =0;i<7;i++)
                        if (i==6)
                            cell.textLabel.text=[cell.textLabel.text stringByAppendingFormat:@"%@: %@",NSLocalizedString(self.week[i], ""),self.places.Holiday[i]];
                        else
                            cell.textLabel.text=[cell.textLabel.text stringByAppendingFormat:@"%@: %@\n",NSLocalizedString(self.week[i], ""),self.places.Holiday[i]];
                    cell.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
                    if ([holiday length]!=0)
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    cell.userInteractionEnabled = NO;
                    return cell;
                    break;
                }
                case 3:{
                    cell.textLabel.text=NSLocalizedString(@"特殊时间", "");
                    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
                    [dateFormatter1 setDateFormat:@"MM"];
                    NSDate *date = [NSDate date];
                    for (int i=0;i<[self.places.Special count];i++){
                        if ([[self.places.Special allKeys][i] containsString:@"~"]){
                            if ([[self.places.Special allKeys][i] containsString:[dateFormatter1 stringFromDate:date]]){
                                if (i==[self.places.Special count]-1)
                                    cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@"%@: %@",[self.places.Special allKeys][i],[self.places.Special allValues][i]];
                                else
                                    cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@"%@: %@\n",[self.places.Special allKeys][i],[self.places.Special allValues][i]];

                            }

                        } else {

                            if ([[self.places.Special allKeys][i] containsString:[dateFormatter1 stringFromDate:date]]){
                                if (i==[self.places.Special count]-1)
                                    cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@"%@: %@",[self.places.Special allKeys][i],[self.places.Special allValues][i]];
                                else
                                    cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@"%@: %@\n",[self.places.Special allKeys][i],[self.places.Special allValues][i]];

                        }
                    }
                        cell.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
                        self.height = [self textHeight:cell.textLabel.text];
                    }

                }
            }
            break;
        case 1:
            switch (row) {
                case 0:
                    cell.textLabel.text = self.places.desc;
                    cell.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
                    break;
                case 1:
                    if (self.places.Url!=nil){
                        cell.userInteractionEnabled = YES;
                        cell.textLabel.text = NSLocalizedString(@"访问网页", "");
                        cell.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
                        cell.textLabel.textColor = kColor(12, 128, 255);
                        return cell;
                    } else if (self.places.tel!=nil){
                            cell.userInteractionEnabled = YES;
                            cell.textLabel.text=self.places.tel;
                            cell.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
                            cell.textLabel.textColor = kColor(12, 128, 255);
                            return cell;
                    }
                    break;
                case 2:
                    if(self.places.tel!=nil){
                        cell.userInteractionEnabled = YES;
                        cell.textLabel.text=self.places.tel;
                        cell.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
                        cell.textLabel.textColor = kColor(12, 128, 255);
                        return cell;
                    }

                default:
                    break;
            }
            break;
        default:
            break;
    }
    cell.userInteractionEnabled = NO;

    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)gotoWeb{
    SFSafariViewController *new = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:self.places.Url]];
    new.view.tintColor = navigationTabColor;
    [self.navigationController pushViewController:new animated:YES];
}
-(void)phoneNumberLabelTap
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:+853%@",self.places.tel]];

    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        UIAlertView * calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
@end
