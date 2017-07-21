//
//  BCBookDetailTableViewController.h
//  MUSTBEE
//
//  Created by zbc on 15/10/23.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCBookLibrary.h"
@interface BCBookDetailTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BCBookLibrary *BookDetail;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@property (nonatomic,strong)  UIImage *backIcon;

@end
