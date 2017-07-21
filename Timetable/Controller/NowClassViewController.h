//
//  NowClassViewController.h
//  MUSTPlus
//
//  Created by Cirno on 20/04/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeiHei.h"
#import "Account.h"
#import "AFNetworking.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "CirnoError.h"
@interface NowClassViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSArray* myclass;
@property (nonatomic,strong) NSString*faculty;
@end
