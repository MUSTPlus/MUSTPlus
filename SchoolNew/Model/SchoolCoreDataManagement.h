//
//  SchoolCoreDataManagement.h
//  MUST_Plus
//
//  Created by zbc on 16/11/14.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "School_news+CoreDataClass.h"
#import "AppDelegate.h"

@interface SchoolCoreDataManagement : NSObject

#define TableName @"School_news"

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
