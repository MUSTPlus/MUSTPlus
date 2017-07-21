//
//  SchoolClassModel.h
//  MUST_Plus
//
//  Created by zbc on 16/10/5.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolClassModel : NSObject

@property (nonatomic, strong) NSString *class_Room;
@property (nonatomic, strong) NSString *class_Week;
@property (nonatomic, strong) NSString *class_Number;
@property (nonatomic, strong) NSString *class_StartTime;
@property (nonatomic, strong) NSString *class_Name;
@property (nonatomic, strong) NSString *class_StartMonth;
@property (nonatomic, strong) NSString *class_EndMonth;
@property (nonatomic, strong) NSString *class_EndTime;
@property (nonatomic, strong) NSString *class_No;
@property (nonatomic, strong) NSString *class_Teacher;


-(void) setSchoolClassInfoData:(NSString *)class_Room
                    class_Week:(NSString *)class_Week
                    class_Number:(NSString *)class_Number
                    class_StartTime:(NSString *)class_StartTime
                    class_Name:(NSString *)class_Name
                    class_StartMonth:(NSString *)class_StartMonth
                    class_EndMonth:(NSString *)class_EndMonth
                    class_EndTime:(NSString *)class_EndTime
                    class_No:(NSString *)class_No
                    class_Teacher:(NSString *)class_Teacher;


-(NSString *) getClass_Room;
-(NSString *) getClass_Week;
-(NSString *) getClass_Number;
-(NSString *) getClass_StartTime;
-(NSString *) getClass_Name;
-(NSString *) getClass_StartMonth;
-(NSString *) getClass_EndMonth;
-(NSString *) getClass_EndTime;
-(NSString *) getClass_No;
-(NSString *) getClass_Teacher;


@end
