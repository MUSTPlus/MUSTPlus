//
//  CourseDetailViewController.h
//  Currency
//
//  Created by Cirno on 02/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Course.h"
#import "BasicHead.h"
#import "Account.h"
#import "TeacherViewController.h"
#import "Teacher.h"
#import "CourseComment.h"
@interface CourseDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) Course* course;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray<NSString*>* teachers;
@property (nonatomic,strong) NSMutableDictionary<NSString*,NSString*>* average;
@property (nonatomic,strong) NSString* DateAndTime;
@property (nonatomic,strong) NSString* Room;
@property (nonatomic,strong) NSString* Class;
@property (nonatomic,strong) NSString* str;
@property (nonatomic,strong) NSString* time;
@property (nonatomic,strong) UITextField* typecomment;
@property (nonatomic,strong) NSMutableArray<CourseComment*>* comments;
@property (nonatomic) CGRect baseFrame;
@property (nonatomic) CGRect changeFrame;
@property int now;
@property BOOL sendPermission;
@property BOOL isBack;
@property BOOL ok;
@end
