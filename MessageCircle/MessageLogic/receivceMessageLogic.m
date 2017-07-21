//
//  receivceMessageLogic.m
//  MUST_Plus
//
//  Created by zbc on 16/11/20.
//  Copyright © 2016年 zbc. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-W"
#import "receivceMessageLogic.h"
#import "MessageCoreDataManagement.h"
#import "MessageCircle_comments+CoreDataClass.h"
#import "MessageCircle_main+CoreDataClass.h"
#import "CommentDetails.h"
#import "Comments.h"
#import "MainBody.h"
#import "ImageSet.h"
#import "UserModel.h"
#import "BasicHead.h"
#import "Account.h"
@implementation receivceMessageLogic


//拿数据
+(NSMutableArray *) getDataFromCoreData{
    MessageCoreDataManagement *dataManagement = [[MessageCoreDataManagement alloc] init];
    
    NSMutableArray *mainBodyArray = [[NSMutableArray alloc] init];
    
    NSMutableArray<MessageCircle_main *> *mainArray = [[NSMutableArray alloc] init];
    mainArray = [dataManagement selectData:0 andOffset:0];
    
    for (MessageCircle_main *main in mainArray){

        //用户
         UserModel *usr =[[UserModel alloc]init];
        [usr initWithNickname:main.nickName andAvatarURL:main.face andGradeType:main.gradeType  andMajorType:main.majorType];
        
        
        usr.verifiedtype = [main.isVip intValue];

        Comments * comments = [[Comments alloc]init];
            //加评论
        for(MessageCircle_comments *comment in main.relationship){
            CommentDetails * details = [[CommentDetails alloc] init];
            [details initWithAvatarURL:comment.face
                              Nickname:comment.nickName
                                  Time:comment.time
                               Context:comment.messageContext
                         replyNickname:nil
                             commentID:comment.commentID
                        isReplyComment:comment.isReplyComment
                        ReplyCommentID:comment.replyCommentID
                             studentID:comment.studentID
             ];
            [comments addCommentsDeatils:details];
        }

        //图片
        ImageSet *sets = [[ImageSet alloc] init];
        if([main.imageArray isEqualToString:@""]){
            
        }
        else{
            NSArray *imageArray = [main.imageArray componentsSeparatedByString:@";"];
            for (NSString *imageUrl in imageArray){
                [sets addPicUrls:imageUrl];
            }
        }
        
        
        
        
        long likeNum = 0;
        NSArray *like;
        
        if([main.likes isEqualToString:@""]){
        }
        else{
            like = [main.likes componentsSeparatedByString:@";"];
            likeNum = [like count];
        }
        
        BOOL isLiked = false;
        if ([like containsObject:[[Account shared] getStudentLongID]]){
            isLiked = true;
        }
        
        //本体
        MainBody * mainbody= [[MainBody alloc]init];
        
        
        [mainbody initAvatarURL:main.face StudentID:main.studentID UserModel:usr Time:main.time Context:main.messageContext Device:main.device Location:main.location Likes:(NSInteger*)likeNum ID:[main.messageID longLongValue] Comments:comments imageSets:sets isTop:[main.isTop boolValue] isLiked:isLiked];
        
        [mainBodyArray addObject:mainbody];
        
    }
    return mainBodyArray;
}



//1.下拉刷新
//目前做的只能抛弃所有数据来达到评论更新了，其实可以不抛弃，没办法，懒

