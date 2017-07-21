//
//  Semester.h
//  MUSTPlus
//
//  Created by Cirno on 26/04/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeekTool.h"
@interface Semester : NSObject
@property (nonatomic,strong) NSString* semester;
@property (nonatomic,strong) NSDate* startDate; //学期开始
@property (nonatomic,strong) NSDate* endDate;   //学期结束
@property (nonatomic,strong) NSArray* weeks;
@property (nonatomic) NSInteger week;           //该学期有几个星期
-(instancetype)initWithStartDate:(NSString*)startDate
            andEndDate:(NSString*)endDate
                     andSemester:(NSString*)semester;
@end
