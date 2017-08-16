//
// Created by Cirno on 2017/8/8.
// Copyright (c) 2017 zbc. All rights reserved.
//

#import "AttendanceHistory.h"


@implementation AttendanceHistory {

}
-(NSArray<NSString*>*)statusArray{
    //0:没有签到 1:成功 2:迟到 3:补签 4:缺勤
    return @[@"没有签到",@"签到成功",@"签到成功-迟到",@"教师补签",@"缺勤",@"未知",@""];
}
-(NSArray<NSString*>*)sourceArray{
    return @[@"未签到",@"iOS",@"Android",@"Leapbox",@"教师手动添加",@"未知",@""];
}
-(void)initWithCid:(NSString*)cid
     andCourseCode:(NSString*)coursecode
            andCls:(NSString*)cls
       andSemester:(NSString*)semester
      andSigntime:(NSString*)signTime
            andAid:(NSString*)aid
         andSource:(NSString*)source
         andStatus:(NSString*)status{
    CirnoLog(@"status=%@",status);
    self.cid=cid;
    self.coursecode=coursecode;
    ClassTool* clstool = [[ClassTool alloc]init];
    @try{
        self.coursename = [clstool searchCode:coursecode][0].courseName;
    } @catch (NSException * exception){
        self.coursename = @"未知";
    }
    @try{
        self.source = [self.sourceArray objectAtIndex:[source integerValue]];
    } @catch (NSException * exception){
        self.source = @"未知";
    }
    @try{
        self.status = [self.statusArray objectAtIndex:[status integerValue]];
    } @catch (NSException * exception){
        self.status = @"未知";
    }
    self.cls=cls;
    self.semester=semester;
    self.signTime = signTime;
    self.aid=aid;

}
@end
