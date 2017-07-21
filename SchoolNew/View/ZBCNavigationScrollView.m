
//
//  ZBCNavigationScrollView.m
//  MUST+
//
//  Created by zbc on 16/10/1.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "ZBCNavigationScrollView.h"

@implementation ZBCNavigationScrollView{
    UIView *signView; //用来显示点击了哪个
}


#define contentNumber 6
#define Iphone7plusWidth 414


-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        
        
        
        NSArray *TitleArray = [[NSArray alloc] initWithObjects:@"全部",@"通告",@"活动",@"校园", nil];

        self.contentSize=CGSizeMake(self.frame.size.width,0);
        
        [self setBackgroundColor:[UIColor whiteColor]];
        self.scrollEnabled = YES;
        //取消滚动条显示
        self.showsVerticalScrollIndicator = FALSE;
        self.showsHorizontalScrollIndicator = FALSE;
        
        self.delegate=self;
        
        float titleDistance = self.frame.size.width/[TitleArray count];
        float _x=0;
        
        signView = [[UIView alloc] init];
        signView.frame = CGRectMake(4, self.frame.size.height - 10, titleDistance - 8 , 3);
        signView.backgroundColor = [UIColor colorWithRed:102.0f/255.0f
                                                   green:205.0f/255.0f
                                                    blue:0.0f/255.0f
                                                   alpha:1.0f];
        [self addSubview:signView];
        
        
        for(int index=0;index<[TitleArray count];index++){
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(_x, 0,titleDistance, frame.size.height)];
            [label setTitle:[TitleArray objectAtIndex:index]forState:UIControlStateNormal];
            [label addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
            [label.titleLabel setFont:[UIFont fontWithName:@"yuanti" size: 15.0]];
            [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:label];
            _x+=titleDistance;
        }
    }
    
    return self;
}




-(void) click:(UIButton *)sender{
    int num = 0;
    if([sender.titleLabel.text isEqualToString:@"最新"]){
        num = 0;
    }
    else if([sender.titleLabel.text isEqualToString:@"通告"]){
        num = 1;
    }
    else if([sender.titleLabel.text isEqualToString:@"活动"]){
        num = 2;
    }
    else if([sender.titleLabel.text isEqualToString:@"校园"]){
        num = 3;
    }
    else if([sender.titleLabel.text isEqualToString:@"旅游"]){
        num = 4;
    }
    
    
    float titleDistance = self.frame.size.width/4;
    signView.frame = CGRectMake(num * titleDistance + 4, self.frame.size.height - 10, titleDistance-8, 3);
    
    
    [_schoolNavigationViewDelegate ClickNavigationButton:num];
}

@end
