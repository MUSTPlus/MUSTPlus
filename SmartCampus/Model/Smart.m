//
//  Smart.m
//  Currency
//
//  Created by Cirno on 03/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "Smart.h"

@implementation Smart
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(instancetype)initWithjson:(NSString*)json{
    self = [super init];
    if (self){
        NSDictionary* dic = [self dictionaryWithJsonString:json];
        for (int i=0;i<[[dic allKeys]count];i++){
            SmartPlaceSet* t = [[SmartPlaceSet alloc]initWithDic:[dic allValues][i]
                                                   andName:[dic allKeys][i]
                             ];
            if (self.object == nil)
                self.object = [[NSMutableArray alloc]init];
            [self.object addObject:t];
        }
    }
    return self;
}
-(NSInteger)countOfObject{
    return [self.object count];
}
@end
