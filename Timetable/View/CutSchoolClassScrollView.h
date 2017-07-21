//
//  SchoolClassScrollView.h
//  MUST_Plus
//
//  Created by zbc on 16/10/4.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassButton.h"

//这个delegate负责滚动监听
@protocol SchoolClassScrollDeleage
-(void)scroll:(UIScrollView *)scrollView;
@end

@interface CutSchoolClassScrollView : UIScrollView<UIScrollViewDelegate>

@property(assign,nonatomic) id<SchoolClassScrollDeleage> schoolClassScrollDeleage;
-(void) addClassesInScrollView:(NSMutableArray<ClassButton*> *)Schoolclasses;

@end
