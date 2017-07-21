//
//  MyClass+CoreDataProperties.m
//  MUST_Plus
//
//  Created by zbc on 16/11/13.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "MyClass+CoreDataProperties.h"

@implementation MyClass (CoreDataProperties)

+ (NSFetchRequest<MyClass *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MyClass"];
}

@dynamic class_EndMonth;
@dynamic class_Name;
@dynamic class_No;
@dynamic class_Number;
@dynamic class_Room;
@dynamic class_StartMonth;
@dynamic class_StartTime;
@dynamic class_Teacher;
@dynamic class_Week;
@dynamic class_EndTime;

@end
