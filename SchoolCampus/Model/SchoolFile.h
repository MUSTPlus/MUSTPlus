//
//  SchoolFile.h
//  MUSTPlus
//
//  Created by Cirno on 2017/7/5.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolFile : NSObject
@property (nonatomic,strong) NSString* desc;
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSString* updatetime;
@property (nonatomic,strong) NSString* type;
-(instancetype)initWithDesc:(NSString*)desc
                     andUrl:(NSString*)url
              andUpdateTime:(NSString*)updatetime
                    andType:(NSString*)type;
@end
