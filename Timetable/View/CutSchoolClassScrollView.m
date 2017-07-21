//
//  SchoolClassScrollView.m
//  MUST_Plus
//
//  Created by zbc on 16/10/4.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "CutSchoolClassScrollView.h"
#import "SchoolClassModel.h"

@implementation CutSchoolClassScrollView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        self.bounces = false;
        self.delegate = self;
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

//真添加课程界面
-(void) addClassInScrollView:(ClassButton *)Schoolclass{
    
    const float OneHour = (self.frame.size.height)/14;
    const float OneDay= (self.frame.size.width)/7;
    
    SchoolClassModel *class = [Schoolclass getButtonSchoolClass];//拿到BUTTON储存的课程

    float classStartTime = [self StringToFloat:[class getClass_StartTime]];
    float classEndTime = [self StringToFloat:[class getClass_EndTime]];
    int classWeek = [[class getClass_Week] intValue]-1;
    
    Schoolclass.frame =CGRectMake((OneDay*classWeek)+2, OneHour*(classStartTime-8), OneDay-4, OneHour*(classEndTime-classStartTime));
    
    //课程名字
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,Schoolclass.frame.size.height*0.1, Schoolclass.frame.size.width, Schoolclass.frame.size.height*0.4)];
    classLabel.text = [class getClass_Name];
    classLabel.textColor = [UIColor whiteColor];
    [classLabel setFont:[UIFont fontWithName:@"yuanti" size: 10.0]];
    classLabel.font = [UIFont systemFontOfSize:10];
    classLabel.textAlignment = NSTextAlignmentCenter;
    classLabel.numberOfLines = 0;
    classLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [Schoolclass addSubview:classLabel];
    
    //课程教师
    UILabel *classRoom = [[UILabel alloc] initWithFrame:CGRectMake(0,Schoolclass.frame.size.height*0.6, Schoolclass.frame.size.width, Schoolclass.frame.size.height*0.3)];
    classRoom.text = [NSString stringWithFormat:@"@%@",[class getClass_Room]];
    classRoom.textColor = [UIColor whiteColor];
    [classRoom setFont:[UIFont fontWithName:@"yuanti" size: 13.0]];
    classRoom.font = [UIFont systemFontOfSize:13];
    classRoom.textAlignment = NSTextAlignmentCenter;
    [Schoolclass addSubview:classRoom];
    
    //添加
    [self addSubview:Schoolclass];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_schoolClassScrollDeleage scroll:scrollView];
}





@end
