//
//  SchoolClassModel.m
//  MUST_Plus
//
//  Created by zbc on 16/10/5.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolClassModel.h"

@implementation SchoolClassModel


-(void) setSchoolClassInfoData:(NSString *)class_Room
                    class_Week:(NSString *)class_Week
                  class_Number:(NSString *)class_Number
               class_StartTime:(NSString *)class_StartTime
                    class_Name:(NSString *)class_Name
              class_StartMonth:(NSString *)class_StartMonth
                class_EndMonth:(NSString *)class_EndMonth
                 class_EndTime:(NSString *)class_EndTime
                      class_No:(NSString *)class_No
                 class_Teacher:(NSString *)class_Teacher{
    self.class_Room = class_Room;
    self.class_Week = class_Week;
    self.class_Number = class_Number;
    self.class_StartTime = class_StartTime;
    self.class_Name = class_Name;
    self.class_StartMonth = class_StartMonth;
    self.class_EndMonth = class_EndMonth;
    self.class_EndTime = class_EndTime;
    self.class_No = class_No;
    self.class_Teacher = class_Teacher;
}


-(NSString *) getClass_Room{
    return self.class_Room;
}

-(NSString *) getClass_Week{
    return self.class_Week;
}

-(NSString *) getClass_Number{
    return self.class_Number;
}

-(NSString *) getClass_StartTime{
    return self.class_StartTime;
}

-(NSString *) getClass_Name{
    return self.class_Name;
}

-(NSString *) getClass_StartMonth{
    return self.class_StartMonth;
}

-(NSString *) getClass_EndMonth{
    return self.class_EndMonth;
}

-(NSString *) getClass_EndTime{
    return self.class_EndTime;
}

-(NSString *) getClass_No{
    return self.class_No;
}

-(NSString *) getClass_Teacher{
    return self.class_Teacher;
}

@end
