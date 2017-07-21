//
//  MessageHeadView.m
//  MUST_Plus
//
//  Created by Cirno on 05/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "MessageHeadView.h"
#import "BasicHead.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "Account.h"
@implementation MessageHeadView{
    UIButton *face;
}
-(id)initWithFrame:(CGRect)frame{
  //  NSLog(@"%s被调用了",__FUNCTION__);
    self=[super initWithFrame:frame];
    if(self!=nil){
        [self drawTitleView];
    }
    return self;
}

-(void)drawTitleView{
    

   self.backgroundColor =navigationTabColor;
    face = [[UIButton alloc] initWithFrame:CGRectMake(15, StatusBarHeight, 40, 40)];
    face.layer.cornerRadius = face.frame.size.width/2;
    face.clipsToBounds = YES;
    face.layer.borderWidth = 2;
    face.layer.borderColor = [UIColor clearColor].CGColor;
   // [face setImage:[UIImage imageNamed:@"image.jpg"] forState:UIControlStateNormal];
    NSURL *url = [NSURL URLWithString:[[Account shared]getAvatar]];
    [face sd_setImageWithURL:url forState:UIControlStateNormal];
    [face addTarget:self action:@selector(Avatar) forControlEvents:UIControlEventTouchDown];
    face.adjustsImageWhenHighlighted = NO;
    [self addSubview:face];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,StatusBarHeight,Width,NavigationBarHeight)];
    title.text = NSLocalizedString(@"校友圈", "");
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    //加号
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-40, StatusBarHeight+10, 25, 25)];
    [add setImage:[UIImage imageNamed:@"Write"] forState:UIControlStateNormal];
    [self addSubview:add];
    [add addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchDown];
    
}
-(void)Avatar{
    [_messageHeadAddButtonDelegate Avatar];
}
-(void) changeFace{
    NSURL *url = [NSURL URLWithString:[[Account shared]getAvatar]];
    [face sd_setImageWithURL:url forState:UIControlStateNormal];
}

-(void) Click:(id)button{
    [_messageHeadAddButtonDelegate ClickAdd:button];
}
@end
