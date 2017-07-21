//
//  BaseStatusCellFrame.h
//  MUST_Plus
//
//  Created by Cirno on 19/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MainBody.h"
#import "UserModel.h"
#import "AvatarView.h"
#import "ImageListView.h"
@interface BaseStatusCellFrame : NSObject
{
    CGFloat _cellHeight; // Cell的高度
}

@property (nonatomic, strong) MainBody *status;

@property (nonatomic, readonly) CGFloat cellHeight;     // Cell的高度
@property (nonatomic, readonly) CGRect iconFrame;       // 头像的frame

@property (nonatomic, readonly) CGRect screenNameFrame; // 昵称
@property (nonatomic, readonly) CGRect mbIconFrame;     // 会员头像
@property (nonatomic, readonly) CGRect timeFrame;       // 时间
@property (nonatomic, readonly) CGRect sourceFrame;     // 来源
@property (nonatomic, readonly) CGRect textFrame;       // 内容
@property (nonatomic, readonly) CGRect imageFrame;      // 配图


@end
