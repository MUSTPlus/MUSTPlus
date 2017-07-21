//
//  StatusCell.h
//  MUST_Plus
//
//  Created by Cirno on 19/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//  这个View是用来显示每条消息圈的。
//  

#import <UIKit/UIKit.h>

#import "ImageListView.h"
#import "UIImage+X.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "ButtonDock.h"
#import "AvatarView.h"
#import "BaseStatusCellFrame.h"
@interface StatusCell : UITableViewCell
@property (nonatomic,strong)  ButtonDock           *dock;            //底端控制条
@property (nonatomic,strong)  BaseStatusCellFrame *cellFrame;    //Frame数值
@property (assign,nonatomic) id <UserDetailsDelegate> avatarDelegate;
@end
