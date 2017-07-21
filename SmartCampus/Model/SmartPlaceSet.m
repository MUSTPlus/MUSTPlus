//
//  SmartPlaceSet.m
//  
//
//  Created by Cirno on 03/02/2017.
//
//

#import "SmartPlaceSet.h"

@implementation SmartPlaceSet
-(NSInteger)countOfPlaces{
    return [self.places count];
}
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
-(void)addPlace:(SmartPlace *)object{
    if (self.places == nil)
        self.places = [[NSMutableArray alloc]init];
    [self.places addObject:object];
}
-(instancetype)initWithDic:(NSDictionary*)Dic
                    andName:(NSString*)name{
    self = [super init];
    if (self){
        self.desc = [[NSString alloc]initWithString:name];
        if  (self.places==nil)
            self.places = [[NSMutableArray alloc]init];
        for (int i=0;i<[[Dic allKeys]count];i++){
            SmartPlace *t = [[SmartPlace alloc]initWithDic:[Dic allValues][i]
                                                  andName:[Dic allKeys][i]
                             ];
            [self.places addObject:t];
        }
        NSArray* sortArray = [self.places copy];

        NSArray *sortedArray = [sortArray sortedArrayUsingComparator: ^(SmartPlace* obj1, SmartPlace* obj2) {
            if (obj1.name<obj2.name) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        self.places = [sortedArray mutableCopy];
    }
    return  self;
}
@end
