//
//  WeekTitleScrollView.m
//  MUST_Plus
//
//  Created by zbc on 16/10/3.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "WeekTitleScrollView.h"

#define block 40
#define holidayColor [UIColor colorWithRed:255.0/255 green:69.0/255 blue:0/255 alpha:1.0]

@implementation WeekTitleScrollView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        _week = [self getWeek];
    }
    return self;
}


//显示星期
-(void) drawTitleWeekWithColor:(UIColor *)textColor
                    TodayColor:(UIColor *)todayColor{
    
    float KXScrollView = self.frame.size.width;
    float KX_AVG_View =(KXScrollView-block)/6;
    
    self.backgroundColor = [UIColor clearColor];
    NSArray *WeekArray = [[NSArray alloc] initWithObjects:
                          NSLocalizedString(@"星期一", ""),
                          NSLocalizedString(@"星期二", ""),
                          NSLocalizedString(@"星期三", ""),
                          NSLocalizedString(@"星期四", ""),
                          NSLocalizedString(@"星期五", ""),
                          NSLocalizedString(@"星期六", ""),
                          NSLocalizedString(@"星期日", ""), nil];
    int x = 0;
    
    
    int week = _week;
    
    
        //绘制星期
        for(int i=0;i<7;i++){
            
            UIButton *ButtonLabel;

            if(week > 2){
//                if (week == i){
//                    ButtonLabel = [[UIButton alloc] initWithFrame:CGRectMake(block + x - 2 * KX_AVG_View ,0,2 * KX_AVG_View,20)];
//                    }
//                else{
                    ButtonLabel = [[UIButton alloc] initWithFrame:CGRectMake(block + x - 2 * KX_AVG_View  ,0,KX_AVG_View ,20)];
   //             }
            }
            else{
     //           if (week == i){
      //              ButtonLabel = [[UIButton alloc] initWithFrame:CGRectMake(block + x  ,0,2 * KX_AVG_View,20)];
    //            }
      //          else{
                    ButtonLabel = [[UIButton alloc] initWithFrame:CGRectMake(block + x ,0,KX_AVG_View ,20)];
      //                             }
            }
   
     //       if(week == i){
      //          x+=KX_AVG_View;
      //      }
            
            x+=KX_AVG_View;
            
            [ButtonLabel setTitle:[WeekArray objectAtIndex:i]forState:UIControlStateNormal];
            [ButtonLabel.titleLabel setFont:[UIFont fontWithName:@"yuanti" size: 14]];
            ButtonLabel.titleLabel.font = [UIFont systemFontOfSize:14];
            
            int tagNum = i;
    
            ButtonLabel.tag = tagNum;
            
            [ButtonLabel addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];

            if(week == i){
            [ButtonLabel setTitleColor:todayColor forState:UIControlStateNormal];
    
            }else{
                [ButtonLabel setTitleColor:textColor forState:UIControlStateNormal];
            }
            
            if([self isHoliday:i]){
                [ButtonLabel setTitleColor:holidayColor forState:UIControlStateNormal];
                [ButtonLabel setTitle:@"假日" forState:UIControlStateNormal];
            }

            [self addSubview:ButtonLabel];
        }


  
    //周三，周四下面的横线
    UILabel *weekLine;
    if(week > 2)
            weekLine = [[UILabel alloc] initWithFrame:CGRectMake(block + (week - 2) * KX_AVG_View ,28, (2 * KX_AVG_View) - 5 ,3)];
    else
            weekLine = [[UILabel alloc] initWithFrame:CGRectMake(block + week * KX_AVG_View ,28,(2 * KX_AVG_View) - 5  ,3)];
    
    weekLine.layer.borderWidth = 1;
    
    if([self isHoliday:week]){
        weekLine.layer.borderColor = [holidayColor CGColor];
        weekLine.backgroundColor = holidayColor;
    }
    
    else{
        weekLine.layer.borderColor = [todayColor CGColor];
        weekLine.backgroundColor = todayColor;
    }
    
    [self addSubview:weekLine];

    //月-日
    int a = 0;
    for(int i=0;i<7;i++){
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDate *date = [NSDate date];
        int daysToAdd = i-[self getWeek];
      
        NSDate *newDate = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSDateComponents *comps = [gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth  fromDate:newDate];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        UILabel *dateLine;
        
        if(week > 2){
            if (week == i)
                dateLine = [[UILabel alloc] initWithFrame:CGRectMake(block + a - 2 * KX_AVG_View,15,2 * KX_AVG_View,15)];
            else
                dateLine = [[UILabel alloc] initWithFrame:CGRectMake(block + a - 2 * KX_AVG_View,15,KX_AVG_View,15)];
        }
        else{
            if (week == i)
                dateLine = [[UILabel alloc] initWithFrame:CGRectMake(block + a,15,2 * KX_AVG_View,15)];
            else
                dateLine = [[UILabel alloc] initWithFrame:CGRectMake(block + a,15,KX_AVG_View,15)];        }
        
        if(week == i){
            a+=KX_AVG_View;
        }
        
        if((long)day<10){
            dateLine.text = [NSString stringWithFormat:@"%ld-0%ld",(long)month,(long)day];
        }
        else{
            dateLine.text = [NSString stringWithFormat:@"%ld-%ld",(long)month,(long)day];
        }
        
        
        
        dateLine.font= [UIFont fontWithName:@"Helvetica" size: 10.0];
        
        
        NSString *holidayString = [NSString stringWithFormat:@"%d-%d",(int)month,(int)day];
        if([[self holiday] objectForKey:holidayString]){
            dateLine.textColor = holidayColor;
            dateLine.text = [[self holiday] objectForKey:holidayString];
        }
        
        else{
            if(week == i){
                dateLine.textColor = todayColor;
            }else{
                dateLine.textColor = textColor;
            }
        }
        
        dateLine.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLine];
        a+=KX_AVG_View;
    }
    
    UIView *mendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    mendView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mendView];
}


-(int) getWeek{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
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


-(bool) isHoliday:(int) i{
    
    int week = [self getWeek];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    int daysToAdd = i-week;
    
    NSDate *newDate = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    NSDateComponents *comps = [gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth  fromDate:newDate];
    NSInteger month = [comps month];
    NSInteger day = [comps day];    NSString *holidayString = [NSString stringWithFormat:@"%d-%d",(int)month,(int)day];
    NSLog(@"%@",holidayString);
    if([[self holiday] objectForKey:holidayString]){
        NSLog(@"yes");
        return true;
    }

    return false;
}


//假期,这边添加假期
-(NSDictionary *) holiday{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"感恩节",@"11-26",
                                                                     @"什么节",@"11-24",
                         nil];
    return dic;
}

-(void) click:(UIButton *)btn{
    NSLog(@"点击的日期是%d",(int)btn.tag);
    _week = (int)btn.tag;
    [self removeAllSubviews];
    [self drawTitleWeekWithColor:[UIColor blackColor]  TodayColor:[UIColor colorWithRed:102.0f/255.0f
                                                                                  green:205.0f/255.0f
                                                                                   blue:0.0f/255.0f
                                                                                  alpha:1.0f]];
    [_weakTtileButtonDelegate ClickWhichWeek:(int)btn.tag];
}

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            [subview removeFromSuperview];
        }
        
    }
}
@end
