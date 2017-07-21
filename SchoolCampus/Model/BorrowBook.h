//
//  BorrowBook.h
//  MUSTBEE
//
//  Created by zbc on 15/10/25.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorrowBook : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *deadline;

-(void) setData:(NSString *)title
       deadLine:(NSString *)deadLine;

-(NSString *) getTitle;
-(NSString *) getDeadline;

@end
