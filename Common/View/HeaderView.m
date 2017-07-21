//
//  HeaderView.m
//  MUST_Plus
//
//  Created by zbc on 16/10/7.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "HeaderView.h"
#import "BasicHead.h"
#import "Account.h"
#import <SDWebImage/UIButton+WebCache.h>
@implementation HeaderView{
    UIButton *face;
}

    
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){

        
    }
    return self;
}
    
-(void)drawHeadViewWithTtile:(NSString *)titleString
                buttonImage:(NSString *)buttonImgString{
    
    self.backgroundColor = navigationTabColor;
    

//    face = [[UIButton alloc] initWithFrame:CGRectMake(15, StatusBarHeight, 40, 40)];
//    face.layer.cornerRadius = face.frame.size.width/2;
//    face.clipsToBounds = YES;
//    face.layer.borderWidth = 2;
//    face.layer.borderColor = [UIColor clearColor].CGColor;
//    NSURL *url = [NSURL URLWithString:[[Account shared]getAvatar]];
//    [face sd_setImageWithURL:url forState:UIControlStateNormal];
//    face.adjustsImageWhenHighlighted = NO;
//    [self addSubview:face];
//    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,StatusBarHeight,Width,NavigationBarHeight)];
    title.text = titleString;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    //加号
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-43, StatusBarHeight, NavigationBarHeight, NavigationBarHeight)];
    [add setImage:[UIImage imageNamed:buttonImgString] forState:UIControlStateNormal];
    [self addSubview:add];
    [add addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchDown];
}

-(void) changeFace{
    NSURL *url = [NSURL URLWithString:[[Account shared]getAvatar]];
    [face sd_setImageWithURL:url forState:UIControlStateNormal];
}

-(void) Click:(id)button{
 //   NSLog(@"%s被调用了",__FUNCTION__);
    [_headButtonDelegate ClickAdd:button];
}
    
@end
