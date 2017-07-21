//
//  ImageItemView.m
//  MUST_Plus
//
//  Created by Cirno on 13/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "ImageItemView.h"
#import "BasicHead.h"
#import <SDWebImage/UIImageView+WebCache.h>

//#import "HttpTool.h"
@interface ImageItemView ()
{
    UIImageView *_gifView;
}
@end
@implementation ImageItemView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *gifView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeline_image_gif.png"]];
        [self addSubview:gifView];
        _gifView = gifView;
    }
    
    return self;
}
-(void)setUrl:(NSString *)url
{
    _url = url;
    //1.加载图片
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Icon.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    //2.判断是否为gif
  //  CirnoLog(@"@URL:%@",url);
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    [self addGestureRecognizer:longTap];
    if([url.lowercaseString hasSuffix:@"gif"]){
        _gifView.hidden = NO;
    }else{
        _gifView.hidden = YES;
    }
}
-(void)imglongTapClick:(UILongPressGestureRecognizer *)gesture{
}
-(void)setFrame:(CGRect)frame
{
    //1.设置gifView的位置
    CGRect gifFrame = _gifView.frame;
    gifFrame.origin.x = frame.size.width - gifFrame.size.width;
    gifFrame.origin.y = frame.size.height - gifFrame.size.height;
    _gifView.frame = gifFrame;
    
    [super setFrame:frame];
}

@end
