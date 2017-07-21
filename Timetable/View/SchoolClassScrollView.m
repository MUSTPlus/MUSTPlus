//
//  SchoolClassScrollView.m
//  MUST_Plus
//
//  Created by zbc on 16/10/4.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolClassScrollView.h"
#import "SchoolClassModel.h"
#import "BasicHead.h"

@implementation SchoolClassScrollView



-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        //取消滚动条
        self.showsVerticalScrollIndicator = FALSE;
        self.showsHorizontalScrollIndicator = FALSE;
        //取消回弹
        self.bounces = false;
        self.delegate = self;
        
        self.backgroundColor = timeTableColor;
    
        _week = [self getWeek];
        [self addLine];
    }
    
    return self;
}

//外面的方法
-(void) addClassesInScrollView:(NSMutableArray<ClassButton*> *)Schoolclasses{
    //添加课程咯
    for(int i=0;i<[Schoolclasses count];i++){
        [self addClassInScrollView:[Schoolclasses objectAtIndex:i]];
    }
    
}


-(void) addLine{
    
    
    const float OneHour = (self.frame.size.height)/14;
    const float OneDay= (self.frame.size.width - 10)/6;
    UIView *SeparateLine;
    
    
    
    float hei = 0;
    float wid = 0;
    
    
    //小短线
    while (hei < 14) {
        for(int y=0;y<6;y++){
            SeparateLine = [[UIView alloc] initWithFrame:CGRectMake(wid + 5 ,hei * OneHour - 3,1.5,6)];
            SeparateLine.backgroundColor = [UIColor colorWithRed:215.0f/255.0f
                                                           green:222.0f/255.0f
                                                            blue:222.0f/255.0f
                                                           alpha:1.0f];
            wid += OneDay;
            [self addSubview:SeparateLine];
        }
        wid = 0;
        hei++;
    }
    
    //分割线
    float x = 0;
    for(int i=0;i<14;i++){
        SeparateLine = [[UIView alloc] initWithFrame:CGRectMake(0,x,444,1.1)];
        SeparateLine.backgroundColor = [UIColor colorWithRed:215.0f/255.0f
                                                       green:222.0f/255.0f
                                                        blue:222.0f/255.0f
                                                       alpha:1.0f];
        x+=OneHour;
        [self addSubview:SeparateLine];
        [self sendSubviewToBack:SeparateLine];
    }
}


//真添加课程界面
-(void) addClassInScrollView:(ClassButton *)Schoolclass{
    
    [Schoolclass removeAllSubviews];
    const float OneHour = (self.frame.size.height)/14;
    const float OneDay= (self.frame.size.width - 10)/6;
    
    //NSLog(@"oneday %f",OneDay);
    
    int week = _week;
    
    SchoolClassModel *class = [Schoolclass getButtonSchoolClass];//拿到BUTTON储存的课程

    float classStartTime = [self StringToFloat:[class getClass_StartTime]];
    float classEndTime = [self StringToFloat:[class getClass_EndTime]];
    int classWeek = [[class getClass_Week] intValue]-1;
    
    //NSLog(@"%@",[class getClass_Name]);
    
    
    if(week > 2){
        if(classWeek == week)
            Schoolclass.frame =CGRectMake((OneDay*classWeek) - OneDay*2 + 8, OneHour*(classStartTime-8), (OneDay*2)-4, OneHour*(classEndTime-classStartTime));
        else if(classWeek > week)
              Schoolclass.frame =CGRectMake((OneDay*classWeek) - OneDay + 8, OneHour*(classStartTime-8), OneDay-4, OneHour*(classEndTime-classStartTime));
        else if(classWeek < 2)
            Schoolclass.frame =CGRectMake(0,0,0,0);
        else
            Schoolclass.frame =CGRectMake((OneDay*classWeek) - OneDay*2 + 8, OneHour*(classStartTime-8), OneDay-4, OneHour*(classEndTime-classStartTime));
    }
    else{
        if(classWeek == week)
            Schoolclass.frame =CGRectMake((OneDay*classWeek) + 8, OneHour*(classStartTime-8), (OneDay*2)-4, OneHour*(classEndTime-classStartTime));
        else if(classWeek > week && classWeek <= 4)
            Schoolclass.frame =CGRectMake((OneDay*classWeek) + 8 + OneDay, OneHour*(classStartTime-8), (OneDay)-4, OneHour*(classEndTime-classStartTime));
        else if(classWeek > 4)
            Schoolclass.frame =CGRectMake(0,0,0,0);
        else if(classWeek == 0)
            Schoolclass.frame =CGRectMake(0,0,0,0);
        else
            Schoolclass.frame =CGRectMake((OneDay*classWeek) + 8, OneHour*(classStartTime-8), OneDay-4, OneHour*(classEndTime-classStartTime));
    }
    
    
    //课程名字
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,Schoolclass.frame.size.height*0.1, Schoolclass.frame.size.width, Schoolclass.frame.size.height*0.4)];
    classLabel.text = [class getClass_Name];
    classLabel.textColor = [UIColor whiteColor];
    [classLabel setFont:[UIFont fontWithName:@"yuanti" size: 10.0]];
    classLabel.font = [UIFont systemFontOfSize:10];
    classLabel.textAlignment = NSTextAlignmentCenter;
    classLabel.numberOfLines = 2;

    [Schoolclass addSubview:classLabel];
    
    //课程教师
    UILabel *classRoom = [[UILabel alloc] initWithFrame:CGRectMake(0,Schoolclass.frame.size.height*0.6, Schoolclass.frame.size.width, Schoolclass.frame.size.height*0.3)];
    classRoom.text = [NSString stringWithFormat:@"@%@",[class getClass_Room]];
    classRoom.textColor = [UIColor whiteColor];
    [classRoom setFont:[UIFont fontWithName:@"yuanti" size: 10]];
    classRoom.font = [UIFont systemFontOfSize:10];
    classRoom.textAlignment = NSTextAlignmentCenter;
    [Schoolclass addSubview:classRoom];
    
    
    
    Schoolclass.layer.cornerRadius = 5;
    
    //添加
    [self addSubview:Schoolclass];
    [self bringSubviewToFront:Schoolclass];
}



//这个方法是为了12:30 转为 12.5 把60单位转为100
-(float) StringToFloat:(NSString *)ClassStratTime{
    NSString *b = [ClassStratTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
    int a = (int)([b floatValue]);
    float c = [b floatValue] - a;
    c = c / 0.6;
    c = a + c;
    //NSLog(@"%f",c);
    return c;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_schoolClassScrollDelegate scroll:scrollView];
}





@end
