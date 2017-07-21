//
//  MessageSendViewController.h
//  MUST_Plus
//
//  Created by zbc on 17/1/8.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQPhotoPickerViewController.h"


//这个delegate PUSH成功后
@protocol PushSuccessDelegate
-(void)pushMessageSuccess;
-(void)pushMessageFail;
@end

@interface MessageSendViewController :  LQPhotoPickerViewController<UITextViewDelegate>


@property (nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIView *noteTextBackgroudView;
//备注
@property(nonatomic,strong) UITextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;

//文字说明
@property(nonatomic,strong) UILabel *explainLabel;

//提交按钮
@property(nonatomic,strong) UIButton *submitBtn;

@property(assign,nonatomic) id<PushSuccessDelegate> pushSuccessDelegate;

@end
