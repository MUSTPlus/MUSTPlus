//
//  AttendanceHistoryTableViewController.h
//  MUSTPlus
//
//  Created by Cirno on 2017/8/16.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendanceHistory.h"
#import "Account.h"
@interface AttendanceHistoryTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray<AttendanceHistory*>* history;

@end
