//
// Created by Cirno on 2017/8/8.
// Copyright (c) 2017 zbc. All rights reserved.
//

#import "AttendanceCourse.h"


@implementation AttendanceCourse {

}
-(void)initWithCid:(NSString*)cid
             andCourseCode:(NSString*)coursecode
                    andCls:(NSString*)cls
               andSemester:(NSString*)semester
              andStartTime:(NSString*)startTime
                andEndTime:(NSString*)endTime
                    andSid:(NSString *)sid
                    andAid:(NSString*)aid{

        self.cid=cid;
        self.coursecode=coursecode;
        ClassTool* clstool = [[ClassTool alloc]init];
        @try{
            self.coursename = [clstool searchCode:coursecode][0].courseName;
        } @catch (NSException * exception){
            self.coursename = @"未知";
        }

        self.cls=cls;
        self.semester=semester;
        self.startTime = startTime;
        self.endTime=endTime;
        self.sid=sid;
        self.aid=aid;

}
@end
