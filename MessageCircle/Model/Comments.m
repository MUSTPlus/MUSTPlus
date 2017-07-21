//
//  Comments.m
//  MUST_Plus
//
//  Created by Cirno on 07/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "Comments.h"
#import "BasicHead.h"
@implementation Comments
-(instancetype)init{
    _comments = [[NSMutableArray alloc]init];
    return self;
}
-(int)countOfComments{
    return (int)[_comments count];
}
-(void) addCommentsDeatils:(CommentDetails*)details{
    [_comments addObject:details];
   // CirnoLog(@"增加评论成功，当前%d",(int)[_comments count]);
}
@end
