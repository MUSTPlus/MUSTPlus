//
//  RootPopView.h
//  yimashuo
//
//  Created by imqiuhang on 15/10/14.
//  Copyright © 2015年 imqiuhang. All rights reserved.
//

#import "QHHead.h"

/*!
 *  @author imqiuhang, 15-10-14
 *
 *  @brief  所有类似于选择时间 分享等弹出视图的基类，子类只需要实现prepareForContentSubView来布局contentView中的子视图就行
 
 * 该超类只负责弹出动画，点击遮罩层消失视图的功能
 */

@interface RootPopView : UIView
{
@protected
    UIView *contentView;
@private
    UIView *backgroundView;
}

@property (nonatomic)float totalAnimationDuration;

@property (nonatomic,readonly)BOOL isShow;

@property (nonatomic,readonly)int showTag;

//子类在这个函数中添加自己的UI到contentView 应该[contentView addSubView] 而非 [self addSubView]
//默认contentView的颜色是whiteColor  可以在这个 函数中contentView.backgroundColor = [UIColor redColor];
//子类不需要调用super
//子类无需设置subview 的autoresizingMask

- (void)prepareForContentSubView;

- (float)heightForContentView;


//比如有2个按钮可以出发显示 回调的时候可以区分是选择了哪个tag选择的日期
- (void)showWithTag:(int )tag;
- (void)hide:(BOOL)animation;

@end
