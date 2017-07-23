//
//  LoginViewController.m
//  MUSTBEE
//
//  Created by zbc on 15/12/14.
//  Copyright © 2015年 zbc. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "Account.h"
#import "LoginViewController.h"
#import "BasicHead.h"
#import "Alert.h"
#import <JGProgressHUD.h>
#import "NSString+AES.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "POP/POP.h"
#import "JDStatusBarNotification.h"
#import "CirnoError.h"
#import "CirnoSideBarViewController.h"
#import "JPUSHService.h"
#import "UserModel.h"
@interface LoginViewController ()<UITextFieldDelegate>{
    UIView* _logoView;
    UIView* _midView;
    UIView* _bottomView;
    BOOL _isHide;
}
@property (nonatomic,strong) UITextField *StudentID;
@property (nonatomic,strong) UITextField *PassWord;
@property (nonatomic,strong) UIImageView *logoImageView;

@end

@implementation LoginViewController
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
- (void)createLogoView{
    CGFloat viewHeigth = (130/667.0)*self.view.frame.size.height;
    CGFloat imgWidth = (60/375.0)*self.view.frame.size.width;
    _logoView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeigth ,self.view.frame.size.width,imgWidth)];
    [self.view addSubview:_logoView];
    UIImageView * logoView = [[UIImageView alloc]initWithFrame:CGRectMake((_logoView.frame.size.width - imgWidth)/2.0, 0,imgWidth, imgWidth)];
    logoView.image = [UIImage imageNamed:@"m200-1"];
    logoView.layer.cornerRadius = 5;
    logoView.clipsToBounds = YES;
    [_logoView addSubview:logoView];
}
- (void)createMidView{
    CGFloat viewHeigth = (275/667.0)*Height;
    CGFloat subViewWidth = (170/667.0)*Height;
    _midView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeigth, Width, subViewWidth)];
    [self.view addSubview:_midView];
    
    CGFloat left = (20/375.0)*Width;
    CGFloat textHeight = (53/667.0)*Height;
    
    //textfield背景view
    UIView * textGroudView = [[UIView alloc]initWithFrame:CGRectMake(left, 0, Width - 2*left, 2*textHeight)];
    textGroudView.backgroundColor = [UIColor whiteColor];
    textGroudView.layer.cornerRadius = 5;
    [_midView addSubview:textGroudView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, textHeight, Width - 2*left, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:247/255.0 alpha:1];
    [textGroudView addSubview:lineView];
    //textfield
    

    _StudentID = [[UITextField alloc]initWithFrame:CGRectMake(10, 0 * textHeight, Width - 2*left-10, textHeight)];
    _PassWord = [[UITextField alloc]initWithFrame:CGRectMake(10, 1 * textHeight, Width - 2*left-10, textHeight)];
    _StudentID.placeholder = NSLocalizedString(@"学生账号", @"");
    _StudentID.tag =10000;
    _StudentID.delegate=self;
    _StudentID.keyboardType=UIKeyboardTypeASCIICapable;
    _PassWord.secureTextEntry = YES;
    _PassWord.placeholder = NSLocalizedString(@"密码", @"");
    _PassWord.tag =10001;
    _PassWord.keyboardType=UIKeyboardTypeASCIICapable;
    [textGroudView addSubview:_StudentID];
    [textGroudView addSubview:_PassWord];

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(left, _midView.frame.size.height - textHeight, Width - 2*left, textHeight);
    [btn setTitle:NSLocalizedString(@"登录", @"") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    btn.backgroundColor = [UIColor colorWithRed:79/255.0 green:106/255.0 blue:163/255.0 alpha:1];
    btn.layer.cornerRadius = 5;
    [_midView addSubview:btn];
}
- (void)keyboardWasShown:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if (keyboardSize.height>0 && _StudentID.secureTextEntry == YES) {
        //不让换键盘的textField的
        _StudentID.secureTextEntry = NO;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //判断一下，哪个是不让换键盘的textField
    if (textField == _StudentID) {
        _StudentID.secureTextEntry = YES;
    }
}
- (void)createBottomView{
    CGFloat viewHeigth = (560/667.0)*Height;
    CGFloat subViewWidth = (90/667.0)*Height;
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeigth, Width, subViewWidth)];
    [self.view addSubview:_bottomView];
    
    for (int i = 0; i<2; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*(subViewWidth/2.0), Width,subViewWidth/2.0);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0)
        {
            [btn setTitle:NSLocalizedString(@"账号问题", @"") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [btn addTarget:self action:@selector(showHelp) forControlEvents:UIControlEventTouchDown];
        }
        else
        {
            [btn setTitle:NSLocalizedString(@"用户协议", @"") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn addTarget:self action:@selector(showUserLicense) forControlEvents:UIControlEventTouchDown];
        }
        [_bottomView addSubview:btn];
    }

}
-(void)showUserLicense{
    Alert *alert = [[Alert alloc] initWithTitle:NSLocalizedString(@"用户协议", @"") message:NSLocalizedString(@"协议", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles: nil];
    alert.contentAlignment =NSTextAlignmentLeft;
    [alert show];
}
-(void)showHelp{
    Alert *alert = [[Alert alloc] initWithTitle:NSLocalizedString(@"账号问题", @"") message:NSLocalizedString(@"账号问题详细", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles: nil];
    alert.contentAlignment =NSTextAlignmentCenter;
    [alert show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isHide = YES;
    //logo视图
    [self createLogoView];
    //中间视图
    [self createMidView];
    //下方视图
    [self createBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //添加监听键盘弹起
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.view.backgroundColor = navigationTabColor;

//    [self setPreferredStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showWhenLoginFailed{
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"账号密码错误", @"") dismissAfter:1];
    [self boomShakalaka:_midView];
}

-(void)showConnectFailed{
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"网络错误", @"") dismissAfter:1];
    [self boomShakalaka:_midView];
}