+(NSMutableArray *) pullDownToRefresh:(NSMutableArray *)oldNews
                           reciveNews:(id)json{
    
    MessageCoreDataManagement *magege =  [[MessageCoreDataManagement alloc] init];
    
    [magege deleteData];//抛弃所有数据
    [oldNews removeAllObjects];

    NSMutableArray *newsArray = [[NSMutableArray alloc] initWithArray:json[@"msg"][@"contents"]];
    
    for(NSDictionary *arr in newsArray){
        NSMutableDictionary *messageDic = arr[@"message"];
        NSMutableArray *commentsArray = arr[@"comments"];
        [magege insertCoreData:messageDic commentDataArray:commentsArray];
        
        
        UserModel *usr =[[UserModel alloc]init];
        [usr initWithNickname:[messageDic objectForKey:@"nickName"]
                 andAvatarURL:[messageDic objectForKey:@"face"]
                 andGradeType:[messageDic objectForKey:@"GradeType"]
                 andMajorType:[messageDic objectForKey:@"MajorType"]];
        
        usr.verifiedtype = [[messageDic objectForKey:@"isVip"] intValue];

        Comments * comments = [[Comments alloc]init];
        //加评论
        for(NSDictionary *comment in commentsArray){
            CommentDetails * details = [[CommentDetails alloc]init];
            [details initWithAvatarURL:[comment objectForKey:@"face"]
                              Nickname:[comment objectForKey:@"nickName"]
                                  Time:[comment objectForKey:@"time"]
                               Context:[comment objectForKey:@"messageContext"]
                         replyNickname:nil
                             commentID:[[comment objectForKey:@"commentID"] stringValue]
                        isReplyComment:[[comment objectForKey:@"isReplyComment"] stringValue]
                        ReplyCommentID:[[comment objectForKey:@"ReplyCommentID"] stringValue]
                             studentID:[comment objectForKey:@"studentID"]
             ];
            [comments addCommentsDeatils:details];
        }
        
        //图片
        ImageSet *sets = [[ImageSet alloc] init];

        if([[messageDic objectForKey:@"imageArray"] isEqualToString:@""]){
        }
        else{
            NSArray *imageArray = [[messageDic objectForKey:@"imageArray"] componentsSeparatedByString:@";"];
            for (NSString *imageUrl in imageArray){
                [sets addPicUrls:imageUrl];
            }
        }
        
        long likeNum = 0;
        NSArray *like;
        
        if([[messageDic objectForKey:@"like"] isEqualToString:@""]){
        }
        else{
            like = [[messageDic objectForKey:@"like"] componentsSeparatedByString:@";"];
            likeNum = [like count];
        }
        
        BOOL isLiked = false;
        if ([like containsObject:[[Account shared] getStudentLongID]]){
            isLiked = true;
        }
        
        //本体,k
        MainBody * mainbody= [[MainBody alloc]init];
        [mainbody initAvatarURL:[messageDic objectForKey:@"face"] StudentID:[messageDic objectForKey:@"studentID"] UserModel:usr Time:[messageDic objectForKey:@"time"] Context:[messageDic objectForKey:@"messageContext"] Device:[messageDic objectForKey:@"device"] Location:[messageDic objectForKey:@"location"] Likes:(NSInteger*)likeNum ID:[[messageDic objectForKey:@"messageID"] longLongValue] Comments:comments imageSets:sets isTop:[[messageDic objectForKey:@"isTop"]boolValue] isLiked:isLiked];
        
        [oldNews addObject:mainbody];
    }
    
    return oldNews;
}



//2.上拉加载
+(NSMutableArray *) pullUpToRefresh:(NSMutableArray *)oldNews
                         reciveNews:(id)json{

    
    MessageCoreDataManagement *magege =  [[MessageCoreDataManagement alloc] init];
    
    NSMutableArray *newsArray = [[NSMutableArray alloc] initWithArray:json[@"msg"][@"contents"]];
    for(NSDictionary *arr in newsArray){
        NSMutableDictionary *messageDic = arr[@"message"];
        NSMutableArray *commentsArray = arr[@"comments"];
        [magege insertCoreData:messageDic commentDataArray:commentsArray];
        

        UserModel *usr =[[UserModel alloc]init];
        [usr initWithNickname:[messageDic objectForKey:@"nickName"]
                 andAvatarURL:[messageDic objectForKey:@"face"]
                 andGradeType:[messageDic objectForKey:@"GradeType"]
                 andMajorType:[messageDic objectForKey:@"MajorType"]];
        
        usr.verifiedtype = [[messageDic objectForKey:@"isVip"] intValue];

        Comments * comments = [[Comments alloc]init];
        //加评论
        for(NSDictionary *comment in commentsArray){
            CommentDetails * details = [[CommentDetails alloc]init];
            [details initWithAvatarURL:[comment objectForKey:@"face"]
                              Nickname:[comment objectForKey:@"nickName"]
                                  Time:[comment objectForKey:@"time"]
                               Context:[comment objectForKey:@"messageContext"]
                         replyNickname:nil
                             commentID:[[comment objectForKey:@"commentID"] stringValue]
                        isReplyComment:[[comment objectForKey:@"isReplyComment"] stringValue]
                        ReplyCommentID:[[comment objectForKey:@"ReplyCommentID"] stringValue]
             studentID:[comment objectForKey:@"studentID"]];
            [comments addCommentsDeatils:details];
        }
        
        //图片
        ImageSet *sets = [[ImageSet alloc] init];
        
        if([[messageDic objectForKey:@"imageArray"] isEqualToString:@""]){
        }
        else{
            NSArray *imageArray = [[messageDic objectForKey:@"imageArray"] componentsSeparatedByString:@";"];
                for (NSString *imageUrl in imageArray){
                    [sets addPicUrls:imageUrl];
                }
        }
        
        
        long likeNum = 0;
        NSArray *like;
        
        if([[messageDic objectForKey:@"like"] isEqualToString:@""]){
        }
        else{
            like = [[messageDic objectForKey:@"like"] componentsSeparatedByString:@";"];
            likeNum = [like count];
        }
        
        
        BOOL isLiked = false;
        if ([like containsObject:[[Account shared] getStudentLongID]]){
            isLiked = true;
        }
        
        //本体
        MainBody * mainbody= [[MainBody alloc]init];
        [mainbody initAvatarURL:[messageDic objectForKey:@"face"] StudentID:[messageDic objectForKey:@"studentID"] UserModel:usr Time:[messageDic objectForKey:@"time"] Context:[messageDic objectForKey:@"messageContext"] Device:[messageDic objectForKey:@"device"] Location:[messageDic objectForKey:@"location"] Likes:(NSInteger*)likeNum ID:[[messageDic objectForKey:@"messageID"] longLongValue] Comments:comments imageSets:sets isTop:[[messageDic objectForKey:@"isTop"]boolValue] isLiked:isLiked];
        
        [oldNews addObject:mainbody];
    }
    
    return oldNews;
    
}


