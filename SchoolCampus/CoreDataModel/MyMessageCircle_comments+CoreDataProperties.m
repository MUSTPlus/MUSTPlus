//
//  MyMessageCircle_comments+CoreDataProperties.m
//  MUST+
//
//  Created by zbc on 17/3/17.
//  Copyright © 2017年 zbc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MyMessageCircle_comments+CoreDataProperties.h"

@implementation MyMessageCircle_comments (CoreDataProperties)

+ (NSFetchRequest<MyMessageCircle_comments *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MyMessageCircle_comments"];
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
