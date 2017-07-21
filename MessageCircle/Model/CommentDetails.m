//
//  CommentDetails.m
//  MUST_Plus
//
//  Created by Cirno on 07/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "CommentDetails.h"

@implementation CommentDetails
-(void) initWithAvatarURL:(NSString*)avatarURL
                 Nickname:(NSString*)nickname
                     Time:(NSString*)time
                  Context:(NSString*)context
            replyNickname:(NSString*)replynickname
            commentID:(NSString*)commentID
           isReplyComment:(NSString*)isReplyComment
           ReplyCommentID:(NSString*)ReplyCommentID
                studentID:(NSString*)studentID{
    _avatarURL=avatarURL;
    _nickname=nickname;
    _time=time;
    _context=context;
    _replyNickname=replynickname;
    _commentID = commentID;
    _isReplyComment = isReplyComment;
    _ReplyCommentID = ReplyCommentID;
    _studentID=studentID;
}

-(BOOL)isReplyNicknameEmpty{
    return [_replyNickname length]==0;
}
@end
