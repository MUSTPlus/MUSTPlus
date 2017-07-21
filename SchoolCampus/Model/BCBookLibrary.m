//
//  BCBookLibrary.m
//  MUSTBEE
//
//  Created by zbc on 15/10/21.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import "BCBookLibrary.h"

@implementation BCBookLibrary


-(id) init{
    self = [super init];
    return self;
}

-(void)SaveData:(NSString *)Item
          BookInfo:(NSString *)info
       placeNumber:(int) placeNumber
            number: (NSMutableArray *) number
             place: (NSMutableArray *) place
             state: (NSMutableArray *)state{
    self.Item = Item;
    self.info = info;
    self.placeNumber = placeNumber;
    self.number = number;
    self.place = place;
    self.state = state;
}

-(NSString *)getItem{
    return self.Item;
}

-(NSString *)getBookInfo{
    return self.info;
}

-(int)getplaceNumber{
    return self.placeNumber;
}

-(NSMutableArray *)getNumber{
    return self.number;
}

-(NSMutableArray *)getPlace{
    return self.place;
}

-(NSMutableArray *)getState{
    return self.state;
}

@end
