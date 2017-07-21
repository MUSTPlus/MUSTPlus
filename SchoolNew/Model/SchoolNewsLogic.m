//
//  SchoolNewsLogic.m
//  MUST_Plus
//
//  Created by zbc on 16/11/16.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolNewsLogic.h"
#import "School_news+CoreDataClass.h"
#import "SchoolNewModel.h"

@implementation SchoolNewsLogic




//0.拿数据
+(NSMutableArray *) getNewsFromCoreData{
    
    
    NSMutableArray *newsReturn = [[NSMutableArray alloc] init];
    
    SchoolCoreDataManagement *magege =  [[SchoolCoreDataManagement alloc] init];

    NSMutableArray *coreNew = [[NSMutableArray alloc] init];
    
    coreNew = [magege selectData:0 andOffset:0];
    
    for(School_news *schoolNew in coreNew){
        SchoolNewModel *a = [[SchoolNewModel alloc] init];
        [a setSchoolNewInfoData:schoolNew.schoolNewTitle SchoolNew_imageUrl:schoolNew.schoolNewImageUrl SchoolNew_describe:schoolNew.schoolNewDescribe SchoolNew_time:schoolNew.schoolNewTime SchoolNew_Tag:schoolNew.schoolNewTag SchoolNew_url:schoolNew.schoolNewUrl SchoolNew_label:schoolNew.schoolNewLabel SchoolNews_ID:schoolNew.schoolNewsID];
        [newsReturn addObject:a];
    }
    
    return newsReturn;
}




//1.下拉刷新
+(NSMutableArray *) pullDownToRefresh:(NSMutableArray *)oldNews
                         reciveNews:(id)json{
    
    SchoolCoreDataManagement *magege =  [[SchoolCoreDataManagement alloc] init];

    //if([json[@"news"][@"isthrow"] intValue]== 0){
        [oldNews removeAllObjects];
        [magege deleteData];
    //}//抛弃所有数据
    
    NSMutableArray *newsArray = [[NSMutableArray alloc] initWithArray:json[@"news"][@"contents"]];
    
    int count = (int)[newsArray count];
    
    for(int i=0;i<count;i++){
        SchoolNewModel *schoolNew = [[SchoolNewModel alloc] init];
        NSDictionary *schoolNewDic = [[NSDictionary alloc] init];
        schoolNewDic = [newsArray objectAtIndex:i];
        [schoolNew setSchoolNewInfoData:[schoolNewDic objectForKey:@"schoolNewTitle"]
                     SchoolNew_imageUrl:[schoolNewDic objectForKey:@"schoolNewImageUrl"]
                     SchoolNew_describe:[schoolNewDic objectForKey:@"schoolNewDescribe"]
                         SchoolNew_time:[schoolNewDic objectForKey:@"schoolNewTime"]
                          SchoolNew_Tag:[schoolNewDic objectForKey:@"schoolNewTag"]
                          SchoolNew_url:[schoolNewDic objectForKey:@"schoolNewUrl"]
                        SchoolNew_label:[schoolNewDic objectForKey:@"schoolNewLabel"]
                          SchoolNews_ID:[schoolNewDic objectForKey:@"schoolNewsID"]];
        
        [oldNews addObject:schoolNew];
    }
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"schoolNewsID" ascending:YES];
//    [newsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
//
    [magege insertCoreData:json[@"news"][@"contents"]];
    
    return oldNews;
}

//2.上拉加载
+(NSMutableArray *) pullUpToRefresh:(NSMutableArray *)oldNews
                           reciveNews:(id)json{
 
    SchoolCoreDataManagement *magege =  [[SchoolCoreDataManagement alloc] init];
    
    NSMutableArray *newsArray = json[@"news"][@"contents"];
    
    int count = (int)[newsArray count];
    
    for(int i=0;i<count;i++){
        SchoolNewModel *schoolNew = [[SchoolNewModel alloc] init];
        NSDictionary *schoolNewDic = [[NSDictionary alloc] init];
        schoolNewDic = [newsArray objectAtIndex:i];
        [schoolNew setSchoolNewInfoData:[schoolNewDic objectForKey:@"schoolNewTitle"]
                     SchoolNew_imageUrl:[schoolNewDic objectForKey:@"schoolNewImageUrl"]
                     SchoolNew_describe:[schoolNewDic objectForKey:@"schoolNewDescribe"]
                         SchoolNew_time:[schoolNewDic objectForKey:@"schoolNewTime"]
                          SchoolNew_Tag:[schoolNewDic objectForKey:@"schoolNewTag"]
                          SchoolNew_url:[schoolNewDic objectForKey:@"schoolNewUrl"]
                        SchoolNew_label:[schoolNewDic objectForKey:@"schoolNewLabel"]
                          SchoolNews_ID:[schoolNewDic objectForKey:@"schoolNewsID"]];
        
        [oldNews addObject:schoolNew];
    }
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"schoolNewsID" ascending:YES];
    //    [newsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    //
    [magege insertCoreData:json[@"news"][@"contents"]];
    
    return oldNews;
}

+(void) deleteALL{
    SchoolCoreDataManagement *magege =  [[SchoolCoreDataManagement alloc] init];
    [magege deleteData];
}
//3.删除数据


//4.拿数据


@end
