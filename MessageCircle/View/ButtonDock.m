//
//  ButtonDock.m
//  MUST_Plus
//
//  Created by Cirno on 16/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "ButtonDock.h"
#import "UIImage+X.h"
#import "NSString+X.h"
#import "BasicHead.h"
@interface ButtonDock()
{
    UIButton *_repost;
    UIButton *_comment;
    UIButton *_attitute;
}
/**
 NSLocalizedString(@"评论", "")
 NSLocalizedString(@"删除评论", "")
NSLocalizedString(@"删除校友圈", "")
 NSLocalizedString(@"评论删除确认", "")
 NSLocalizedString(@"校友圈删除确认", "")
 **/
@end
@implementation ButtonDock
#pragma mark 在内部固定自己的宽高
-(void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width - 2 * kTableBorderWidth;
    frame.size.height = kStatusDockHeight;
    
    [super setFrame:frame];
}

-(UIButton *)addButton:(NSString *)title icon:(NSString *)icon backgroundImageName:(NSString *)background index:(int)index
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    //设置图标
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    //设置普通背景
    [btn setBackgroundImage:[UIImage resizedImage:background] forState:UIControlStateNormal];
    //设置高亮背景
    [btn setBackgroundImage:[UIImage resizedImage:[background fileAppend:@"_highlighted"]] forState:UIControlStateHighlighted];
    
    //设置文字颜色
    [btn setTitleColor:kColor(188, 188, 188) forState:UIControlStateNormal];
    //设置字体大小
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //设置按钮frame
    CGFloat w = self.frame.size.width / 3;
    btn.frame = CGRectMake(index * w, 0, w, kStatusDockHeight);
    
    //文字左边会空出10的距离，调节按钮文字与图片的间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, kTitleLeftEdgeInsets, 0, 0);
    
    [self addSubview:btn];
    
    if (index) { //index!=0，添加分割线图片
        UIImage *image = [UIImage imageNamed:@"timeline_card_bottom_line.png"];
        UIImageView *divider = [[UIImageView alloc]initWithImage:image];
        divider.center = CGPointMake(btn.frame.origin.x, kStatusDockHeight * 0.5);
        [self addSubview:divider];
    }

    return btn;
}


#pragma mark 两个Button
-(UIButton *)addTwoButton:(NSString *)title icon:(NSString *)icon backgroundImageName:(NSString *)background index:(int)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    //设置图标
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    //设置普通背景
    [btn setBackgroundImage:[UIImage resizedImage:background] forState:UIControlStateNormal];
    //设置高亮背景
    [btn setBackgroundImage:[UIImage resizedImage:[background fileAppend:@"_highlighted"]] forState:UIControlStateHighlighted];
    
    //设置文字颜色
    [btn setTitleColor:kColor(188, 188, 188) forState:UIControlStateNormal];
    //设置字体大小
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //设置按钮frame
    CGFloat w = self.frame.size.width / 2;
    btn.frame = CGRectMake(index * w, 0, w, kStatusDockHeight);
    
    //文字左边会空出10的距离，调节按钮文字与图片的间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, kTitleLeftEdgeInsets, 0, 0);
    
    [self addSubview:btn];
    
    if (index) { //index!=0，添加分割线图片
        UIImage *image = [UIImage imageNamed:@"timeline_card_bottom_line.png"];
        UIImageView *divider = [[UIImageView alloc]initWithImage:image];
        divider.center = CGPointMake(btn.frame.origin.x, kStatusDockHeight * 0.5);
        [self addSubview:divider];
        divider.tag = 9999;
    }
    return btn;
}


-(void)LikeStatus
{
    CirnoLog(@"comment status");
    [self btnClick:_status.ID type:DockButtonTypeLike];
}

-(void)commentStatus
{
    CirnoLog(@"comment status");
    [self btnClick:_status.ID type:DockButtonTypeComment];
}

-(void)shareStatus
{
    CirnoLog(@"share status");
    [self btnClick:_status.ID type:DockButtonTypeShare];
}



