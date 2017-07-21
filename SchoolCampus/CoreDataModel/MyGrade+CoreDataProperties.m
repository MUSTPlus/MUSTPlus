//
//  MyGrade+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MyGrade+CoreDataProperties.h"

@implementation MyGrade (CoreDataProperties)

+ (NSFetchRequest<MyGrade *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MyGrade"];
}

@dynamic className_en;
@dynamic className_zh;
@dynamic credit;
@dynamic grade;

@end
