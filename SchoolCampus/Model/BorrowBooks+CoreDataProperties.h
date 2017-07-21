//
//  BorrowBooks+CoreDataProperties.h
//  MUST_Plus
//
//  Created by zbc on 16/12/5.
//  Copyright © 2016年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "BorrowBooks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BorrowBooks (CoreDataProperties)

+ (NSFetchRequest<BorrowBooks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *deadLine;

@end

NS_ASSUME_NONNULL_END
