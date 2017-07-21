 //
//  MessageCoreDataManagement.m
//  MUST_Plus
//
//  Created by zbc on 16/11/21.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "MessageCoreDataManagement.h"
#import "Account.h"

@implementation MessageCoreDataManagement

-(void)likeMessage:(NSString *)ID{
    
}
-(id)init{
    self = [super init];
    self.myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];    
    return self;
}


//插入数据,一条一条插入吧
- (void)insertCoreData:(NSMutableDictionary *)MessageDataArray
      commentDataArray:(NSMutableArray *)commentsDataArray
{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
        MessageCircle_main *message = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:context];
        message.messageID = [[MessageDataArray objectForKey:@"messageID"] stringValue];
        message.majorType = [MessageDataArray objectForKey:@"majorType"];
        message.isTop = [[MessageDataArray objectForKey:@"isTop"] stringValue];
        message.location = [MessageDataArray objectForKey:@"location"];
        message.imageArray = [MessageDataArray objectForKey:@"imageArray"];
        message.time = [MessageDataArray objectForKey:@"time"];
        message.isVip = [[MessageDataArray objectForKey:@"isVip"] stringValue];
        message.nickName  = [MessageDataArray objectForKey:@"nickName"];
        message.studentID  = [MessageDataArray objectForKey:@"studentID"];
        message.gradeType  = [[MessageDataArray objectForKey:@"gradeType"] stringValue];
        message.face  = [MessageDataArray objectForKey:@"face"];
        message.messageContext = [MessageDataArray objectForKey:@"messageContext"];
        message.device = [MessageDataArray objectForKey:@"device"];
    
        if([MessageDataArray objectForKey:@"like"] ==  [NSNull null])
            message.likes= @"";
        else
            message.likes = [MessageDataArray objectForKey:@"like"];

        for(NSMutableDictionary *commentInfo in commentsDataArray){
            MessageCircle_comments *a = [NSEntityDescription insertNewObjectForEntityForName:relationshipTableName inManagedObjectContext:context];
            a.commentID = [[commentInfo objectForKey:@"commentID"] stringValue];
            a.isReplyComment = [[commentInfo objectForKey:@"isReplyComment"] stringValue];
            a.face = [commentInfo objectForKey:@"face"];
            a.isVip = [[commentInfo objectForKey:@"isVip"] stringValue];
            a.replyCommentID = [commentInfo objectForKey:@"replyCommentID"];
            a.messageID = [[commentInfo objectForKey:@"messageID"] stringValue];
            a.messageContext = [commentInfo objectForKey:@"messageContext"];
            a.studentID = [commentInfo objectForKey:@"studentID"];
            a.nickName = [commentInfo objectForKey:@"nickName"];
            a.time = [commentInfo objectForKey:@"time"];
            [message addRelationshipObject:a];
        }
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
}


//查询所有
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage
{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    [fetchRequest setFetchLimit:pageSize]; //页面
    //    [fetchRequest setFetchOffset:currentPage];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (MessageCircle_main *info in fetchedObjects) {
        [resultArray addObject:info];
    }
    return resultArray;
}


//删除所有
-(void)deleteData
{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}


//更新Like
- (void)updateLike:(NSString*)someThing  withString:(NSString*)string
{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"messageID = %@",someThing];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    
    
    
    for (MessageCircle_main *info in result) {
        if (info.likes == NULL || [info.likes isEqualToString:@""])
            info.likes = [NSString stringWithFormat:@"%@",string];
        else
            info.likes = [NSString stringWithFormat:@"%@;%@",info.likes,string];
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}


//插入Comment
- (void)updateComment:(NSString*)someThing  withComment:(NSMutableDictionary *)commentInfo withCommentID:(long long)ID
{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"messageID = %@",someThing];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    MessageCircle_main *info = result[0];
    
    
    MessageCircle_comments *a = [NSEntityDescription insertNewObjectForEntityForName:relationshipTableName inManagedObjectContext:context];
    a.commentID = [NSString stringWithFormat:@"%lld",ID];
    a.isReplyComment = [commentInfo objectForKey:@"isReplyComment"];
    a.face = [commentInfo objectForKey:@"face"];
    a.isVip = [[commentInfo objectForKey:@"isVip"] stringValue];
    
    
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    
    a.time = currentDateString;
    a.replyCommentID = [commentInfo objectForKey:@"replyCommentID"];
    a.messageID = [commentInfo objectForKey:@"messageID"];
    a.messageContext = [commentInfo objectForKey:@"messageContext"];
    a.studentID = [commentInfo objectForKey:@"studentID"];
    a.nickName = [commentInfo objectForKey:@"nickName"];
    [info addRelationshipObject:a];
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}


//查询某个MESSAGE
- (NSMutableArray*)messageID:(NSString *)ID
{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"messageID = %@",ID];

    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    
    NSMutableArray *resultArray = [NSMutableArray array];
        
    for (MessageCircle_main *info in result) {
        [resultArray addObject:info];
    }
    
    return resultArray;
}

-(void) deleteDataByID:(NSString *)ID{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"messageID = %@",ID];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
    
}


//取消点赞
-(void) cancelMessage:(NSString *)ID{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"messageID = %@",ID];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj

    for (MessageCircle_main *info in result) {
        NSString *like = @"";
        NSArray *arr = [info.likes componentsSeparatedByString:@";"];
        if([arr count] == 1)
            info.likes = @"";
        
        else{
            for (NSString *a in arr){
               if([a isEqualToString:[[Account shared] getStudentLongID]])
                   continue;
               else
                   if([like  isEqual: @""])
                       like = [NSString stringWithFormat:@"%@",a];
                   else
                       like = [NSString stringWithFormat:@"%@;%@",like,a];
            }
            info.likes = like;
        }
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}


-(void) deleteCommetByMessageID:(NSString *)commentID{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"commentID = %@",commentID];
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:relationshipTableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

@end