- (void)btnClick:(long long)ID type:(DockButtonType)type
{
    CirnoLog(@"type %d", type);
    if ([_delegate respondsToSelector:@selector(optionDock:didClickType:)]) {
        CirnoLog(@"type %d", type);
        [_delegate optionDock:ID didClickType:type];

    }
}
-(void)setStatus:(MainBody *)status
{
    _status = status;
    
    //2.评论
  //  CirnoLog(@"评论：%ld",(long)_status.comments.countOfComments);
    [self setButton:_comment title:NSLocalizedString(@"评论", "") count:(int)_status.comments.countOfComments];

    if(_status.isLiked){
        [_attitute setImage:[UIImage imageNamed:@"timeline_icon_like.png"] forState:UIControlStateNormal];
    }
    else{
        [_attitute setImage:[UIImage imageNamed:@"timeline_icon_unlike.png"] forState:UIControlStateNormal];
    }
    //3.赞

    [self setButton:_attitute title:NSLocalizedString(@"赞", "") count:(int)_status.likes];
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        //设置顶部伸缩,一直附着底部不动
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        //1.添加3个按钮
        _attitute = [self addTwoButton:NSLocalizedString(@"赞", "") icon:@"timeline_icon_unlike.png" backgroundImageName:@"timeline_card_rightbottom.png" index:0];
        [_attitute addTarget:self action:@selector(LikeStatus) forControlEvents:UIControlEventTouchUpInside];

        _comment = [self addTwoButton:NSLocalizedString(@"评论", "") icon:@"timeline_icon_comment.png" backgroundImageName:@"timeline_card_middlebottom.png" index:1];
        [_comment addTarget:self action:@selector(commentStatus) forControlEvents:UIControlEventTouchUpInside];
        
//        _repost = [self addButton:NSLocalizedString(@"分享", "") icon:@"timeline_icon_retweet.png" backgroundImageName:@"timeline_card_leftbottom.png" index:2];
//        [_repost addTarget:self action:@selector(shareStatus) forControlEvents:UIControlEventTouchUpInside];
//
        
    }
    return self;
}



#pragma mark 这里是 赞， 评论， 删除
-(void) selfDockStyle{
    UIView *subviews  = [self viewWithTag:9999];
    [subviews removeFromSuperview];
    [_attitute removeFromSuperview];
    [_repost removeFromSuperview];
    [_comment removeFromSuperview];

    _attitute = [self addButton:NSLocalizedString(@"赞", "") icon:@"timeline_icon_unlike.png" backgroundImageName:@"timeline_card_rightbottom.png" index:0];
    [_attitute addTarget:self action:@selector(LikeStatus) forControlEvents:UIControlEventTouchUpInside];
    _comment = [self addButton:NSLocalizedString(@"评论", "") icon:@"timeline_icon_comment.png" backgroundImageName:@"timeline_card_middlebottom.png" index:1];
    [_comment addTarget:self action:@selector(commentStatus) forControlEvents:UIControlEventTouchUpInside];
    _repost = [self addButton:NSLocalizedString(@"删除", "") icon:@"statusdetail_icon_delete.png" backgroundImageName:@"timeline_card_leftbottom.png" index:2];
    [_repost addTarget:self action:@selector(shareStatus) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 这里是赞， 评论
-(void) otherBttonStyle{
    UIView *subviews  = [self viewWithTag:9999];
    [subviews removeFromSuperview];
    [_attitute removeFromSuperview];
    [_comment removeFromSuperview];
    [_repost removeFromSuperview];
    _attitute = [self addTwoButton:NSLocalizedString(@"赞", "") icon:@"timeline_icon_unlike.png" backgroundImageName:@"timeline_card_rightbottom.png" index:0];
    [_attitute addTarget:self action:@selector(LikeStatus) forControlEvents:UIControlEventTouchUpInside];
    _comment = [self addTwoButton:NSLocalizedString(@"评论", "") icon:@"timeline_icon_comment.png" backgroundImageName:@"timeline_card_middlebottom.png" index:1];
    [_comment addTarget:self action:@selector(commentStatus) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 设置按钮文字
-(void)setButton:(UIButton *)btn title:(NSString *)title count:(int)count
{
    if (count >= 10000) {  //上万
        CGFloat final = count / 10000.0;
        NSString *title = [NSString stringWithFormat:@"%.1f万", final];
        //替换".0"为空串
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [btn setTitle:title forState:UIControlStateNormal];
        
    }else if(count > 0){ //一万以内
        NSString *title = [NSString stringWithFormat:@"%d",(int)count];
        [btn setTitle:title forState:UIControlStateNormal];
    }else{ //没有
        [btn setTitle:title forState:UIControlStateNormal];
    }
}


@end
