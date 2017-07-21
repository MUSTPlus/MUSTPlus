//
//  MyClass+CoreDataProperties.h
//  MUST_Plus
//
//  Created by zbc on 16/11/13.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "MyClass+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MyClass (CoreDataProperties)

+ (NSFetchRequest<MyClass *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *class_EndMonth;
@property (nullable, nonatomic, copy) NSString *class_Name;
@property (nullable, nonatomic, copy) NSString *class_No;
@property (nullable, nonatomic, copy) NSString *class_Number;
@property (nullable, nonatomic, copy) NSString *class_Room;
@property (nullable, nonatomic, copy) NSString *class_StartMonth;
@property (nullable, nonatomic, copy) NSString *class_StartTime;
@property (nullable, nonatomic, copy) NSString *class_Teacher;
@property (nullable, nonatomic, copy) NSString *class_Week;
@property (nullable, nonatomic, copy) NSString *class_EndTime;

@end

NS_ASSUME_NONNULL_END
