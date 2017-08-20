//
//  sectionHeaderView.m
//  MUSTPlus
//
//  Created by zbc on 2017/8/20.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "sectionHeaderView.h"
#import "BasicHead.h"

@implementation sectionHeaderView{
    UIView *lineView;
}

-(id)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor whiteColor];
        
        lineView = [[UIView  alloc] initWithFrame:CGRectMake(20, 25, 50, 3)];
        lineView.backgroundColor = navigationTabColor;
        [self addSubview:lineView];

        _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, 30)];
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(Width - 80, 0, 50, 30)];
        [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_commentButton];
        [self addSubview:_likeButton];
    }
    return self;
}

-(void) addLine:(int) which{
    if(which == 1){
        lineView.frame = CGRectMake(20, 25, 50, 3);
    }
    else{
        lineView.frame = CGRectMake(Width - 80, 25, 50, 3);
    }
}


@end
