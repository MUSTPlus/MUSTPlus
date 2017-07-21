//
//  MyMessageCoreDataManagement.h
//  MUST_Plus
//
//  Created by zbc on 17/1/7.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MyMessageCircle_comments+CoreDataClass.h"
#import "MyMessageCircle_main+CoreDataClass.h"
#import "AppDelegate.h"

@interface MyMessageCoreDataManagement : NSObject


#define TableName @"MyMessageCircle_main"
#define relationshipTableName @"MyMessageCircle_comments"

@property(nonatomic,retain) AppDelegate* myAppDelegate;

////插入数据
- (void)insertCoreData:(NSMutableDictionary *)MessageDataArray
      commentDataArray:(NSMutableArray *)commentsDataArray;////查询


- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;

////删除
- (void)deleteData;

////更新like
- (void)updateLike:(NSString*)someThing  withString:(NSString*)string;

//插入Comment
- (void)updateComment:(NSString*)someThing  withComment:(NSMutableDictionary *)commentInfo;

//查询某个MESSAGE
-(NSMutableArray*)messageID:(NSString *)ID;

//删除朋友圈
-(void) deleteDataByID:(NSString *)ID;

//点赞
-(void) likeMessage:(NSString *)ID;

//取消点赞
-(void) cancelMessage:(NSString *)ID;

-(void) deleteCommetByMessageID:(NSString *)commentID;


@end
