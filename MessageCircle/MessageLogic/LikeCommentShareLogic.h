//
//  LikeCommentShareLogic.h
//  MUST_Plus
//
//  Created by zbc on 16/11/22.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LikeCommentShareLogic : NSObject


+(void)like:(long long)ID;

+(void)comment:(long long)messageID
messageContext:(NSString *)context;

@end
