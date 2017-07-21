//
//  School_news+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "School_news+CoreDataProperties.h"

@implementation School_news (CoreDataProperties)

+ (NSFetchRequest<School_news *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"School_news"];
}

@dynamic schoolNewDescribe;
@dynamic schoolNewImageUrl;
@dynamic schoolNewLabel;
@dynamic schoolNewsID;
@dynamic schoolNewTag;
@dynamic schoolNewTime;
@dynamic schoolNewTitle;
@dynamic schoolNewUrl;

@end
