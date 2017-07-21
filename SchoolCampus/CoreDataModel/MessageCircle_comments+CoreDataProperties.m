//
//  MessageCircle_comments+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MessageCircle_comments+CoreDataProperties.h"

@implementation MessageCircle_comments (CoreDataProperties)

+ (NSFetchRequest<MessageCircle_comments *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MessageCircle_comments"];
}

@dynamic commentID;
@dynamic face;
@dynamic isReplyComment;
@dynamic isVip;
@dynamic messageContext;
@dynamic messageID;
@dynamic nickName;
@dynamic replyCommentID;
@dynamic studentID;
@dynamic time;
@dynamic relationship;

@end
