//
//  MyGrade+CoreDataProperties.h
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MyGrade+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MyGrade (CoreDataProperties)

+ (NSFetchRequest<MyGrade *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *className_en;
@property (nullable, nonatomic, copy) NSString *className_zh;
@property (nullable, nonatomic, copy) NSString *credit;
@property (nullable, nonatomic, copy) NSString *grade;

@end

NS_ASSUME_NONNULL_END
