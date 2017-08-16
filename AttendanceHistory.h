//
// Created by Cirno on 2017/8/8.
// Copyright (c) 2017 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassTool.h"

@interface AttendanceHistory : NSObject
@property  (nonatomic,strong) NSString* cid;
@property  (nonatomic,strong) NSString* coursecode;
@property  (nonatomic,strong) NSString* coursename;
@property (nonatomic,strong) NSString* signTime;
@property  (nonatomic,strong) NSString* cls; //班级
@property (nonatomic,strong) NSString*aid;
@property (nonatomic,strong) NSString* source;
@property  (nonatomic,strong) NSString* semester;
@property (nonatomic,strong) NSString* status;
-(void)initWithCid:(NSString*)cid
     andCourseCode:(NSString*)coursecode
            andCls:(NSString*)cls
       andSemester:(NSString*)semester
       andSigntime:(NSString*)signTime
            andAid:(NSString*)aid
         andSource:(NSString*)source
         andStatus:(NSString*)status;
@end
