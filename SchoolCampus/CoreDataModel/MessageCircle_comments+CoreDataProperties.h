//
//  MessageCircle_comments+CoreDataProperties.h
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MessageCircle_comments+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MessageCircle_comments (CoreDataProperties)

+ (NSFetchRequest<MessageCircle_comments *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *commentID;
@property (nullable, nonatomic, copy) NSString *face;
@property (nullable, nonatomic, copy) NSString *isReplyComment;
@property (nullable, nonatomic, copy) NSString *isVip;
@property (nullable, nonatomic, copy) NSString *messageContext;
@property (nullable, nonatomic, copy) NSString *messageID;
@property (nullable, nonatomic, copy) NSString *nickName;
@property (nullable, nonatomic, copy) NSString *replyCommentID;
@property (nullable, nonatomic, copy) NSString *studentID;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, retain) MessageCircle_main *relationship;

@end

NS_ASSUME_NONNULL_END