+(void)Addlike:(long long)ID
                 studentID:(NSString *)String
{
    NSString *IDstr  = [NSString stringWithFormat:@"%lld",ID];
    MessageCoreDataManagement *magege =  [[MessageCoreDataManagement alloc] init];
    [magege updateLike:IDstr withString:String];
}


+(void)addComment:(long long)ID
     Comment:(NSMutableDictionary *)String
     CommentID:(long long)commentID
{
    NSString *IDstr  = [NSString stringWithFormat:@"%lld",ID];
    NSLog(@"%lld",commentID);
    MessageCoreDataManagement *magege =  [[MessageCoreDataManagement alloc] init];
    [magege updateComment:IDstr withComment:String withCommentID:commentID];
}


+(NSMutableArray *) getMainBodyByMessageID:(long long)ID{
    NSString *IDstr  = [NSString stringWithFormat:@"%lld",ID];
    MessageCoreDataManagement *magege =  [[MessageCoreDataManagement alloc] init];
    
    
    NSMutableArray *mainBodyArray = [[NSMutableArray alloc] init];
    
    NSMutableArray<MessageCircle_main *> *mainArray = [[NSMutableArray alloc] init];
    mainArray = [magege messageID:IDstr];
    
    for (MessageCircle_main *main in mainArray){
        
        
        //用户
        UserModel *usr =[[UserModel alloc]init];
        [usr initWithNickname:main.nickName andAvatarURL:main.face andGradeType:main.gradeType andMajorType:main.majorType];
        
        
        usr.verifiedtype = [main.isVip intValue];
        
        Comments * comments = [[Comments alloc]init];
        //加评论
        for(MessageCircle_comments *comment in main.relationship){
            CommentDetails * details = [[CommentDetails alloc] init];
            [details initWithAvatarURL:comment.face
                              Nickname:comment.nickName
                                  Time:comment.time
                               Context:comment.messageContext
                         replyNickname:nil
                             commentID:comment.commentID
                        isReplyComment:comment.isReplyComment
                        ReplyCommentID:comment.replyCommentID
                        studentID:comment.studentID
             ];
            [comments addCommentsDeatils:details];
        }
        
        //图片
        ImageSet *sets = [[ImageSet alloc] init];
        if([main.imageArray isEqualToString:@""]){
            
        }
        else{
            NSArray *imageArray = [main.imageArray componentsSeparatedByString:@";"];
            for (NSString *imageUrl in imageArray){
                [sets addPicUrls:imageUrl];
            }
        }
        
        
        
        
        long likeNum = 0;
        NSArray *like;
        
        if([main.likes isEqualToString:@""]){
        }
        else{
            like = [main.likes componentsSeparatedByString:@";"];
            likeNum = [like count];
        }
        
        BOOL isLiked = false;
        if ([like containsObject:[[Account shared] getStudentLongID]]){
            isLiked = true;
        }
        
        
        //本体
        MainBody * mainbody= [[MainBody alloc]init];
        
        
        [mainbody initAvatarURL:main.face StudentID:main.studentID UserModel:usr Time:main.time Context:main.messageContext Device:main.device Location:main.location Likes:(NSInteger*)likeNum ID:[main.messageID longLongValue] Comments:comments imageSets:sets isTop:[main.isTop boolValue] isLiked:isLiked];
        [mainBodyArray addObject:mainbody];
        
    }
    return mainBodyArray;
}


+(void)deleteMessage:(long long)ID{
    NSString *IDstr  = [NSString stringWithFormat:@"%lld",ID];
    MessageCoreDataManagement *magege =  [[MessageCoreDataManagement alloc] init];
    [magege deleteDataByID:IDstr];
}


+(void) cancelLikeMessage:(long long)ID{
    NSString *IDstr  = [NSString stringWithFormat:@"%lld",ID];
    MessageCoreDataManagement *magege =  [[MessageCoreDataManagement alloc] init];
    [magege cancelMessage:IDstr];
}


+(void) deleteComment:(NSString *)ID{
    MessageCoreDataManagement *magege =  [[MessageCoreDataManagement alloc] init];
    [magege deleteCommetByMessageID:ID];
}

@end
#pragma clang diagnostic pop
