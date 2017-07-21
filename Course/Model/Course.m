//
//  Course.m
//  Currency
//
//  Created by Cirno on 01/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "Course.h"

@implementation Course
-(instancetype)initWithCourseTitle:(NSString*)title
                           andCode:(NSString*)code
                        andTitleEn:(NSString*)en
                         andCredit:(NSString*)credit
                        andFaculty:(NSString*)faculty{
    self = [super init];
    if (self){
        self.coursecode = code;
        self.courseName = title;
        self.courseEnName = en;
        self.credit = credit;
        self.faculty = faculty;
    }
    return self;
}
@end
