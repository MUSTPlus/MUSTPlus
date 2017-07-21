//
//  BCBookLibrary.h
//  MUSTBEE
//
//  Created by zbc on 15/10/21.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCBookLibrary : NSObject


@property (nonatomic,strong) NSString *Item;
@property (nonatomic,strong) NSString *info;
@property  int placeNumber;
@property (nonatomic,strong) NSMutableArray *number;
@property (nonatomic,strong) NSMutableArray *place;
@property (nonatomic,strong) NSMutableArray *state;


-(id) init;

-(void) SaveData:(NSString *)Item
          BookInfo:(NSString *)info
       placeNumber:(int) placeNumber
            number: (NSMutableArray *) number
             place: (NSMutableArray *) place
             state: (NSMutableArray *)state;

-(NSString *)getItem;
-(NSString *)getBookInfo;
-(int)getplaceNumber;
-(NSMutableArray *)getNumber;
-(NSMutableArray *)getPlace;
-(NSMutableArray *)getState;

@end
