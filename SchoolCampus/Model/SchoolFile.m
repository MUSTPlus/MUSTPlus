//
//  SchoolFile.m
//  MUSTPlus
//
//  Created by Cirno on 2017/7/5.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "SchoolFile.h"

@implementation SchoolFile
-(instancetype)initWithDesc:(NSString*)desc
                     andUrl:(NSString*)url
              andUpdateTime:(NSString*)updatetime
                    andType:(NSString*)type{
    self = [super init];
    if (self){
        self.desc = desc;
        self.url = url;
        self.updatetime = updatetime;
        self.type = type;

    }
    return self;
}
@end
