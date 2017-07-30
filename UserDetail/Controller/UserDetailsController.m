//
//  UserDetailsController.m
//  MUST_Plus
//
//  Created by Cirno on 30/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//  用户详细页
//  模仿（chaoxi)QQ
//
//
#import "UserDetailsController.h"
#import "UserDetailCellTableViewCell.h"
#import "BasicHead.h"
#import "ZoomHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Alert.h"
#import "Account.h"
#import "CirnoError.h"
#import "AFNetworking.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "MyMessageCircleViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "MLSelectPhotoBrowserViewController.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AliDataManagement.h"
#import "PhotoViewController.h" //选择头像
#import <SDWebImage/UIImageView+WebCache.h>
#import "GPUImage.h"
#define bottomHeight 50
#define HeightofUserDeatils 200
#define AvatarHeight   100
#define sayFont [UIFont systemFontOfSize:10]

#define nicknameFont [UIFont boldSystemFontOfSize:17]


@interface UserDetailsController()<UITableViewDelegate,UITableViewDataSource,UploadSuccessDelegate,UITextFieldDelegate,PhotoViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIImageView* avatar;
@property (nonatomic,strong) UITextField* nickname;
@property (nonatomic,strong) UILabel* say;
@property (nonatomic,strong) UIImage* honor;
@property (nonatomic,strong) UIImage* major;
@property (nonatomic,strong) UIButton* backbutton;
@property (nonatomic,strong) ZoomHeaderView* headview;
@property (nonatomic,strong) UITableView *tableview1;
@property (nonatomic,strong) UILabel* information;
@property (nonatomic,strong) UIView* navibar;
@property (nonatomic,strong) UIView* bottom;
@property (nonatomic,strong) UIButton* changesay;
@property (nonatomic,strong) UIButton* privacy;
@property (nonatomic,strong) UIImageView* gender;

@end
static CGRect oldframe;
@implementation UserDetailsController{
    AliDataManagement *aliDataManagement;
    BOOL changeFace;
    BOOL changeBG;
}

-(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)showBigAvatar{
    [self showImage:_avatar];
}

-(void)showBGImage{
    [self showImage:[_headview getImage]];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
#pragma mark -  UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.oldImage = image;
    photoVC.mode = PhotoMaskViewModeCircle;
    photoVC.cropWidth = CGRectGetWidth(self.view.bounds) - 80;
    photoVC.isDark = YES;
    photoVC.delegate = self;
    [picker pushViewController:photoVC animated:YES];
}

- (void)imageCropperDidCancel:(PhotoViewController *)cropperViewController
{
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}
- (UIImage *)blurryGPUImage:(UIImage *)image withBlurLevel:(CGFloat)blur {

    // 高斯模糊
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = blur;
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];

    return blurredImage;
}
- (void)imageCropper:(PhotoViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    //修改头像完成
    NSData *imageData = UIImageJPEGRepresentation(editedImage,0.5);
    [aliDataManagement uploadAvatar:imageData name:0];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        CATransition *animation = [CATransition animation];
        animation.duration = 0.4f;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromBottom;
        [_avatar.layer addAnimation:animation forKey:nil];
        [_avatar setImage:editedImage];
       // NSLog(@"%f,%f",editedImage.size.width,editedImage.size.height);
        
    }];
}

