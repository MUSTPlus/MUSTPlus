//
//  MyMessageCircle_main+CoreDataProperties.h
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MyMessageCircle_main+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MyMessageCircle_main (CoreDataProperties)

+ (NSFetchRequest<MyMessageCircle_main *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *device;
@property (nullable, nonatomic, copy) NSString *face;
@property (nullable, nonatomic, copy) NSString *gradeType;
@property (nullable, nonatomic, copy) NSString *imageArray;
@property (nullable, nonatomic, copy) NSString *isTop;
@property (nullable, nonatomic, copy) NSString *isVip;
@property (nullable, nonatomic, copy) NSString *likes;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *majorType;
@property (nullable, nonatomic, copy) NSString *messageContext;
@property (nullable, nonatomic, copy) NSString *messageID;
@property (nullable, nonatomic, copy) NSString *nickName;
@property (nullable, nonatomic, copy) NSString *studentID;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, retain) NSSet<MyMessageCircle_comments *> *relationship;

@end

@interface MyMessageCircle_main (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(MyMessageCircle_comments *)value;
- (void)removeRelationshipObject:(MyMessageCircle_comments *)value;
- (void)addRelationship:(NSSet<MyMessageCircle_comments *> *)values;
- (void)removeRelationship:(NSSet<MyMessageCircle_comments *> *)values;

@end

NS_ASSUME_NONNULL_END
