//
//  SchoolSettingTableViewController.h
//  MUST_Plus
//
//  Created by zbc on 16/10/6.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@interface SchoolSettingTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) HeaderView *head;

@end
