//
//  WeekTool.h
//  MUSTPlus
//
//  Created by Cirno on 25/04/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WeekTool : NSObject
@property (nonatomic,strong) NSDate* startDate; //学期开始
@property (nonatomic,strong) NSDate* endDate;   //学期结束
@property (nonatomic,strong) NSString* semester;
-(void)setStart:(NSString *)startDate;
-(void)setEnd:(NSString *)endDate;
-(NSInteger)weeks; //一共有几周
-(NSInteger)WeekForDate:(NSDate*)date;//date是第几周
-(NSDate*)WeekDateAt:(int)Week On:(int)days;//从学期开始到第Week周的第一天
-(NSString*)DateToString:(NSDate*)date;
-(NSDate*)StringToDate:(NSString*)str;
+ (WeekTool*)sharedInstance;
@end
