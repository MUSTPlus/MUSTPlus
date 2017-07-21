//
//  WeekTool.m
//  Created by Cirno on 25/04/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "WeekTool.h"

@implementation WeekTool

-(NSInteger)WeekForDate:(NSDate*)date{
    NSAssert(self.startDate,@"学期开始日期为空");
    NSAssert(self.endDate  ,@"学期结束日期为空");
    BOOL earlier = [date earlierDate:self.startDate]!=date;
    BOOL later   = [date laterDate  :self.endDate]  !=date;
    NSAssert(earlier, @"早于学期开始日期");
    NSAssert(later, @"晚于学期结束日期");
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay
                                                   fromDate:self.startDate
                                                     toDate:date
                                                    options:0];
    return ceil(dayComponents.day/7.0);
}
-(void)setStart:(NSString *)startDate{
    self.startDate = [self StringToDate:startDate];
}
-(void)setEnd:(NSString *)endDate{
    self.endDate = [self StringToDate:endDate];
}
-(NSInteger)weeks{
    NSAssert(self.startDate,@"学期开始日期为空");
    NSAssert(self.endDate  ,@"学期结束日期为空");
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay
                                                   fromDate:self.startDate
                                                     toDate:self.endDate
                                                    options:0];
    return ceil(dayComponents.day/7.0);//一定要加.0!血的教训. 向上取整
}
-(NSDate*)WeekDateAt:(int)Week
                  On:(int)days{
    NSAssert(self.startDate,@"学期开始日期为空");
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setDay:(Week-1)*7+days];
    return [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]
            dateByAddingComponents:comps
            toDate:self.startDate options:0];
}
-(NSString*)DateToString:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}
-(NSDate*)StringToDate:(NSString*)str{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:str];
}
+(WeekTool*)sharedInstance{//单例模式的初始化
    static dispatch_once_t once;
    static WeekTool *sharedInstance;
    dispatch_once(&once, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;

}
@end