-(void)showWhenEmpty{
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"账号密码为空", @"") dismissAfter:1];
    [self boomShakalaka:_midView];
}
-(void)toHomeController{
    UIViewController *next  = [[UIViewController alloc] init];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    next = [storyBoard instantiateViewControllerWithIdentifier:@"Root"];
//    CirnoSideBarViewController *next  = [[CirnoSideBarViewController alloc] init];
    [self presentViewController:next animated:NO completion:nil];
}
-(void)login{

    if([self.StudentID.text length] == 0 || [self.PassWord.text length] == 0){
        [self showWhenLoginFailed];
      //  [alert show];
    }
    else if([self.StudentID.text length] == 18){

        NSString *lowerString = [self.StudentID.text lowercaseString];
        NSString *s1  = [lowerString substringWithRange:NSMakeRange(0, 8)];
        NSString *s2  = [lowerString substringWithRange:NSMakeRange(9, 4)];
        NSString *s3  = [lowerString substringWithRange:NSMakeRange(14, 3)];
        NSString *userID = [NSString stringWithFormat:@"%@%@%@",s1,s2,s3];
      //  NSLog(@"UserID%@",userID);
        [self CheckSuccess:[self.StudentID.text uppercaseString] userName:userID password:self.PassWord.text];
    }
    else{
        [self showWhenLoginFailed];
      //  [alert show];
    }
}

