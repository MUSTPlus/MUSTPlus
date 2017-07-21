//
//  UserMail+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "UserMail+CoreDataProperties.h"

@implementation UserMail (CoreDataProperties)

+ (NSFetchRequest<UserMail *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserMail"];
}

@dynamic mail;
@dynamic title;

@end
