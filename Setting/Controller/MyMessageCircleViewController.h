//
//  MyMessageCircleViewController.h
//  MUST_Plus
//
//  Created by zbc on 17/1/7.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMessageHeader.h"
#import "ButtonDock.h"
#import "BasicHead.h"
#import "MainBody.h"
#import "MyMessageDetailTableViewCell.h"

@interface MyMessageCircleViewController : UIViewController<MyMessageDetailHeadAddButtonDelegate,UITableViewDelegate,UITableViewDataSource,DockDelegate>

@property (nonatomic,strong) MyMessageHeader * msgHeadView;
@property (nonatomic,strong) NSMutableArray<MainBody *> *mainBodyArray;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) MyMessageDetailTableViewCell* tcell;
@property (nonatomic,strong) NSString* studentID;

@end
