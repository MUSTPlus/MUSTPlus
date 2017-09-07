//
//  TimetableLogic.m
//  MUST_Plus
//
//  Created by zbc on 16/11/9.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "TimetableLogic.h"
#import "Account.h"

@implementation TimetableLogic





+(NSMutableArray *) CheckClassInMonth:(NSMutableArray <SchoolClassModel *> *)schoolClasses{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for(SchoolClassModel *class in schoolClasses){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString* nowYear = [[[[Account shared]getSemester]stringByReplacingOccurrencesOfString:@"09" withString:@""]stringByReplacingOccurrencesOfString:@"02" withString:@""];
        if (!nowYear) nowYear = @"17";
        [formatter setDateFormat:@"yyMdd"];
        NSString*startDate = [NSString stringWithFormat:@"%@%d%@",nowYear,[self month:[class.class_StartMonth substringToIndex:3]],[class.class_StartMonth substringFromIndex:2]];
        NSString*endDate = [NSString stringWithFormat:@"%@%d%@",nowYear,[self month:[class.class_EndMonth substringToIndex:3]],[class.class_EndMonth substringFromIndex:2]];
        if ([startDate length]<5){
            startDate = [NSString stringWithFormat:@"%@%@%@",[startDate substringToIndex:3],@"0",[startDate substringFromIndex:3]];
        }
        if ([endDate length]<5){
            endDate = [NSString stringWithFormat:@"%@%@%@",[endDate substringToIndex:3],@"0",[endDate substringFromIndex:3]];
        }
        NSDate* start = [formatter dateFromString:startDate];
        NSDate* end = [formatter dateFromString:endDate];
        NSDate* today = [NSDate date];
        if ([self isthat:today isBetweenDate:start andDate:end])
        {
            [returnArray addObject:class];
        }
    }
    return returnArray;
}

+(NSMutableArray *) CheckClassInMonth:(NSMutableArray <SchoolClassModel *> *)schoolClasses
                             WithDate:(NSDate*)date{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for(SchoolClassModel *class in schoolClasses){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString* nowYear = [[[[Account shared]getSemester]stringByReplacingOccurrencesOfString:@"09" withString:@""]stringByReplacingOccurrencesOfString:@"02" withString:@""];
        if (!nowYear) nowYear = @"17";
        [formatter setDateFormat:@"yyMdd"];
        NSRange startMonth= [class.class_StartMonth rangeOfString:@"月"];
        NSRange endMonth = [class.class_EndMonth rangeOfString:@"月"];
        NSString *startMonthStr = [NSString stringWithFormat:@"%@",[class.class_StartMonth substringToIndex:startMonth.location+1]];
        NSString* startDay =[class.class_StartMonth substringFromIndex:startMonth.location+1];
        NSString* endDay =[class.class_EndMonth substringFromIndex:endMonth.location+1];
        if ([startDay length]==1)
            startDay = [NSString stringWithFormat:@"0%@",startDay];
        if ([endDay length]==1)
            endDay = [NSString stringWithFormat:@"0%@",endDay];

        NSString* endMonthStr = [NSString stringWithFormat:@"%@",[class.class_EndMonth substringToIndex:endMonth.location+1]];
        NSString*startDate = [NSString stringWithFormat:@"%@%@%@",nowYear,[self month:startMonthStr],startDay];
        NSString*endDate = [NSString stringWithFormat:@"%@%@%@",nowYear,[self month:endMonthStr],endDay];
        NSDate* start = [formatter dateFromString:startDate];
        NSDate* end = [formatter dateFromString:endDate];
        NSDate* today = date;
        if ([self isthat:today isBetweenDate:start andDate:end])
        {
            [returnArray addObject:class];
        }
    }
    return returnArray;
}

+(NSString*)month:(NSString *)month{
    
    month = [month substringToIndex:2];
    
    if([month isEqualToString:@"一月"]){
        return @"01";
    }
    else if([month isEqualToString:@"二月"]){
        return @"02";
    }
    else if([month isEqualToString:@"三月"]){
        return @"03";
    }
    else if([month isEqualToString:@"四月"]){
        return @"04";
    }
    else if([month isEqualToString:@"五月"]){
        return @"05";
    }
    else if([month isEqualToString:@"六月"]){
        return @"06";
    }
    else if([month isEqualToString:@"七月"]){
        return @"07";
    }
    else if([month isEqualToString:@"八月"]){
        return @"08";
    } else if([month isEqualToString:@"九月"]){
        return @"09";
    }
    else if([month isEqualToString:@"十月"]){
        return @"10";
    }
    else if([month isEqualToString:@"十一"]){
        return @"11";
    }
    else if([month isEqualToString:@"十二"]){
        return @"12";
    }
    
    return 0;
    
}
+ (BOOL)isthat:(NSDate*)date
 isBetweenDate:(NSDate*)beginDate
       andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    return YES;
}


@end
