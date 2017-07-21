//
//  SmartPlace.m
//  Currency
//
//  Created by Cirno on 31/01/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "SmartPlace.h"

@implementation SmartPlace
-(instancetype)initWithDic:(NSDictionary*)dic
           andName:(NSString*)name{
    self = [super init];
    if (self){
        self.name = [[NSString alloc]initWithString:name];
        self.desc = [dic valueForKey:@"Description"];
        self.Mon = [[dic valueForKey:@"Normal"]valueForKey:@"Mon"];
        self.Tue = [[dic valueForKey:@"Normal"]valueForKey:@"Tue"];
        self.Wed = [[dic valueForKey:@"Normal"]valueForKey:@"Wed"];
        self.Thu = [[dic valueForKey:@"Normal"]valueForKey:@"Thu"];
        self.Fri = [[dic valueForKey:@"Normal"]valueForKey:@"Fri"];
        self.Sat = [[dic valueForKey:@"Normal"]valueForKey:@"Sat"];
        self.Sun = [[dic valueForKey:@"Normal"]valueForKey:@"Sun"];
        self.Work = [[NSArray alloc]initWithObjects:
                     self.Mon,
                     self.Tue,
                     self.Wed,
                     self.Thu,
                     self.Fri,
                     self.Sat,
                     self.Sun,
                     nil];
        self.HolidayMon = [[dic valueForKey:@"Holiday"]valueForKey:@"Mon"];
        self.HolidayTue = [[dic valueForKey:@"Holiday"]valueForKey:@"Tue"];
        self.HolidayWed = [[dic valueForKey:@"Holiday"]valueForKey:@"Wed"];
        self.HolidayThu = [[dic valueForKey:@"Holiday"]valueForKey:@"Thu"];
        self.HolidayFri = [[dic valueForKey:@"Holiday"]valueForKey:@"Fri"];
        self.HolidaySat = [[dic valueForKey:@"Holiday"]valueForKey:@"Sat"];
        self.HolidaySun = [[dic valueForKey:@"Holiday"]valueForKey:@"Sun"];
        self.Holiday = [[NSArray alloc]initWithObjects:
                        self.HolidayMon,
                        self.HolidayTue,
                        self.HolidayWed,
                        self.HolidayThu,
                        self.HolidayFri,
                        self.HolidaySat,
                        self.HolidaySun,
                        nil];
        self.Url = [dic valueForKey:@"URL"];
        self.tel = [dic valueForKey:@"TEL"];
        if (self.Special==nil)
            self.Special = [[NSDictionary alloc]init];
        self.Special =[dic valueForKey:@"Special"];
    }
    return self;

}
@end
