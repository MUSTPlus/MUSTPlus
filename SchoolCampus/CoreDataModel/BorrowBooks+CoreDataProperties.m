//
//  BorrowBooks+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "BorrowBooks+CoreDataProperties.h"

@implementation BorrowBooks (CoreDataProperties)

+ (NSFetchRequest<BorrowBooks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BorrowBooks"];
}

@dynamic deadLine;
@dynamic title;

@end