// delegate 结束
-(void)back1{
    if(_isSelf){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)report{
    Alert *a = [[Alert alloc]initWithTitle:@"提示" message:@"举报成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", "") otherButtonTitles: nil];
    [a show];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setHidden:YES];

    changeFace = false;
    changeBG = false;
    //_currentUser = [[UserModel alloc]getUserModel:_studID];
    //self.navigationController.title = NSLocalizedString(@"我的资料", "");
    aliDataManagement = [[AliDataManagement alloc] init];
    aliDataManagement.uploadSuccessDelegate = self;
    [aliDataManagement setPucNum:1];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_isSelf){
        _headview = [[ZoomHeaderView alloc] initWithFrame:CGRectMake(0, NavBarHeight, Width, HeightofUserDeatils) andImage:
                     [[Account shared]getBgImage]
                    ];
    } else {
        _headview = [[ZoomHeaderView alloc] initWithFrame:CGRectMake(0, NavBarHeight, Width, HeightofUserDeatils) andImage:
                     _currentUser.bgURL];
    }
   



    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionSheet1)];
    tap1.delegate = self;
    [_headview addGestureRecognizer:tap1];
    
    
    _navibar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, NavBarHeight)];
    _navibar.backgroundColor = sidebarBackGroundColor;
    _backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, StatusBarHeight, 80, NavBarHeight-StatusBarHeight)];
    // _backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _information = [[UILabel alloc]initWithFrame:CGRectMake(0, StatusBarHeight, Width, NavBarHeight-StatusBarHeight)];
    _information.text = _isSelf?NSLocalizedString(@"我的资料", ""):NSLocalizedString(@"资料", "");
    self.navigationController.title= _isSelf?NSLocalizedString(@"我的资料", ""):NSLocalizedString(@"资料", "");
    _information.textAlignment = NSTextAlignmentCenter;
    _information.textColor = [UIColor whiteColor];
    [_navibar addSubview:_information];
    [_backbutton setTitle:UIKitLocalizedString(@"Done") forState:UIControlStateNormal];
    [_backbutton addTarget:self action:@selector(back1) forControlEvents:UIControlEventTouchDown];
    if (!_isSelf){
//        UIButton* report1 = [[UIButton alloc]initWithFrame:CGRectMake(Width-40, StatusBarHeight+7.5, 25, 25)];
//        NSLog(@"%@",report1);
//        report1.contentMode=UIViewContentModeScaleAspectFit;
//      //  report1.backgroundColor=[UIColor redColor];
//        [report1 setImage:[UIImage imageNamed:@"report"] forState:UIControlStateNormal];
//        [report1 addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchDown];
//        [_navibar addSubview:report1];
    }
    if (!_naviGo){
    [_navibar addSubview:_backbutton];
        [self.view addSubview:_navibar];
        self.navigationController.navigationBarHidden=YES;
    } else {
        self.navigationController.navigationBarHidden=NO;
    }

    _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-AvatarHeight/2, HeightofUserDeatils-AvatarHeight/2, 100, 100)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionSheet)];
    tap.delegate = self;
    [_avatar addGestureRecognizer:tap];
    
    [_avatar setUserInteractionEnabled:YES];
    _nickname = [[UITextField alloc]initWithFrame:CGRectMake(0, AvatarHeight/2+HeightofUserDeatils, Width, 25)];
    _nickname.userInteractionEnabled = NO;
    _nickname.textColor =[UIColor blackColor];
    _nickname.textAlignment=NSTextAlignmentCenter;
    _nickname.font = nicknameFont;
    _nickname.delegate = self;

   // _gender.image = [_currentUser.gender isEqual: @"男"] ? [UIImage imageNamed:@"male"] : [UIImage imageNamed:@"female"];
    _say =[[UILabel alloc]initWithFrame:CGRectMake(20, AvatarHeight/2+HeightofUserDeatils+_nickname.frame.size.height, Width-40, 25)];
    //[_nickname addSubview:_gender];

    _say.textColor = [UIColor blackColor];
    _say.textAlignment =NSTextAlignmentCenter;
    _say.numberOfLines = 0;
    _say.font =sayFont;
    _say.text = (_currentUser.whatsup ==nil)?_currentUser.whatsup:@"";
    
    // _avatar.backgroundColor = [UIColor redColor];
    _avatar.contentMode =  UIViewContentModeScaleAspectFit;
    _avatar.clipsToBounds =YES;
    _avatar.layer.cornerRadius = _avatar.frame.size.width /2;
    _avatar.layer.masksToBounds =YES;
    // [_avatar sd_setImageWithURL:[NSURL URLWithString:_currentUser.avatarPicURL]placeholderImage:[UIImage imageNamed:@"akarin.png"]];
    //_avatar.image = [UIImage imageNamed:@"akarin.png"];
    

    
    CALayer * layer = [_avatar layer];
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.borderWidth = 2.0f;
    //添加四个边阴影
    _avatar.layer.shadowColor = [UIColor blackColor].CGColor;
    _avatar.layer.shadowOffset = CGSizeMake(0, 0);
    _avatar.layer.shadowOpacity = 0.5;
    _avatar.layer.shadowRadius = 10.0;
    [_avatar.layer setMasksToBounds:YES];
    [_avatar.layer setBorderWidth:2];
    [_avatar.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    _tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, Width, Height-20) style:UITableViewStylePlain];
    [self.view addSubview:_tableview1];
  //  self.navigationController.navigationBarHidden=YES;
    // [self.view addSubview:headerView];
    
    [_headview addSubview:_nickname];
    [_headview addSubview:_avatar];
    [_headview addSubview:_say];
    _tableview1.tableHeaderView = _headview;
    
    //self.headview =_headview;
    
    _tableview1.delegate=self;
    _tableview1.dataSource = self;
    _tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // [self.tableview1.tableHeaderView addSubview:_nickname];
    //[self.tableview1.tableHeaderView addSubview:_avatar];
    // [self.tableview1.tableHeaderView addSubview:_say];
    

    if (_isSelf){
        _bottom = [[UIView alloc]initWithFrame:CGRectMake(0, Height-bottomHeight, Width, bottomHeight)];
        _bottom.backgroundColor = kColor(247, 247, 249);
        _changesay = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, Width/2-20, bottomHeight-10)];
        [_changesay setTitle:NSLocalizedString(@"修改资料", "") forState:UIControlStateNormal];
        [_changesay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changesay.layer.borderColor = kColor(195, 200, 204).CGColor;
        _changesay.backgroundColor = sidebarBackGroundColor;
        // _changesay.layer.borderWidth = 1.0f;
        _changesay.layer.cornerRadius = 3;
        _privacy = [[UIButton alloc]initWithFrame:CGRectMake(Width/2, 5, Width/2-20, bottomHeight-10)];
        [_privacy setTitle:NSLocalizedString(@"隐私", "") forState:UIControlStateNormal];
        [_privacy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _privacy.layer.borderColor = kColor(195, 200, 204).CGColor;
        _privacy.layer.borderWidth = 1.0f;
        _privacy.layer.cornerRadius = 3;
        _privacy.backgroundColor = [UIColor whiteColor];
        [_bottom addSubview:_privacy];
        [_bottom addSubview:_changesay];
        [_privacy addTarget:self action:@selector(privacyShow) forControlEvents:UIControlEventTouchDown];
        [_changesay addTarget:self action:@selector(changeQianming) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_bottom];
    }

}


