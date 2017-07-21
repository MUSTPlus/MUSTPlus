//
//  RootPopView.m
//  yimashuo
//
//  Created by imqiuhang on 15/10/14.
//  Copyright © 2015年 imqiuhang. All rights reserved.
//

#import "RootPopView.h"

#define RootpopviewTag 97080000

@implementation RootPopView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.totalAnimationDuration = 0.3f;
    
    self.tag   = RootpopviewTag;
    self.frame = KEY_WINDOW.bounds;
    self.backgroundColor = [UIColor clearColor];
    
    backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0.f;
    [self addSubview:backgroundView];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, [self heightForContentView])];
    [self addSubview:contentView];
    contentView.top = self.height;
    contentView.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
    [backgroundView addGestureRecognizer:tap];
    
    [self prepareForContentSubView];

}

- (void)tapEvent {
    [self hide:YES];
}

- (void)showWithTag:(int)tag {
    
    _showTag= tag;
    if ([KEY_WINDOW viewWithTag:RootpopviewTag]) {
        [[KEY_WINDOW viewWithTag:RootpopviewTag] removeFromSuperview];
    }
    [KEY_WINDOW addSubview:self];
    contentView.height = [self heightForContentView];
    contentView.top = self.height;
    [UIView animateWithDuration:self.totalAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.bottom=self.height;
        backgroundView.alpha = 0.4f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide:(BOOL)animation {
    [UIView animateWithDuration:self.totalAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.top = self.height;
        backgroundView.alpha=0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (float)heightForContentView {
    return 250.f;
}

- (void)prepareForContentSubView {}

@end
