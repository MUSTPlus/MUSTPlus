//
//  Course.h
//  Currency
//
//  Created by Cirno on 01/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject
@property (nonatomic,strong) NSString* coursecode;
@property (nonatomic,strong) NSString* courseName;
@property (nonatomic,strong) NSString* courseEnName;
@property (nonatomic,strong) NSString* credit;
@property (nonatomic,strong) NSString* faculty;
-(instancetype)initWithCourseTitle:(NSString*)title
                           andCode:(NSString*)code
                        andTitleEn:(NSString*)en
                         andCredit:(NSString*)credit
                        andFaculty:(NSString*)faculty;
@end