-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden =NO;
}

-(void)changeQianming{
    self.navigationController.navigationBarHidden=NO;
    UserChangeDetailsController* ucdc = [[UserChangeDetailsController alloc]init];
    ucdc.usrmodel=_currentUser;
    [self.navigationController pushViewController:ucdc animated:YES];
}

-(void)privacyShow{
    Alert *alert = [[Alert alloc] initWithTitle:NSLocalizedString(@"提示", @"") message:NSLocalizedString(@"隐私提示", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"好", @"") otherButtonTitles: nil];
    alert.contentAlignment =NSTextAlignmentLeft;
    [alert show];


}
-(void)updateByUsrModel:(UserModel*)usrModel{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _say.text = usrModel.whatsup;
        _nickname.text = usrModel.nickname;
        [_avatar sd_setImageWithURL:[NSURL URLWithString:usrModel.avatarPicURL]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if ([usrModel.bgURL length]==0){
                UIImage * bg= [[UIImage alloc]init];
                bg = [self blurryGPUImage:_avatar.image withBlurLevel:10.0f];
                [_headview changeImage:bg];
            }
        }];
        NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:usrModel.nickname];
        UIColor* Color = usrModel.isVip == 1?[UIColor blackColor]:[UIColor redColor];

        [attri addAttribute:NSForegroundColorAttributeName value:Color range:NSMakeRange(0, [usrModel.nickname length])];
        [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, [usrModel.nickname length])];
        _gender = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2+[usrModel.nickname sizeWithAttributes:@{NSFontAttributeName:nicknameFont}].width/2+7.5, 5, 15, 15)];
        _gender.image = [usrModel.gender isEqual: @"男"] ? [UIImage imageNamed:@"male1"] : [UIImage imageNamed:@"female1"];
        [_nickname addSubview:_gender];
        _nickname.attributedText = attri;
        _currentUser = usrModel;
        if ([usrModel.bgURL length]==0){
            _headview.touXiang =YES;
            [_headview initUICodeConstraint:usrModel.avatarPicURL];
            
        }
        else
             [_headview initUICodeConstraint:usrModel.bgURL];
             [_headview addSubview:_avatar];
             [_tableview1 reloadData];
        _tableview1.contentOffset =CGPointMake(0, 1);

    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
    _tableview1.tableHeaderView = _headview;
    _say.text = @"";
    _nickname.text = @"";
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        UserModel* usrModel = [[UserModel alloc]init];
        NSDictionary *o1 =@{@"ec":@"1032",
                            @"studentID": _studID};
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
        @try {

              [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([json[@"state"] isEqualToString:@"1"]){
                @try {
                    NSDictionary *newjson = json[@"info"];
                    usrModel.studentID    = [newjson objectForKey:@"studentID"];
                    usrModel.avatarPicURL = [newjson objectForKey:@"face"] ;
                    usrModel.bgURL        = [newjson objectForKey:@"backgroundimage"] ;
                    usrModel.grade        = [newjson objectForKey:@"GradeType"] ;
                    usrModel.major        = [newjson objectForKey:@"MajorType"] ;
                    usrModel.whatsup      = [newjson objectForKey:@"signText"] ;
                    usrModel.nickname     = [newjson objectForKey:@"nickName"] ;
                    usrModel.isVip        = [[newjson objectForKey:@"isVip"]integerValue];
                    usrModel.program      = [newjson objectForKey:@"Program"];
                    usrModel.faculty      = [newjson objectForKey:@"Faculty"];
                    usrModel.gender       = [newjson objectForKey:@"Gender"];
                    if (usrModel.isVip == 2) usrModel.verifiedtype = kVerifiedTypeAdministrator;
                    NSInteger p = 1;
                    usrModel.verifiedtype = (usrModel.isVip == p)? kVerifiedTypeNone:kVerifiedTypeVIP;

                } @catch (NSException *exception) {
                    [CirnoError ShowErrorWithText:exception.description];
                }
                @finally{
                    if (usrModel.studentID!=nil)
                    _currentUser = usrModel;
                     dispatch_group_leave(group);
                }
            }
            else{
                [CirnoError ShowErrorWithText:NSLocalizedString(@"网络错误", "")];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [CirnoError ShowErrorWithText:[error localizedDescription]];
             dispatch_group_leave(group);
        }];

        } @catch (NSException *exception) {
            [CirnoError ShowErrorWithText:exception.description];
        } @finally {

        }


    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"model:%@",_currentUser.studentID);
        [self update];
    });
