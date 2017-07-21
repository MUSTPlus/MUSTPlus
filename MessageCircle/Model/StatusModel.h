//
//  StatusModel.h
//  MUST_Plus
//
//  Created by Cirno on 19/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//  此类用于储存Status，即每条消息圈的相关数据
//  TO DO LIST:
//  1. 实现用户分享新闻时在下面显示一个类似微信朋友圈分享链接的框框。
//
//
//
//
//
//

#import <Foundation/Foundation.h>

@interface StatusModel : NSObject
@property (nonatomic, strong) NSArray *picUrls;            // 图片
@property (nonatomic, assign) NSInteger *commentsCount;    // 评论数
@property (nonatomic, assign) NSInteger *likesCount;       // 赞数
@property (nonatomic        ) long long ID;                // 该条消息圈的唯一标识符
@property (nonatomic, copy) NSString *device;              // 来源
-(void)initWithPic:(NSArray*)picurls
         andDevice:(NSString*)device
   andCommentCount:(NSInteger*)commentcount
     andLikesCount:(NSInteger*)likescount
             andID:(long long)ids;
@end
