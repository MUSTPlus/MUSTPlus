//
//  AboutViewController.m
//  Currency
//
//  Created by Cirno on 09/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "AboutViewController.h"
#import "Alert.h"
#import "UserDetailCellTableViewCell.h"
#import "POP.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "T-RexRunner.h"
#import "UserDetailsController.h"
@interface AboutViewController ()
@property (nonatomic,strong) UIButton* backbutton;
@property (nonatomic,strong) UIImageView* header1;
@property (nonatomic,strong) UIImageView* header2;
@property (nonatomic,strong) UILabel*     label1;
@property (nonatomic,strong) UILabel*     label2;
@end

@implementation AboutViewController
-(void)back1{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)updateHead1:(NSString*)url{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_header1 sd_setImageWithURL:[NSURL URLWithString:url]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {


        }];

    }];
}
-(void)updateHead2:(NSString*)url{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_header2 sd_setImageWithURL:[NSURL URLWithString:url]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {


        }];
    }];
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
}
-(void)ClickAva1{
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    udc.isSelf = NO;
    udc.studID = @"1509853G-I011-0243";
    //udc.currentUser = [[UserModel alloc]getUserModel:zxczxc];
    [self.navigationController pushViewController:udc animated:YES];
}
-(void)ClickAva2{
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    udc.isSelf = NO;
    udc.studID = @"1309853Z-I011-0011";
    //udc.currentUser = [[UserModel alloc]getUserModel:zxczxc];
    [self.navigationController pushViewController:udc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (indexPath.row==0){
            [self ClickAva1];
        }
        if (indexPath.row ==1){
            [self ClickAva2];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
    self.navigationController.navigationBarHidden=NO;
}
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 0)
        return [NSString stringWithFormat:@"%@ %@ %@ %@\n%@\n%@",[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"],@"build",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@"version",@"Logo Design:科大会刊",@"Special Thanks:IEEE MUST & Prof. Zhang D."];
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = NSLocalizedString(@"关于", "");
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, Width, Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 150)];
    _logoview = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-125, 50, 100, 100)];
    _logoview.image = [UIImage imageNamed:@"logo"];
    _logoview.contentMode =  UIViewContentModeScaleAspectFill;
    self.view.backgroundColor=kColor(239, 239, 244);
    [_logoview sizeThatFits:CGSizeMake(100, 100)];
