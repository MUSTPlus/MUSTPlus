//
//  Attendance.m
//  MUSTPlus
//
//  Created by Cirno on 2017/5/4.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "Attendance.h"

@implementation Attendance

-(instancetype)initWithLabel:(NSString*)label
                     andTime:(NSString*)time{
    self = [super init];
    if (self){
        self.label = label;
        self.time = time;
    }
    return self;
}
@end
