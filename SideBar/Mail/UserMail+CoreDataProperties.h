//
//  UserMail+CoreDataProperties.h
//  MUST_Plus
//
//  Created by zbc on 16/11/23.
//  Copyright © 2016年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "UserMail+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserMail (CoreDataProperties)

+ (NSFetchRequest<UserMail *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *mail;

@end

NS_ASSUME_NONNULL_END
