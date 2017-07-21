//
//  AttendanceHeaderView.m
//  MUSTPlus
//
//  Created by Cirno on 2017/4/30.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "AttendanceHeaderView.h"

@implementation AttendanceHeaderView

-(void)initWithDate:(NSString*)date
                  andCourse:(NSString*)course
                  andStatus:(NSString*)status{

    self.Date  .text = date;
    self.Course.text = course;
    self.Status.text = status;
    [self.Attendance addTarget:self action:@selector(didClickSign) forControlEvents:UIControlEventTouchDown];
    self.Attendance.userInteractionEnabled = YES;
}
-(void)didClickSign{
    [self.delegate didClickSign];
}
-(instancetype)init{
    self = [super init];
    return self;
}
@end
