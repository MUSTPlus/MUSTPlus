//
//  TimetableLogic.h
//  MUST_Plus
//
//  Created by zbc on 16/11/9.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolClassModel.h"

@interface TimetableLogic : NSObject

+(NSMutableArray *) CheckClassInMonth:(NSMutableArray <SchoolClassModel *> *)schoolClasses;
+(NSMutableArray *) CheckClassInMonth:(NSMutableArray <SchoolClassModel *> *)schoolClasses
                             WithDate:(NSDate*)date;
@end
