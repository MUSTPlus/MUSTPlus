//
//  MyClass+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "MyClass+CoreDataProperties.h"

@implementation MyClass (CoreDataProperties)

+ (NSFetchRequest<MyClass *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MyClass"];
}

@dynamic class_EndMonth;
@dynamic class_EndTime;
@dynamic class_Name;
@dynamic class_No;
@dynamic class_Number;
@dynamic class_Room;
@dynamic class_StartMonth;
@dynamic class_StartTime;
@dynamic class_Teacher;
@dynamic class_Week;

@end
