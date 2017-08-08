//
//  Attendance.h
//  MUSTPlus
//
//  Created by Cirno on 2017/5/4.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attendance : NSObject
@property (nonatomic,strong) NSString* time;
@property (nonatomic,strong) NSString* label;
-(instancetype)initWithLabel:(NSString*)label
                     andTime:(NSString*)time;
@end
