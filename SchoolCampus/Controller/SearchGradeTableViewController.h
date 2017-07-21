//
//  SearchGradeTableViewController.h
//  MUST_Plus
//
//  Created by zbc on 16/10/9.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeCoreDateManager.h"
#import "MyGrade+CoreDataClass.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface SearchGradeTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong)  UIImage *backIcon;
@property (nonatomic,strong) UIBarButtonItem *backButton;

@end