//
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(globalQueue, ^{
//        [self update];
//    });

}
-(void)update{
   // _currentUser = [[UserModel alloc]getUserModel:_studID];
    if (_currentUser == nil) return;
    [self updateByUsrModel:_currentUser];
}
-(void)viewDidAppear:(BOOL)animated{
  //  self.navigationController.navigationBarHidden=YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    [self.headview updateHeaderImageViewFrameWithOffsetY:offsetY];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
    // 用户账号
    // 年级 专业
    // 班级
    // 所发消息圈
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    NSInteger row = indexPath.row;
    // NSInteger column = indexPath.section;
    UserDetailCellTableViewCell *tcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (tcell == nil) {
        tcell = [[UserDetailCellTableViewCell alloc]init];
        
    }
    @try {


    switch (row) {

        case 2:

            if (!_isSelf){
                if (_currentUser.isVip==1)
                    break;
                else {
                    NSLog(@"vipis%ld",(long)_currentUser.isVip);
                    tcell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 44) andIcon:[UIImage imageNamed:@"UserIcon-1"]];
                    tcell.textLabel.textColor = [UIColor redColor];
                    if (_currentUser.isVip == 2){
                        tcell.textLabel.text = NSLocalizedString(@"管理员", "");
                    } else if (_currentUser.isVip == 3) {
                        tcell.textLabel.text =NSLocalizedString(@"IEEE MUST荣誉会员", "");
                    }
                    else if (_currentUser.isVip == 4){
                            tcell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(_currentUser.faculty, ""),NSLocalizedString(@"先驱者的荣耀", "")];

                    } else if (_currentUser.isVip!=1){

                        tcell.textLabel.text = NSLocalizedString(@"嘉宾", "");
                    }
                    break;
                }

            } else{
            tcell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 44) andIcon:[UIImage imageNamed:@"UserIcon-1"]];
           // tcell.textLabel.text = [[Account shared]getStudentLongID];
                tcell.textLabel.text = _currentUser.studentID;
                tcell.textLabel.adjustsFontSizeToFitWidth =YES;
            break;
            }
        case 3:{
            tcell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 44)andIcon:[UIImage imageNamed:@"MajorIcon"]];
            if (!_currentUser.grade){
                break;
            }
            NSString*gr =[[NSString alloc]init];
            if (!_isSelf)
                gr = [gr stringByAppendingFormat:@"%@ %@",[_currentUser.grade substringFromIndex:8],NSLocalizedString(_currentUser.major, "")];
            else
                gr = [gr stringByAppendingFormat:@"%@ %@ %@",[_currentUser.grade substringFromIndex:8],NSLocalizedString(_currentUser.major, ""),NSLocalizedString(_currentUser.program, "")];

            if ([gr isEqualToString:@"(null)"]){
                NSLog(@"yes is %@",gr);
                tcell.textLabel.text = @"";
                break;
            }
            tcell.textLabel.text =gr==nil?@"":gr;
            tcell.textLabel.adjustsFontSizeToFitWidth =YES;
            break;
        }
        case 4:
            tcell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 44) andIcon:[UIImage imageNamed:@"ClassIcon"]];
            tcell.textLabel.text = NSLocalizedString(_currentUser.faculty, "");
            tcell.textLabel.adjustsFontSizeToFitWidth =YES;
            if (_isSelf){
            if (_currentUser.isVip == 2){
                tcell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(_currentUser.faculty, ""),NSLocalizedString(@"管理员", "")];
            } else if (_currentUser.isVip == 3) {
                tcell.textLabel.text =[NSString stringWithFormat:@"%@ %@",NSLocalizedString(_currentUser.faculty, ""),NSLocalizedString(@"IEEE MUST荣誉会员", "")];
            } else if (_currentUser.isVip == 4){
                tcell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(_currentUser.faculty, ""),NSLocalizedString(@"先驱者的荣耀", "")];
            } else if (_currentUser.isVip!=1){
                tcell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(_currentUser.faculty, ""),NSLocalizedString(@"嘉宾", "")];
            }
            }
            break;
        case 5:
            tcell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 44) andIcon:[UIImage imageNamed:@"CircleIcon-2"]];
            tcell.textLabel.text =NSLocalizedString(@"校友圈", "");
            tcell.textLabel.adjustsFontSizeToFitWidth =YES;
            if (_currentUser.faculty == nil) tcell.userInteractionEnabled =NO ;
            break;
        default:
            tcell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
    }
    } @catch (NSException *exception) {
        [CirnoError ShowErrorWithText:[exception description]];
    } @finally {

    }
    return tcell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            [self ActionSheet];
            break;
            
        case 2:
            CirnoLog(@"点击用户名");
            //点击用户
            break;
        case 3:
            CirnoLog(@"点击专业");
            //点击专业
            break;
        case 4:
            CirnoLog(@"班级");
            //点击班级
            break;
        case 5:
            //点击
            [self ClickCircle];
            CirnoLog(@"消息圈");
            break;
    }
    
}
-(void)ClickCircle{
    MyMessageCircleViewController *a = [[MyMessageCircleViewController alloc] init];
    a.studentID=_currentUser.studentID;
    [self.navigationController pushViewController:a animated:YES];
}


