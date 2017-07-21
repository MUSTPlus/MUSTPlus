//
//  WeekTitleScrollView.m
//  MUST_Plus
//
//  Created by zbc on 16/10/3.
//  Copyright © 2016年 zbc. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "CutWeekTitleScrollView.h"

@implementation CutWeekTitleScrollView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        [self drawTitleWeek];
    }
    return self;
}


//显示星期
-(void) drawTitleWeek{
    float KXScrollView = self.frame.size.width;
    float KX_AVG_View = KXScrollView/7;
    self.backgroundColor = [UIColor clearColor];
    NSArray *WeekArray = [[NSArray alloc] initWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    UIButton *ButtonLabel;
    int x = 0;
    
    //星期
    int week = [self getWeek];
    for(int i=0;i<7;i++){
        ButtonLabel = [[UIButton alloc] initWithFrame:CGRectMake(x,0,KX_AVG_View,45)];
        x+=KX_AVG_View;
        [ButtonLabel setTitle:[WeekArray objectAtIndex:i]forState:UIControlStateNormal];
        ButtonLabel.titleLabel.font = [UIFont systemFontOfSize:13];
        if(week == i){
        [ButtonLabel setTitleColor:[UIColor colorWithRed:102.0f/255.0f
                                                       green:205.0f/255.0f
                                                        blue:0.0f/255.0f
                                                       alpha:1.0f]
                              forState:UIControlStateNormal];
            
        }else{
            [ButtonLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self addSubview:ButtonLabel];
    }
    
    //周三，周四下面的横线
    UILabel *weekLine =  [[UILabel alloc] initWithFrame:CGRectMake(week * KX_AVG_View,43,KX_AVG_View,2)];
    weekLine.layer.borderWidth = 1;
    weekLine.layer.borderColor = [[UIColor colorWithRed:102.0f/255.0f
                                                  green:205.0f/255.0f
                                                   blue:0.0f/255.0f
                                                  alpha:1.0f] CGColor];
    weekLine.backgroundColor = [UIColor colorWithRed:102.0f/255.0f
                                               green:205.0f/255.0f
                                                blue:0.0f/255.0f
                                               alpha:1.0f];
    [self addSubview:weekLine];
    
    int a = 0;
    for(int i=0;i<7;i++){
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [NSDate date];
        int daysToAdd = 0;
        if(i-week<0){
            daysToAdd = 7-week+i;
        }
        else{
            daysToAdd = i-week;
        }
        NSDate *newDate = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth  fromDate:newDate];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        UILabel *dateLine = [[UILabel alloc] initWithFrame:CGRectMake(a,33,KX_AVG_View,10)];
        if((long)day<10){
            dateLine.text = [NSString stringWithFormat:@"%ld-0%ld",(long)month,(long)day];
        }
        else{
            dateLine.text = [NSString stringWithFormat:@"%ld-%ld",(long)month,(long)day];
        }
        dateLine.font= [UIFont fontWithName:@"Helvetica" size: 10.0];
        if(week == i){
            dateLine.textColor = [UIColor colorWithRed:102.0f/255.0f
                                                 green:205.0f/255.0f
                                                  blue:0.0f/255.0f
                                                 alpha:1.0f];
        }else{
            dateLine.textColor = [UIColor whiteColor];
        }
        dateLine.textAlignment = UITextAlignmentCenter;
        [self addSubview:dateLine];
        a+=KX_AVG_View;
    }
    
}


-(int) getWeek{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = (int)[comps weekday];
    if(weekday == 1){
        weekday = 6;
    }
    else if(weekday == 7){
        weekday = 5;
    }
    else{
        weekday = weekday - 2;
    }
    return weekday;
}


@end
#pragma clang diagnostic pop
