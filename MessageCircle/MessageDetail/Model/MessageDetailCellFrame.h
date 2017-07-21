//
//  MessageDetailCellFrame.h
//  MUST_Plus
//
//  Created by zbc on 16/11/2.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommentDetails.h"
#import "UserModel.h"
#import "AvatarView.h"
@interface MessageDetailCellFrame : NSObject
{
    CGFloat _cellHeight; // Cell的高度
}


@property (nonatomic, strong) CommentDetails *status;

@property (nonatomic, readonly) CGFloat cellHeight;     // Cell的高度
@property (nonatomic, readonly) CGRect iconFrame;       // 头像的frame

@property (nonatomic, readonly) CGRect screenNameFrame; // 昵称
@property (nonatomic, readonly) CGRect mbIconFrame;     // 会员头像
@property (nonatomic, readonly) CGRect deleteIconFrame; // 删除按钮
@property (nonatomic, readonly) CGRect timeFrame;       // 时间
@property (nonatomic, readonly) CGRect sourceFrame;     // 来源
@property (nonatomic, readonly) CGRect textFrame;       // 内容


- (void) setStatus:(CommentDetails *) comemtDetail;


@end
