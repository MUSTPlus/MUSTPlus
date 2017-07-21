//
//  BorrowBooks+CoreDataProperties.m
//  MUST_Plus
//
//  Created by zbc on 16/12/5.
//  Copyright © 2016年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "BorrowBooks+CoreDataProperties.h"

@implementation BorrowBooks (CoreDataProperties)

+ (NSFetchRequest<BorrowBooks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BorrowBooks"];
}

@dynamic title;
@dynamic deadLine;

@end
