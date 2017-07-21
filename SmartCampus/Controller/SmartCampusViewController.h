//
//  SmartCampusViewController.h
//  Currency
//
//  Created by Cirno on 12/01/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicHead.h"
#import "Smart.h"
@interface SmartCampusViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) Smart* data;
@property (nonatomic,strong) NSString *content;
@end
