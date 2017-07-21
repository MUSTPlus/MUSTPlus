//
//  MyMessageDetailTableViewCell.h
//  MUST_Plus
//
//  Created by zbc on 17/1/8.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "ImageListView.h"
#import "UIImage+X.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "ButtonDock.h"
#import "AvatarView.h"
#import "BaseStatusCellFrame.h"

@interface MyMessageDetailTableViewCell : UITableViewCell

@property (nonatomic,strong)  ButtonDock           *dock;            //底端控制条
@property (nonatomic,strong)  BaseStatusCellFrame *cellFrame;    //Frame数值
@property (assign,nonatomic) id <UserDetailsDelegate> avatarDelegate;

@end
