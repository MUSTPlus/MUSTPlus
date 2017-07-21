//
//  GradeCoreDateManager.h
//  MUST_Plus
//
//  Created by zbc on 16/10/9.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MyGrade+CoreDataClass.h"
#import "AppDelegate.h"

@interface GradeCoreDateManager : NSObject
#define TableName @"MyGrade"

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
