//
//  User+CoreDataProperties.h
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avatarPicUrl;
@property (nonatomic) int16_t gradeType;
@property (nullable, nonatomic, copy) NSString *mainbodyID;
@property (nonatomic) int16_t majorType;
@property (nullable, nonatomic, copy) NSString *nickName;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nonatomic) int16_t verifiedType;

@end

NS_ASSUME_NONNULL_END
