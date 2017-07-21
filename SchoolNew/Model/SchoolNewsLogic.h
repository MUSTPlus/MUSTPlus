//
//  SchoolNewsLogic.h
//  MUST_Plus
//
//  Created by zbc on 16/11/16.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolNewModel.h"
#import "SchoolCoreDataManagement.h"

@interface SchoolNewsLogic : NSObject


+(NSMutableArray *) pullDownToRefresh:(NSMutableArray *)oldNews
                         reciveNews:(id)json;

//2.上拉加载
+(NSMutableArray *) pullUpToRefresh:(NSMutableArray *)oldNews
                         reciveNews:(id)json;

+(NSMutableArray *) getNewsFromCoreData;

+(void) deleteALL;

@end