//    [_backbutton setImage:[UIImage imageNamed:@"story_back" ]forState:UIControlStateNormal];
//    [_backbutton setImage:[UIImage imageNamed:@"story_back_press"] forState:UIControlStateSelected];
//    [_backbutton setTitle:NSLocalizedString(@"返回", "") forState:UIControlStateNormal];
//    [_backbutton addTarget:self action:@selector(back1) forControlEvents:UIControlEventTouchDown];
//
//    [self.navigationController.navigationBar addSubview:_backbutton];
    _logoview.clipsToBounds =YES;
    _logoview.layer.cornerRadius = 3;
    _logoview.layer.masksToBounds =YES;
    //_logoview.center=_topview.center ;
    _titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(Width/2-125+120, 50, Width-150, 50)];
    _titlelabel.text = @"MUST+";
    _titlelabel.numberOfLines=0;
    _titlelabel.font = [UIFont systemFontOfSize:45 weight:UIFontWeightUltraLight];
    _titlelabel.alpha = 0;

    _footerview = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width, 60)];
    _footerview.titleLabel.numberOfLines = 2;
    [_footerview setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"用户协议", "")] forState:UIControlStateNormal ];
 //   UILabel* buildversion = [[UILabel alloc]initWithFrame:CGRectMake(0, Height-40, Width, 30)];
  //  buildversion.text = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
 //   buildversion.textColor = kColor(200, 200, 200);
 //   buildversion.contentMode=UIViewContentModeCenter;

   // [_tableView addSubview:buildversion];

    _footerview.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    _footerview.titleLabel.contentMode=UIViewContentModeCenter;
    [_footerview addTarget:self action:@selector(showUserLicense) forControlEvents:UIControlEventTouchDown];
    //_footerview.titleLabel.textColor = kColor(87, 107, 149);
    [_footerview setTitleColor:kColor(87, 107, 149)forState:UIControlStateNormal];
    _tableView.tableFooterView=_footerview;
    [_topview addSubview:_titlelabel];
    _versionlabel = [[UILabel alloc]initWithFrame:CGRectMake(Width/2-125+140, 100, Width-150, 50)];
    _versionlabel.alpha = 0;
    //_versionlabel.text = VERSION;
    _versionlabel.numberOfLines=0;
    _versionlabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightThin];
    _topview.alpha=0;
    _tableView.alpha=0;
    [_topview addSubview:_versionlabel];
    [_topview addSubview:_logoview];
    _tableView.tableHeaderView = _topview;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", "") style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.view addSubview:_tableView];
    self.numberAnimation          = [[POPNumberAnimation alloc] init];
    self.numberAnimation.delegate = self;
    self.numberAnimation.fromValue      = 0;
    self.numberAnimation.toValue        = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
    self.numberAnimation.duration       = 4.f;
    self.numberAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.69 :0.11 :0.32 :0.88];
    [self.numberAnimation saveValues];
    [self.numberAnimation startAnimation];
    POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    basic.fromValue = @(0.0);
    basic.toValue = @(1.0);
    basic.beginTime = CACurrentMediaTime() + 1.0f;
    basic.duration = 2.0f;
    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anBasic.toValue = @(Width/2+110);
    if (iPhone6_plus) anBasic.toValue = @(Width/2+130);
    if (iPhone5_5s) anBasic.toValue = @(Width/2+80);
    anBasic.beginTime = CACurrentMediaTime() + 1.0f;
    anBasic.duration = 2.0f;
    [self.versionlabel pop_addAnimation:anBasic forKey:@"position"];
    [self.titlelabel pop_addAnimation:basic forKey:@"fade"];
    [self.topview pop_addAnimation:basic forKey:@"fade"];
    [self.versionlabel pop_addAnimation:basic forKey:@"fade"];
    [self.tableView pop_addAnimation:basic forKey:@"fade"];
    [self update];
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singletap)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EasterEgg)];

    [doubleTap setNumberOfTapsRequired:2];

    [self.logoview addGestureRecognizer:doubleTap];
    [self.logoview addGestureRecognizer:singleRecognizer];
  //  [self.logoview setGestureRecognizers:doubleTap];
    self.logoview.userInteractionEnabled = YES;
     [singleRecognizer requireGestureRecognizerToFail:doubleTap];

}
-(void)singletap{
    NSLog(@"single");
}
-(void)EasterEgg{
    NSLog(@"yes");
    T_RexRunner* run = [[T_RexRunner alloc]init];

    [self.navigationController pushViewController:run animated:YES];
}
- (void)POPNumberAnimation:(POPNumberAnimation *)numberAnimation currentValue:(CGFloat)currentValue {

    // Init string.
    NSString *numberString = [NSString stringWithFormat:@"%.1f", currentValue];

    NSMutableAttributedString *richString = [[NSMutableAttributedString alloc] initWithString:numberString];
    _versionlabel.attributedText = richString;
}

- (UIColor *)numColorWithValue:(CGFloat)value {

    return [UIColor colorWithRed:value green:0 blue:0 alpha:1.f];
}

- (UIColor *)mpsColorWithValue:(CGFloat)value {

    return [UIColor colorWithRed:0 green:value / 2.f blue:value / 3.f alpha:value];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) return 80;
    return 44;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0)
        return NSLocalizedString(@"作者", "");
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)update{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        UserModel* um1 = [[UserModel alloc]getUserModel:@"1509853G-I011-0243"];
        UserModel* um2 = [[UserModel alloc]getUserModel:@"1309853Z-I011-0011"];
        [self updateHead1:um1.avatarPicURL];
        [self updateHead2:um2.avatarPicURL];
    });
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section==0){
        if (row ==0){
            _header1 = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 65, 65)];
            _header1.layer.cornerRadius = _header1.frame.size.width/2;
            _header1.clipsToBounds = YES;
            _header1.layer.borderWidth = 2;
            _header1.layer.borderColor = [UIColor clearColor].CGColor;
            _label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, Width-80, 80)];
            _label1.text = NSLocalizedString(@"Umi", "");
            _label1.font = [UIFont systemFontOfSize:18];
            _label1.textColor = [UIColor blackColor];
            [cell addSubview:_header1];
            [cell addSubview:_label1];
        }
        if (row == 1){
            _header2 = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 65, 65)];
            _header2.layer.cornerRadius = _header1.frame.size.width/2;
            _header2.clipsToBounds = YES;
            _header2.layer.borderWidth = 2;
            _header2.layer.borderColor = [UIColor clearColor].CGColor;
            _label2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, Width-80, 80)];
            _label2.text = NSLocalizedString(@"科大彦祖", "");
            _label2.font = [UIFont systemFontOfSize:18];
            _label2.textColor = [UIColor blackColor];
            [cell addSubview:_header2];
            [cell addSubview:_label2];
        }
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)showUserLicense{
    Alert *alert = [[Alert alloc] initWithTitle:NSLocalizedString(@"用户协议", @"") message:NSLocalizedString(@"协议", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles: nil];
    alert.contentAlignment =NSTextAlignmentLeft;
    [alert show];
}
@end
