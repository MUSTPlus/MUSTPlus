//
//  UserMail+CoreDataProperties.m
//  MUST_Plus
//
//  Created by zbc on 16/11/23.
//  Copyright © 2016年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "UserMail+CoreDataProperties.h"

@implementation UserMail (CoreDataProperties)

+ (NSFetchRequest<UserMail *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserMail"];
}

@dynamic title;
@dynamic mail;

@end
