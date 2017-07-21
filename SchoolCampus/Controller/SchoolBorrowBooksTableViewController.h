//
//  SchoolBorrowBooksTableViewController.h
//  MUSTBEE
//
//  Created by zbc on 15/10/25.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BorrowBook.h"

@interface SchoolBorrowBooksTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) AppDelegate* myAppDelegate;
@property(nonatomic,strong) NSMutableArray<BorrowBook *> *Borrow_Books_Array;
@property (nonatomic,strong)  UIImage *backIcon;
@property (nonatomic,strong) UIBarButtonItem *backButton;

@end
