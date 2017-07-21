//
//  MessageCircleController.h
//  MUST_Plus
//
//  Created by Cirno on 05/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageHeadView.h"
#import "StatusCell.h"
#import <MJRefresh.h>
#import "ButtonDock.h"
#import "messageDetailViewController.h"
#import "MessageSendViewController.h"

@interface MessageCircleController : UIViewController
<MessageHeadAddButtonDelegate,UITableViewDataSource,UITableViewDelegate,DockDelegate,PushSuccessDelegate,UIScrollViewDelegate,UIActionSheetDelegate>;
@property (nonatomic,strong) MessageHeadView * msgHeadView;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic) BOOL down;
@property (nonatomic) BOOL up;
//---修改，加了个array以后方便刷新数据什么的---
@property (nonatomic,strong) NSMutableArray<MainBody *> *mainBodyArray;
//@property (nonatomic,strong) ButtonDock *dock;


- (void)refreshData;

-(void)Avatar;
@end


