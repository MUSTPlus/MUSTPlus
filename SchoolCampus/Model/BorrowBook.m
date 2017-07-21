//
//  BorrowBook.m
//  MUSTBEE
//
//  Created by zbc on 15/10/25.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import "BorrowBook.h"

@implementation BorrowBook


-(void) setData:(NSString *)title
       deadLine:(NSString *)deadLine
{
    self.title = title;
    self.deadline = deadLine;
}


-(NSString *) getTitle{
    return self.title;
}

-(NSString *) getDeadline{
    return self.deadline;
}


@end