-(void) CheckSuccess:(NSString *)studentID
            userName:(NSString *)userName
            password:(NSString *)password{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = NSLocalizedString(@"Loading", "");
    [HUD showInView:self.view];
    
  //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的账号密码!" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil];
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1005",
                        @"password":password,
                        @"studentID": studentID,
                        @"studentUserID" : userName};
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
            [self saveData:studentID userName:userName password:password otherInfo:json[@"ret"]];
            [HUD dismiss];
        }
        else{
            [self showWhenLoginFailed];
            [HUD dismiss];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        [self showConnectFailed];
        [HUD dismiss];
    }];
}
-(void)mirrorServer:(NSString *)studentID
           userName:(NSString *)userName
           password:(NSString *)password{
    NSDictionary *o1 =@{@"ec":@"1005",
                        @"password":password,
                        @"studentID": studentID,
                        @"studentUserID" : userName};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    //POST数据
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:MirrorURL];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager1.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager1 POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([json[@"state"] isEqualToString:@"1"]){
          //  [CirnoError ShowErrorWithText:json];
        }
        else{
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {


    }];

}
-(void)saveOtherInfo:(NSDictionary*)info{
    [[Account shared]setAvatar:[info objectForKey:AvaTar]];
    [[Account shared]setBgImage:[info objectForKey:Backgroundimage]];
    [[Account shared]setGradeType:[info objectForKey:@"GradeType"]];
    [[Account shared]setMajorType:[info objectForKey:@"MajorType"]];
    [[Account shared]setNickname:[info objectForKey:NickName]];
    [[Account shared]setVip:[info objectForKey:Vip]];
    [[Account shared]setWhatsup:[info objectForKey:Whatsup]];
    NSString *GradeType = [[info objectForKey:@"GradeType"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *MajorType = [self replaceUnicode:[info objectForKey:@"MajorType"]];
    NSSet* tags = [NSSet alloc];
    NSString *vip = [NSString stringWithFormat:@"vip%@",[[Account shared]getVip]];
    NSString*buildversion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    NSString*version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    tags = [NSSet setWithObjects:GradeType,MajorType,vip,version,buildversion,nil];
    CirnoLog(@"tagis%@",tags);
    NSString *alia =  [[Account shared] getStudentShortID] ;

    [JPUSHService setTags:tags alias:alia fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"%d,%@,%@",iResCode,iTags,iAlias);

    }];
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
}
-(void) saveData:(NSString *)studentID
        userName:(NSString *)userName
        password:(NSString *)password
       otherInfo:(NSDictionary *)info{
    [[Account shared]setStudentLongID:studentID];
    [[Account shared]setStudentShortID:userName];
    [[Account shared]setPassword:password];
    NSDictionary *o1 =@{@"ec":@"1032",
                        @"studentID": studentID};
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
            //CirnoLog(@"json!%@",json);
            [self saveOtherInfo:json[@"info"]];
            //1.创建队列组
            dispatch_group_t group = dispatch_group_create();
            //2.创建队列
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

            //3.多次使用队列组的方法执行任务, 只有异步方法
            //3.1.执行3次循环
            dispatch_group_async(group, queue, ^{
                // [self mirrorServer:studentID userName:userName password:password];
                UserModel* currentUser = [[UserModel alloc]init];
                currentUser.test = YES;
                [currentUser getUserModel:studentID];

              //  [[Account shared]setProgram:currentUser.program];
              //  CirnoLog(@"%@",currentUser.program);
            });


            [self toHomeController];
        }
        else{
            [self showWhenLoginFailed];

        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        [self showConnectFailed];
    }];

}

-(void) KeyboardWillShowNotification:(NSNotification *)notification{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  //  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //Given size may not account for screen rotation
    
    //int height = MIN(keyboardSize.height,keyboardSize.width);
    [self.view setFrame:CGRectMake(0, -151, self.view.frame.size.width, self.view.frame.size.height)];
    [self.logoImageView removeFromSuperview];
}

-(void) KeyboardWillHideNotification:(NSNotification *)notification{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.logoImageView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (int i = 0; i<2; i++)
    {
        UITextField * textField = (UITextField *)[self.view viewWithTag:10000+i];
        [textField resignFirstResponder];
    }
}


-(void)keyboardWillShow:(NSNotification *)notif
{
    if (_isHide)
    {
        _isHide = NO;
        CGFloat sHeight = (120/667.0)*Height;
        NSDictionary *userInfo = [notif userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        POPBasicAnimation * basicAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        basicAnimation1.toValue = @(-height+10);
        basicAnimation1.duration = keyboardDuration - 0.05;
        basicAnimation1.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [_bottomView.layer pop_addAnimation:basicAnimation1 forKey:@"up1"];
        
        POPBasicAnimation * decayAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        if (Height == 568)
        {
            decayAnimation2.toValue = @(-sHeight/2.0-30);
        }
        else
        {
            decayAnimation2.toValue = @(-sHeight/2.0);
        }
        decayAnimation2.duration = keyboardDuration - 0.05;
        decayAnimation2.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [_logoView.layer pop_addAnimation:decayAnimation2 forKey:@"up2"];
        
        POPBasicAnimation * decayAnimation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        decayAnimation3.toValue = @(-(height - sHeight));
        decayAnimation3.duration = keyboardDuration - 0.05;
        decayAnimation3.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [_midView.layer pop_addAnimation:decayAnimation3 forKey:@"up3"];
    }
    
}
-(void)keyboardWillHide:(NSNotification *)notif
{
    
    if (!_isHide)
    {
        _isHide = YES;
        POPBasicAnimation * decayAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        decayAnimation1.toValue = @(0);
        decayAnimation1.duration = 0.5;
        [_bottomView.layer pop_addAnimation:decayAnimation1 forKey:@"down1"];
        
        POPBasicAnimation * decayAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        decayAnimation2.toValue = @(0);
        decayAnimation2.duration = 0.5;
        [_logoView.layer pop_addAnimation:decayAnimation2 forKey:@"down2"];
        
        POPBasicAnimation * decayAnimation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        decayAnimation3.toValue = @(0);
        decayAnimation3.duration = 0.5;
        [_midView.layer pop_addAnimation:decayAnimation3 forKey:@"down3"];
    }
}



@end
#pragma clang diagnostic pop
