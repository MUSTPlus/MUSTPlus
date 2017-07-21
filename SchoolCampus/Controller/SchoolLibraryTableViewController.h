//
//  SchoolLibraryTableViewController.h
//  MUSTBEE
//
//  Created by zbc on 15/10/20.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolLibraryTableViewController : UITableViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UIImage *backIcon;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@end
