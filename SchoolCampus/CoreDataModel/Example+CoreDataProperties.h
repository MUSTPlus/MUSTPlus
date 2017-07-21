//
//  Example+CoreDataProperties.h
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "Example+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Example (CoreDataProperties)

+ (NSFetchRequest<Example *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *string1;
@property (nullable, nonatomic, copy) NSString *string2;
@property (nullable, nonatomic, copy) NSString *string3;

@end

NS_ASSUME_NONNULL_END
