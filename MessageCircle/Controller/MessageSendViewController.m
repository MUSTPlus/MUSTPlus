//
//  MessageSendViewController.m
//  MUST_Plus
//
//  Created by zbc on 17/1/8.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "MessageSendViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AFNetworking.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "Alert.h"
#import "WSGetPhoneTypeController.h"
#import "JDStatusBarNotification.h"
#import "AliDataManagement.h"
#import "CirnoError.h"
#import "Account.h"
#import "BasicHead.h"


#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度

@interface MessageSendViewController ()<LQPhotoPickerViewDelegate,UIAlertViewDelegate,UploadSuccessDelegate,AlertDelegate>
{
    //备注文本View高度
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
}

@end

@implementation MessageSendViewController
- (void)alertView:(Alert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:95.0/255.0 green:167.0/255.0 blue:241.0/255.0 alpha:1]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:NSLocalizedString(@"取消",
                                                                                                    "") titleColor:[UIColor whiteColor] target:self action:@selector(cancelBtnClick)];
    
    self.navigationItem.title = NSLocalizedString(@"发送校友圈", "");
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    /**
     *  依次设置
     */
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    self.LQPhotoPicker_superView = _scrollView;
    
    self.LQPhotoPicker_imgMaxCount = 9;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    
    [self initViews];

}


- (void)cancelBtnClick {
    //[self.textView endEditing:YES];
    if ([self checkInput]){
        Alert *alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"提示", "") message:NSLocalizedString(@"放弃编辑", "") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"取消", ""),NSLocalizedString(@"确定", ""), nil];
        [alert show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)viewTapped{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"caseLogNeedRef" object:nil];
}

- (void)initViews{
    
    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    _noteTextView = [[UITextView alloc]init];
    _noteTextView.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:14];
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = @"0/120    ";
    
    _explainLabel = [[UILabel alloc]init];
    _explainLabel.text = NSLocalizedString(@"发送校友圈说明", "");
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:NSLocalizedString(@"发送", "") forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:155.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:_noteTextBackgroudView];
    [_scrollView addSubview:_noteTextView];
    [_scrollView addSubview:_textNumberLabel];
    [_scrollView addSubview:_explainLabel];
    [_scrollView addSubview:_submitBtn];
    
    [self updateViewsFrame];
}
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 0, SCREENWIDTH - 30, noteTextHeight);
    
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
    
    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    
    //说明文字
    _explainLabel.frame = CGRectMake(0, [self LQPhotoPicker_getPickerViewFrame].origin.y+[self LQPhotoPicker_getPickerViewFrame].size.height+10, SCREENWIDTH, 20);
    
    
    //提交按钮
    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    
    
    allViewHeight = noteTextHeight + [self LQPhotoPicker_getPickerViewFrame].size.height + 30 + 100;
    
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/120    ",(unsigned long)_noteTextView.text.length];
    if (_noteTextView.text.length > 120) {
        _textNumberLabel.textColor = [UIColor redColor];
        _submitBtn.enabled = NO;
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        _submitBtn.enabled = YES;
    }
    
    [self textChanged];
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/120    ",(unsigned long)_noteTextView.text.length];
    
    if (_noteTextView.text.length > 100 && _noteTextView.text.length <= 120) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else if(_noteTextView.text.length > 120){
        _noteTextView.text = [_noteTextView.text substringToIndex:120];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }
    [self updateViewsFrame];
}

- (void)submitBtnClicked{
    if ([[[Account shared] getNickname] isEqual:@"MR/MRS"]){
        [CirnoError ShowErrorWithText:NSLocalizedString(@"更改昵称", "")];
        return;
    }
    if (![self checkInput]) {
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"内容不能为空", "") dismissAfter:2];
        return;
    }
    if (_noteTextView.text.length>120){
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"大于字数限制", "") dismissAfter:2];
        return;
    }
    [self submitToServer];
}

#pragma maek - 检查输入
- (BOOL)checkInput{
    if (_noteTextView.text.length == 0) {
        //MBhudText(self.view, @"请添加记录备注", 1);
        return NO;
    }
    return YES;
}


#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    _submitBtn.userInteractionEnabled = NO;
//    NSMutableArray *bigImageArray = [self LQPhotoPicker_getBigImageArray];
    //大图数据
    NSMutableArray *bigImageDataArray = [self LQPhotoPicker_getBigImageDataArray];
//    
//    //小图数组
//    NSMutableArray *smallImageArray = [self LQPhotoPicker_getSmallImageArray];
//    
//    //小图数据
//    NSMutableArray *smallImageDataArray = [self LQPhotoPicker_getSmallDataImageArray];
    
    [self send:bigImageDataArray];
    
}



- (void)LQPhotoPicker_pickerViewFrameChanged{
    [self updateViewsFrame];
}


#pragma mark -
- (void)send:(NSMutableArray *)bigImageDataArray{
    
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"上传中", "")];

    
    AliDataManagement *a = [[AliDataManagement alloc] init];
    a.uploadSuccessDelegate = self;
    [a setPucNum:(int)[bigImageDataArray count]];
    for(int i = 0; i<[bigImageDataArray count];i++){
        [a uploadImg:bigImageDataArray[i] name:i];
    }
    
    if([bigImageDataArray count] == 0){
        [self uploadSuccess:nil];
    }
}




#pragma mark - uploadSuccessDelegate 发送消息圈
-(void) uploadSuccess:(NSMutableArray *)nameArray{
    
    
    NSString *imageArray = @""; //图片数组
    if([nameArray count] > 0){
        imageArray = nameArray[0];
        if([nameArray count] == 1){
            imageArray = [NSString stringWithFormat:@"%@/%@",ImageURL,imageArray];
        }
        else{
            imageArray = [NSString stringWithFormat:@"%@/%@",ImageURL,imageArray];
            for(int i=1;i<[nameArray count];i++){
                imageArray = [NSString stringWithFormat:@"%@;%@/%@",imageArray,ImageURL,nameArray[i]];
            }
        }
    }
    
    
    NSString *phoneModel = [WSGetPhoneTypeController getPhoneModel];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate]; //发送时间
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1021",@"studentID":[[Account shared]getStudentLongID],@"imageArray":imageArray,@"messageContext" : _noteTextView.text,@"device" : phoneModel ,@"location" : @"三里墩",@"time" : dateString};
    
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
        [JDStatusBarNotification dismiss];
        [_pushSuccessDelegate pushMessageSuccess];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        [_pushSuccessDelegate pushMessageFail];
        [JDStatusBarNotification dismiss];
    }];
}


@end
