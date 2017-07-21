//
//  UserMail+CoreDataProperties.h
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "UserMail+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserMail (CoreDataProperties)

+ (NSFetchRequest<UserMail *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *mail;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
