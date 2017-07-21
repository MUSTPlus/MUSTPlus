//
//  SmartPlace.h
//  Currency
//
//  Created by Cirno on 31/01/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartPlace : NSObject
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * desc;
@property (nonatomic,strong) NSString * Mon;
@property (nonatomic,strong) NSString * Tue;
@property (nonatomic,strong) NSString * Wed;
@property (nonatomic,strong) NSString * Thu;
@property (nonatomic,strong) NSString * Fri;
@property (nonatomic,strong) NSString * Sat;
@property (nonatomic,strong) NSString * Sun;
@property (nonatomic,strong) NSString * HolidayMon;
@property (nonatomic,strong) NSString * HolidayTue;
@property (nonatomic,strong) NSString * HolidayWed;
@property (nonatomic,strong) NSString * HolidayThu;
@property (nonatomic,strong) NSString * HolidayFri;
@property (nonatomic,strong) NSString * HolidaySat;
@property (nonatomic,strong) NSString * HolidaySun;
@property (nonatomic,strong) NSArray<NSString*>* Work;
@property (nonatomic,strong) NSArray<NSString*>* Holiday;
@property (nonatomic,strong) NSString* tel;
@property (nonatomic,strong) NSDictionary<NSString*,NSString*> * Special;
@property (nonatomic,strong) NSString * Url;
-(instancetype)initWithDic:(NSDictionary*)dic
           andName:(NSString*)name;

@end
