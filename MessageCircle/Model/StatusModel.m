//
//  StatusModel.m
//  MUST_Plus
//
//  Created by Cirno on 19/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel
-(void)initWithPic:(NSArray*)picurls
                 andDevice:(NSString*)device
           andCommentCount:(NSInteger*)commentcount
             andLikesCount:(NSInteger*)likescount
                     andID:(long long)ids
{
    self.picUrls       =    picurls;
    self.device        =    device;
    self.commentsCount =    commentcount;
    self.likesCount    =    likescount;
    self.ID            =    ids;
    
}

@end
