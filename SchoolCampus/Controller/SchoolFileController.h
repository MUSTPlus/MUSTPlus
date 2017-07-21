//
//  SchoolFileController.h
//  MUSTPlus
//
//  Created by Cirno on 2017/7/4.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolFile.h"

@interface SchoolFileController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableview;
@property (nonatomic,strong) NSMutableArray <SchoolFile*>* files;

@end
