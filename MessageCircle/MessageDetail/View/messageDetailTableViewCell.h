//
//  messageDetailTableViewCell.h
//  MUST_Plus
//
//  Created by zbc on 16/11/2.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusModel.h"
#import "UserModel.h"
#import "MessageDetailCellFrame.h"
#import "CommentDetails.h"


@protocol DeleteDelegate
-(void)Clickdelete:(NSString *)ID;
@end


@interface messageDetailTableViewCell : UITableViewCell

@property (nonatomic,strong)  MessageDetailCellFrame *cellFrame;    //Frame数值
@property (assign,nonatomic) id <UserDetailsDelegate> avatarDelegate;
@property (assign,nonatomic) id <DeleteDelegate> deleteDelegate;

@end
