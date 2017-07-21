//
//  School_news+CoreDataProperties.h
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "School_news+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface School_news (CoreDataProperties)

+ (NSFetchRequest<School_news *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *schoolNewDescribe;
@property (nullable, nonatomic, copy) NSString *schoolNewImageUrl;
@property (nullable, nonatomic, copy) NSString *schoolNewLabel;
@property (nullable, nonatomic, copy) NSString *schoolNewsID;
@property (nullable, nonatomic, copy) NSString *schoolNewTag;
@property (nullable, nonatomic, copy) NSString *schoolNewTime;
@property (nullable, nonatomic, copy) NSString *schoolNewTitle;
@property (nullable, nonatomic, copy) NSString *schoolNewUrl;

@end

NS_ASSUME_NONNULL_END
