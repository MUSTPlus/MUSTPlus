//
//  Example+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "Example+CoreDataProperties.h"

@implementation Example (CoreDataProperties)

+ (NSFetchRequest<Example *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Example"];
}

@dynamic string1;
@dynamic string2;
@dynamic string3;

@end
