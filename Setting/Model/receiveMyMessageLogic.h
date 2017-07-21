//
//  receiveMyMessageLogic.h
//  MUST_Plus
//
//  Created by zbc on 17/1/7.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface receiveMyMessageLogic : NSObject

+(NSMutableArray *) pullDownToRefresh:(NSMutableArray *)oldNews
                           reciveNews:(id)json;

+(NSMutableArray *) pullUpToRefresh:(NSMutableArray *)oldNews
                         reciveNews:(id)json;

+(NSMutableArray *) getDataFromCoreData;


+(void)Addlike:(long long)ID
     studentID:(NSString *)String;

+(void)addComment:(long long)ID
          Comment:(NSMutableDictionary *)Stringl;

+(void)deleteMessage:(long long)ID;

+(NSMutableArray *) getMainBodyByMessageID:(long long)ID;

+(void) cancelLikeMessage:(long long)ID;

+(void) deleteComment:(NSString *)ID;

@end
