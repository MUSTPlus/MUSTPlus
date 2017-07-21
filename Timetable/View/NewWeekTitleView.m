//
//  NewWeekTitleView.m
//  MUST_Plus
//
//  Created by Cirno on 11/02/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import "NewWeekTitleView.h"
#import "MacauHoliday.h"
#define MonthWidth 25
@implementation NewWeekTitleView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self!=nil){

    }
    return self;
}
- (NSArray *)getWeekTime:(NSString*)date1
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];

    NSDate *nowDate = date1 == nil? [NSDate date]:[formatter dateFromString:date1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    double firstday = [firstDayOfWeek timeIntervalSince1970];
    double dayTime = 24*60*60;
    NSMutableArray * weekDays = [[NSMutableArray alloc]initWithCapacity:7];
    [formatter setDateFormat:@"MM-dd"];
    for (int _=0;_<7;_++){
        NSDate * tmp = [NSDate dateWithTimeIntervalSince1970:firstday];
        NSString * string = [formatter stringFromDate:tmp];
        weekDays[_]=string;
        firstday+=dayTime;
    }

    return weekDays;
    
}
-(void)drawTitleWithDate:(NSString*)Date{
    //YYYYMMdd
   const float OneHour = (Height-TabbarHeight-StatusBarAndNavigationBarHeight-30)/ 14;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    self.backgroundColor = [UIColor clearColor];
    float blockWidth = (Width - MonthWidth)/7;
    NSArray *WeekArray = [[NSArray alloc] initWithObjects:
                          NSLocalizedString(@"星期一", ""),
                          NSLocalizedString(@"星期二", ""),
                          NSLocalizedString(@"星期三", ""),
                          NSLocalizedString(@"星期四", ""),
                          NSLocalizedString(@"星期五", ""),
                          NSLocalizedString(@"星期六", ""),
                          NSLocalizedString(@"星期日", ""), nil];
    _MonthView = [[UIView alloc]initWithFrame:CGRectMake(-0.5, 0, MonthWidth, self.frame.size.height)];
    UILabel * MonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MonthWidth, 19)];
//    MonthLabel.text = NSLocalizedString(@"月份", "");
//    MonthLabel.font = [UIFont systemFontOfSize:12];
    NSArray *Week = [self getWeekTime:Date];
    _MonthView.layer.borderWidth=1;
    _MonthView.layer.borderColor=kColor(66, 130, 196).CGColor;
    [_MonthView addSubview:MonthLabel];
   // [self addSubview:_MonthView];
    _DayView = [[NSMutableArray<UIView*> alloc]initWithCapacity:7];
    for (int i=0;i<7;i++){
        _DayView[i] = [[UIView alloc]initWithFrame:CGRectMake(MonthWidth+i*blockWidth, 0, blockWidth, self.frame.size.height)];
        UILabel* daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, blockWidth, self.frame.size.height/2)];
        UILabel* weekTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, blockWidth, self.frame.size.height/2)];
        NSDateFormatter * format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"MM-dd"];
        NSString*hoil = [MacauHoliday getHolidays:[format dateFromString:Week[i]]];

        daysLabel.text = Week[i];
        daysLabel.font = [UIFont systemFontOfSize:11];

        weekTitleLabel.font = [UIFont boldSystemFontOfSize:11];
        daysLabel.textColor = kColor(66, 130, 196);
        weekTitleLabel.textColor = kColor(66, 130, 196);
        daysLabel.textAlignment = NSTextAlignmentCenter;
        weekTitleLabel.textAlignment = NSTextAlignmentCenter;
        weekTitleLabel.text = WeekArray[i];
        [_DayView[i] addSubview:daysLabel];
        [_DayView[i] addSubview:weekTitleLabel];
        if (i!=0){
            UIView* line = [[UIView alloc]initWithFrame:CGRectMake(MonthWidth+i*blockWidth, 0, 1, self.frame.size.height)];
            line.backgroundColor = [kColor(66, 130, 196) colorWithAlphaComponent:0.3];
            [self addSubview:line];
        }
       // _DayView[i].layer.borderWidth=1;
        //_DayView[i].layer.borderColor=[kColor(66, 130, 196)colorWithAlphaComponent:0.3].CGColor ;
        if ([[formatter stringFromDate:[NSDate date]]isEqualToString:Week[i]]){
            _DayView[i].backgroundColor=[kColor(66, 130, 196) colorWithAlphaComponent:0.3];
        }
        [self addSubview:_DayView[i]];
        if (i==0){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(MonthWidth+i*blockWidth, 0, 1, Height-TabbarHeight-StatusBarAndNavigationBarHeight)];
            line.backgroundColor = [kColor(66, 130, 196) colorWithAlphaComponent:0.3];
            [self addSubview:line];
        } else {
            for (int _=1;_<14;_++){
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(MonthWidth+i*blockWidth, 30+_*OneHour-2, 1, 5)];
                line.backgroundColor = [kColor(66, 130, 196) colorWithAlphaComponent:0.3];
                [self addSubview:line];
            }
        }
        if ([hoil length]>0) {
            daysLabel.text = hoil;
            daysLabel.textColor = [UIColor redColor];
            weekTitleLabel.textColor = [UIColor redColor];
        }
        daysLabel.adjustsFontSizeToFitWidth = YES;

    }
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, Width, 1)];
    line.backgroundColor = [kColor(66, 130, 196) colorWithAlphaComponent:0.3];
    [self addSubview:line];

}
@end
