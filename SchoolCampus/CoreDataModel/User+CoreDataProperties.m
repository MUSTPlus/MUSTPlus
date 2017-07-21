//
//  User+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic avatarPicUrl;
@dynamic gradeType;
@dynamic mainbodyID;
@dynamic majorType;
@dynamic nickName;
@dynamic userID;
@dynamic verifiedType;

@end
