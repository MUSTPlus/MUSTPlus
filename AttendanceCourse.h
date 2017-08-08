//
// Created by Cirno on 2017/8/8.
// Copyright (c) 2017 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassTool.h"

@interface AttendanceCourse : NSObject
@property  (nonatomic,strong) NSString* cid;
@property  (nonatomic,strong) NSString* coursecode;
@property  (nonatomic,strong) NSString* coursename;
@property (nonatomic,strong) NSString* sid;
@property  (nonatomic,strong) NSString* cls; //班级
@property (nonatomic,strong) NSString* startTime;
@property (nonatomic,strong) NSString*aid;
@property (nonatomic,strong) NSString* endTime;
@property  (nonatomic,strong) NSString* semester;
-(void)initWithCid:(NSString*)cid
             andCourseCode:(NSString*)coursecode
                    andCls:(NSString*)cls
               andSemester:(NSString*)semester
              andStartTime:(NSString*)startTime
                andEndTime:(NSString*)endTime
                    andSid:(NSString*)sid
            andAid:(NSString*)aid;
@end
