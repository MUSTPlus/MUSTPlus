//
//  ZBCNewView.m
//  MUST_Plus
//
//  Created by zbc on 16/10/2.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "ZBCNewView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZBCNewView

//tag 表示右下角的小标签，title表示标题，image是图片的URL，describe表示简单的介绍，time左下角的时间
-(void) setData:(NSString *)title
       newImage:(NSString *)image
    newDescribe:(NSString *)describe
           time:(NSString *)time
            url:(NSString *)url
         newTag:(int)tag
{
    self.title.text = title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"default"]];
    self.time.text = time;
    self.describe.text = describe;
    self.newsTag.image = [UIImage imageNamed:[NSString stringWithFormat:@"tag%d",tag]];
}


-(void)draw{
    
}

@end
