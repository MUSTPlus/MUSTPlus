//
//  LikeButton.m
//  MUST_Plus
//
//  Created by Cirno on 13/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "LikeButton.h"

@implementation LikeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self!=nil){
        
    }
    return self;
}
-(void)touchesBegin:(NSSet *)touches withEvent:(UIEvent *)event {
    // TO DO
    // 实现Like操作
    NSLog(@"%s",__func__);
    NSLog(@"点击了分享按钮");
}

@end
