//
//  SchoolClassCoreDataManager.h
//  MUST_Plus
//
//  Created by zbc on 16/11/9.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MyClass+CoreDataClass.h"
#import "AppDelegate.h"

@interface SchoolClassCoreDataManager : NSObject
#define TableName @"MyClass"

@property(nonatomic,retain) AppDelegate* myAppDelegate;

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray;
//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;
//删除
- (void)deleteData;
//更新
- (void)updateData:(NSString*)newsId withIsLook:(NSString*)islook;

@end
