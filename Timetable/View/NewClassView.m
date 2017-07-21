//
//  NewClassView.m
//  MUST_Plus
//
//  Created by Cirno on 13/02/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import "NewClassView.h"

@implementation NewClassView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self!=nil){
        _week = [self getWeek];
    }
    return self;
}
-(void) addClassesInScrollView:(NSMutableArray<ClassButton*> *)Schoolclasses{
    //添加课程咯
    for(int i=0;i<[Schoolclasses count];i++){
        [self addClassInScrollView:[Schoolclasses objectAtIndex:i]];
    }

}
-(void) addClassInScrollView:(ClassButton *)Schoolclass{
//
    [Schoolclass removeAllSubviews];
    const float OneHour = (self.frame.size.height)/14;
    const float OneDay= self.frame.size.width/7;
    SchoolClassModel *class = [Schoolclass getButtonSchoolClass];//拿到BUTTON储存的课程
//
    int week = _week;
    float classStartTime = [self StringToFloat:[class getClass_StartTime]];
    float classEndTime = [self StringToFloat:[class getClass_EndTime]];
    int classWeek = [[class getClass_Week] intValue]-1;
    if (classWeek == -1) classWeek = 6;
   if (classWeek == week){
        Schoolclass.frame = CGRectMake((OneDay*classWeek), OneHour*(classStartTime-8), OneDay, OneHour*(classEndTime-classStartTime));
       Schoolclass.alpha = 1.0;


    }else  {
        Schoolclass.frame = CGRectMake((OneDay*classWeek), OneHour*(classStartTime-8), OneDay, OneHour*(classEndTime-classStartTime));
        Schoolclass.alpha = 0.4f;
    }
//    //NSLog(@"%@",[class getClass_Name]);
//
//
//    if(week > 2){
//        if(classWeek == week)
//            Schoolclass.frame =CGRectMake((OneDay*classWeek) - OneDay*2 + 8, OneHour*(classStartTime-8), (OneDay*2)-4, OneHour*(classEndTime-classStartTime));
//        else if(classWeek > week)
//            Schoolclass.frame =CGRectMake((OneDay*classWeek) - OneDay + 8, OneHour*(classStartTime-8), OneDay-4, OneHour*(classEndTime-classStartTime));
//        else if(classWeek < 2)
//            Schoolclass.frame =CGRectMake(0,0,0,0);
//        else
//            Schoolclass.frame =CGRectMake((OneDay*classWeek) - OneDay*2 + 8, OneHour*(classStartTime-8), OneDay-4, OneHour*(classEndTime-classStartTime));
//    }
//    else{
//        if(classWeek == week)
//            Schoolclass.frame =CGRectMake((OneDay*classWeek) + 8, OneHour*(classStartTime-8), (OneDay*2)-4, OneHour*(classEndTime-classStartTime));
//        else if(classWeek > week && classWeek <= 4)
//            Schoolclass.frame =CGRectMake((OneDay*classWeek) + 8 + OneDay, OneHour*(classStartTime-8), (OneDay)-4, OneHour*(classEndTime-classStartTime));
//        else if(classWeek > 4)
//            Schoolclass.frame =CGRectMake(0,0,0,0);
//        else if(classWeek == 0)
//            Schoolclass.frame =CGRectMake(0,0,0,0);
//        else
//            Schoolclass.frame =CGRectMake((OneDay*classWeek) + 8, OneHour*(classStartTime-8), OneDay-4, OneHour*(classEndTime-classStartTime));
//    }
//
//
    //课程名字
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,Schoolclass.frame.size.height*0.1, Schoolclass.frame.size.width, Schoolclass.frame.size.height*0.4)];
    classLabel.text = NSLocalizedString([class getClass_Name], "");
    classLabel.textColor = [UIColor whiteColor];
    classLabel.font = [UIFont systemFontOfSize:10];
    classLabel.textAlignment = NSTextAlignmentCenter;
    classLabel.numberOfLines = 0;
    classLabel.adjustsFontSizeToFitWidth = YES;
    [Schoolclass addSubview:classLabel];

    //课程教师
    UILabel *classRoom = [[UILabel alloc] initWithFrame:CGRectMake(0,Schoolclass.frame.size.height*0.6, Schoolclass.frame.size.width, Schoolclass.frame.size.height*0.3)];
    classRoom.text = [NSString stringWithFormat:@"@%@",[class getClass_Room]];
    classRoom.textColor = [UIColor whiteColor];
    classRoom.font = [UIFont systemFontOfSize:10];
    classRoom.textAlignment = NSTextAlignmentCenter;
    [Schoolclass addSubview:classRoom];
    classRoom.adjustsFontSizeToFitWidth = YES;


    Schoolclass.layer.cornerRadius = 5;

    //添加
    [self addSubview:Schoolclass];
    [self bringSubviewToFront:Schoolclass];
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

-(float) StringToFloat:(NSString *)ClassStratTime{
    NSString *b = [ClassStratTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
    int a = (int)([b floatValue]);
    float c = [b floatValue] - a;
    c = c / 0.6;
    c = a + c;
    //NSLog(@"%f",c);
    return c;
}
@end
