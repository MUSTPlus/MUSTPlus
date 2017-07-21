//
//  mailCoreDataManagement.m
//  MUST_Plus
//
//  Created by zbc on 16/11/23.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "mailCoreDataManagement.h"

@implementation mailCoreDataManagement


-(id)init{
    self = [super init];
    self.myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}


//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray
{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    for (NSDictionary *info in dataArray) {
        
        UserMail *mail = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:context];
        mail.title = [info objectForKey:@"title"];
        mail.mail = [info objectForKey:@"mail"];
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
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
    
    for (UserMail *info in fetchedObjects) {
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
//更新
- (void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook
{
    NSManagedObjectContext *context = self.myAppDelegate.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"newsid like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (UserMail *info in result) {
        info.mail = islook;
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}


@end