- (void)ActionSheet
{
    [_nickname resignFirstResponder];
    _nickname.userInteractionEnabled = NO;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"头像","") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", "") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        //取消操作
    }];
    //UIAlertActionStyleDestructive有着重的意思，使用这个常量标题变为红色
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"查看大图","") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self showBigAvatar];
        //确定操作
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选择","") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //确定操作
        [self changeFace];
    }];

    [alertVC addAction:cancelAction];
    [alertVC addAction:firstAction];
    
    if(_isSelf){
        [alertVC addAction:secondAction];
        //    [alertVC addAction:thirdAction];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
-(void)didReceiveMemoryWarning{
    NSLog(@"内存警告！！");
}

-(void) changeFace{
        
    changeFace = true;
    changeBG = false;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}



-(void)uploadSuccess:(NSMutableArray *)nameArray{
    if(changeFace){
    NSDictionary *o1 =@{@"ec":@"1027",
                        @"studentID":[[Account shared]getStudentLongID],
                        @"face":[NSString stringWithFormat:@"%@/%@",ImageURL,nameArray[0]]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted
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
            [[Account shared]setAvatar:[NSString stringWithFormat:@"%@/%@",ImageURL,nameArray[0]]];
           // [[NSUserDefaults standardUserDefaults] setObject: forKey:@"face"];
        }
        else{

        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
    }];
    }
    else{
        NSDictionary *o1 =@{@"ec":@"1031",
                            @"studentID":[[Account shared] getStudentLongID],
                            @"backgroundimage":[NSString stringWithFormat:@"%@/%@",ImageURL,nameArray[0]]};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                           options:NSJSONWritingPrettyPrinted
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
                [[Account shared] setBgImage:[NSString stringWithFormat:@"%@/%@",ImageURL,nameArray[0]]];
            }
            else{
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [CirnoError ShowErrorWithText:[error localizedDescription]];
        }];
    }
    
}


