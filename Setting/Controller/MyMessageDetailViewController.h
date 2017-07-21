//
//  MyMessageDetailViewController.h
//  MUST_Plus
//
//  Created by zbc on 17/1/8.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageDetailHeaderView.h"
#import "StatusCell.h"
#import "ButtonDock.h"
#import "BasicHead.h"
#import "MainBody.h"


@interface MyMessageDetailViewController : UIViewController<MessageDetailHeadAddButtonDelegate,UITableViewDelegate,UITableViewDataSource,UserDetailsDelegate>

@property (nonatomic,strong) messageDetailHeaderView * msgHeadView;
@property (nonatomic,strong) StatusCell* tcell;
@property (nonatomic,strong) MainBody *mainBody;
@property (nonatomic,strong)UITableView * tableView;

@end
