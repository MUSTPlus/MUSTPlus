//
//  messageDetailViewController.h
//  MUST_Plus
//
//  Created by zbc on 16/10/25.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageDetailHeaderView.h"
#import "StatusCell.h"
#import "ButtonDock.h"
#import "BasicHead.h"
#import "MainBody.h"
#import "MessageDetailCellFrame.h"
#import "messageDetailTableViewCell.h"
#import "ChatKeyBoard.h"
#import "NSString+AES.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "receivceMessageLogic.h"
#import "Account.h"
#import "CirnoError.h"
#import "UserDetailsController.h"
#import "Alert.h"
#import "BasicHead.h"
#import "FaceSourceManager.h"
@interface messageDetailViewController : UIViewController<MessageDetailHeadAddButtonDelegate,UITableViewDelegate,UITableViewDataSource,UserDetailsDelegate,ChatKeyBoardDataSource>

@property (nonatomic,strong) messageDetailHeaderView * msgHeadView;
@property (nonatomic,strong) StatusCell* tcell;
@property (nonatomic,strong) MainBody *mainBody;
@property (nonatomic,strong)UITableView * tableView;


@end
