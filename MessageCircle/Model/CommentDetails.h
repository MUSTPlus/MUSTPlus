//
//  CommentDetails.h
//  MUST_Plus
//
//  Created by Cirno on 07/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentDetails : NSObject
@property (nonatomic,strong) NSString* studentID;
@property (nonatomic,strong) NSString* avatarURL;
@property (nonatomic,strong) NSString* nickname;
@property (nonatomic,strong) NSString* time;
@property (nonatomic,strong) NSString* context;
@property (nonatomic,strong) NSString* replyNickname;
@property (nonatomic,strong) NSString* commentID;
@property (nonatomic,strong) NSString* isReplyComment;
@property (nonatomic,strong) NSString* ReplyCommentID;

-(void) initWithAvatarURL:(NSString*)avatarURL
                 Nickname:(NSString*)nickname
                     Time:(NSString*)time
                  Context:(NSString*)context
            replyNickname:(NSString*)replynickname
            commentID:(NSString*)commentID
                isReplyComment:(NSString*)isReplyComment
                ReplyCommentID:(NSString*)ReplyCommentID
                studentID:(NSString*)studentID;


@end
