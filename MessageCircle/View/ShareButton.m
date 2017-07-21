//
//  ShareButton.m
//  MUST_Plus
//
//  Created by Cirno on 13/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "ShareButton.h"
#import "BasicHead.h"
@implementation ShareButton
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self!=nil){
        _image = [UIImage imageNamed:@"more-share"];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.8, self.bounds.size.height/3, 32, 32)];
        _share = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height/3,self.bounds.size.width/2, self.bounds.size.height)];
        _share.text = @"分享";
        [self addSubview:_imageView];
        [self addSubview:_share];
        
        
    }
    return self;
}
-(void)touchesBegin:(NSSet *)touches withEvent:(UIEvent *)event {
    // TO DO
    // 实现分享操作
    NSLog(@"%s",__func__);
    NSLog(@"点击了分享按钮");
}
@end
