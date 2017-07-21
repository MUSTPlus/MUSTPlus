//
//  MessageCircle_main+CoreDataProperties.h
//  MUST_Plus
//
//  Created by zbc on 16/11/22.
//  Copyright © 2016年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MessageCircle_main+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MessageCircle_main (CoreDataProperties)

+ (NSFetchRequest<MessageCircle_main *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *device;
@property (nullable, nonatomic, copy) NSString *face;
@property (nullable, nonatomic, copy) NSString *gradeType;
@property (nullable, nonatomic, copy) NSString *imageArray;
@property (nullable, nonatomic, copy) NSString *isTop;
@property (nullable, nonatomic, copy) NSString *isVip;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *majorType;
@property (nullable, nonatomic, copy) NSString *messageContext;
@property (nullable, nonatomic, copy) NSString *messageID;
@property (nullable, nonatomic, copy) NSString *nickName;
@property (nullable, nonatomic, copy) NSString *studentID;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *likes;
@property (nullable, nonatomic, retain) NSSet<MessageCircle_comments *> *relationship;

@end

@interface MessageCircle_main (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(MessageCircle_comments *)value;
- (void)removeRelationshipObject:(MessageCircle_comments *)value;
- (void)addRelationship:(NSSet<MessageCircle_comments *> *)values;
- (void)removeRelationship:(NSSet<MessageCircle_comments *> *)values;

@end

NS_ASSUME_NONNULL_END