- (void)ActionSheet1
{
    [_nickname resignFirstResponder];
    _nickname.userInteractionEnabled = NO;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"背景","") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", "") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        //取消操作
    }];
    //UIAlertActionStyleDestructive有着重的意思，使用这个常量标题变为红色
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"查看大图", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self showBGImage];
        //确定操作
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选择","") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //确定操作
        [self changeBGImage];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:firstAction];
    
    if(_isSelf){
        if(_currentUser.isVip>1)
        [alertVC addAction:secondAction];
        //    [alertVC addAction:thirdAction];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void) changeBGImage{
    
    
    changeFace = false;
    changeBG = true;
    
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    if(authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus ==ALAuthorizationStatusDenied){
        
        [[[UIAlertView alloc] initWithTitle:@"相册不可用"
                                    message:@"请在 设置 -> 隐私 -> 相册 中开启权限"
                                   delegate:self
                          cancelButtonTitle:@"我知道了"
                          otherButtonTitles:nil] show];
        
    }
    else{
        MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        [pickerVc setMaxCount:1];
        [pickerVc setStatus:PickerViewShowStatusCameraRoll];
        [pickerVc showPickerVc:self];
        [pickerVc setCallBack:^(NSArray *assets) {
            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage *photo = [MLSelectPhotoPickerViewController getImageWithObj:asset];
                NSData *imageData = UIImageJPEGRepresentation(photo,0.5);
                [aliDataManagement uploadBGImage:imageData name:0];
                [_headview changeImage:photo];
            }];
        }];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nickname) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    
    return YES;
}
@end
