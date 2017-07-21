//
//  ClassButton.h
//  MUST_Plus
//
//  Created by zbc on 16/10/4.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolClassModel.h"

//这个delegate负责监听点击Button事件
@protocol SchoolClassClickDelegate
-(void)schoolButtonDidClick:(id)button;
@end

@interface ClassButton : UIButton

@property(assign,nonatomic) id<SchoolClassClickDelegate> schoolClassClickDelegate;
@property(strong,nonatomic) SchoolClassModel *schoolClass;
-(void) drawClassButton:(SchoolClassModel *)schollClass
        backGroudColor:(UIColor *)BackGroudColor; //这个方法给button传值和button的背景颜色，在Controller里必须实现
-(SchoolClassModel *) getButtonSchoolClass;
- (void)removeAllSubviews;

@end
