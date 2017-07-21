//
//  CardDownAnimationView.m
//  yimashuo
//
//  Created by imqiuhang on 15/9/23.
//  Copyright © 2015年 imqiuhang. All rights reserved.
//

#import "CardDownAnimationView.h"
#import "POP.h"


@implementation CardDownAnimationView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = KEY_WINDOW.bounds;
        self.totalAnimationDuration = 0.6f;
        [self initView];
        [self prepareForContentSubView];
    }
    return self;
}


- (void)initView {
    backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.f;
    [self addSubview:backgroundView];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 370)];
    contentView.layer.cornerRadius = 10.f;
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
}

- (void)prepareForContentSubView{}

- (void)show {
    _isShow = YES;
    if ([self.delegate respondsToSelector:@selector(cardDownAnimationViewWillShow:)]) {
        [self.delegate cardDownAnimationViewWillShow:self];
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    contentView.centerX = self.width/2.f;
    contentView.bottom = 0.f;
    [contentView.layer setAffineTransform:CGAffineTransformMakeRotation(M_PI*15/360.0)];
    
    backgroundView.alpha = 0.f;
    
    
    POPSpringAnimation *positionanim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionanim.springBounciness = 6;
    positionanim.springSpeed = 10;
    positionanim.toValue = @(self.centerY);
    
    POPBasicAnimation *rotationAnim1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnim1.duration =  self.totalAnimationDuration*3/5;
    rotationAnim1.toValue = @(M_PI*-3/360.0);
    rotationAnim1.beginTime = CACurrentMediaTime() + 0.f;
    
    POPBasicAnimation *rotationAnim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnim2.duration =  self.totalAnimationDuration*1/5;
    rotationAnim2.toValue = @(M_PI*1/360.0);
    rotationAnim2.beginTime = rotationAnim1.duration+rotationAnim1.beginTime;
    
    
    POPBasicAnimation *rotationAnim3 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnim3.duration =  self.totalAnimationDuration*1/5;
    rotationAnim3.toValue = @(0);
    rotationAnim3.beginTime = rotationAnim2.duration+rotationAnim2.beginTime;
    
    
    
    [contentView.layer pop_addAnimation:positionanim forKey:@"positionanim"];
    [contentView.layer pop_addAnimation:rotationAnim1 forKey:@"rotationAnim1"];
    [contentView.layer pop_addAnimation:rotationAnim2 forKey:@"rotationAnim2"];
    [contentView.layer pop_addAnimation:rotationAnim3 forKey:@"rotationAnim3"];
    
    [UIView animateWithDuration:self.totalAnimationDuration animations:^{
       backgroundView.alpha = 0.5f;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(cardDownAnimationViewDidShow:)]) {
            [self.delegate cardDownAnimationViewDidShow:self];
        }
    }];
}

- (void)hide {
    _isShow = NO;
    if ([self.delegate respondsToSelector:@selector(cardDownAnimationViewWillHide:)]) {
        [self.delegate cardDownAnimationViewWillHide:self];
    }
    [UIView animateWithDuration:self.totalAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backgroundView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(cardDownAnimationViewDidHide:)]) {
            [self.delegate cardDownAnimationViewDidHide:self];
        }
        [self removeFromSuperview];
    }];
    
    POPBasicAnimation *positionAnim1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnim1.duration =  self.totalAnimationDuration*1/5;
    positionAnim1.toValue = @(contentView.centerY+50);
    positionAnim1.beginTime = CACurrentMediaTime() + 0.f;
    
    POPBasicAnimation *positionAnim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnim2.duration =  self.totalAnimationDuration*4/5;
    positionAnim2.toValue = @(-contentView.height/2);
    positionAnim2.beginTime = positionAnim1.beginTime+positionAnim1.duration;
    
    [contentView.layer pop_addAnimation:positionAnim1 forKey:@"rotationAnim1"];
    [contentView.layer pop_addAnimation:positionAnim2 forKey:@"rotationAnim2"];
    
}


@end
