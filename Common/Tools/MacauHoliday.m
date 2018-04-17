//
//  MacauHoliday.m
//  Currency
//
//  Created by Cirno on 03/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "MacauHoliday.h"

@implementation MacauHoliday
+ (NSString *)getHolidays:(NSDate *)date {

    NSString *todayHoliday;
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"MM-dd"];
    NSString *nowdate = [dateFormatter1 stringFromDate:date];
    NSDictionary *HoliDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"中华人民共和国国庆日", @"10-01",
                                    @"中华人民共和国国庆日翌日", @"10-02",
                                    @"圣诞节前日", @"12-24",
                                    @"圣诞节",@"12-25",
                                    @"清明节",@"04-05",
                                    @"耶稣受难日",@"03-30",
                                    @"复活节前日",@"03-31",
                                    @"劳动节",@"05-01",
                                    @"佛诞节",@"05-22",
                                    @"端午节",@"06-18",
                                    @"行政长官特许豁免",@"04-02",
                                    nil];

    todayHoliday = [HoliDay objectForKey:nowdate];
    if (todayHoliday.length > 0) {
        return todayHoliday;
    }
    return @"";
    
}
@end
