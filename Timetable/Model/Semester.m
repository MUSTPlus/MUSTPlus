//
//  Semester.m
//  MUSTPlus
//
//  Created by Cirno on 26/04/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import "Semester.h"

@implementation Semester
-(instancetype)initWithStartDate:(NSString*)startDate
            andEndDate:(NSString*)endDate
                    andSemester:(NSString *)semester{
    self = [super init];
    if (self){
        WeekTool * wt = [[WeekTool alloc]init];
        [wt setStart:startDate];
        [wt setEnd:endDate];
        self.week = [wt weeks];
        self.semester = semester;
        
    }
    return self;

}
@end
