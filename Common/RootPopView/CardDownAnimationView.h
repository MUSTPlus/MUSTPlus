//
//  CardDownAnimationView.h
//  yimashuo
//
//  Created by imqiuhang on 15/9/23.
//  Copyright © 2015年 imqiuhang. All rights reserved.
//

#import "QHHead.h"

@protocol CardDownAnimationViewDelegate;


@interface CardDownAnimationView : UIView
{
    @protected
    UIView *contentView;
    @private
    UIView *backgroundView;
}

@property (nonatomic)float totalAnimationDuration;

@property (nonatomic,readonly)BOOL isShow;

@property (nonatomic,weak)id<CardDownAnimationViewDelegate>delegate;



//will autoshow in keywindown
- (void)show;
- (void)hide;

//子类在这个函数中添加自己的UI到contentView 应该[contentView addSubView] 而非 [self addSubView]
//默认contentView的颜色是whiteColor  可以在这个 函数中contentView.backgroundColor = [UIColor redColor];
//子类不需要调用super
//子类无需设置subview 的autoresizingMask
- (void)prepareForContentSubView;

@end

@protocol CardDownAnimationViewDelegate <NSObject>

@optional
- (void)cardDownAnimationViewDidShow:(CardDownAnimationView *)cardDownView;
- (void)cardDownAnimationViewDidHide:(CardDownAnimationView *)cardDownView;

- (void)cardDownAnimationViewWillShow:(CardDownAnimationView *)cardDownView;
- (void)cardDownAnimationViewWillHide:(CardDownAnimationView *)cardDownView;

@end
