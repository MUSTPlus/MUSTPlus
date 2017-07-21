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
@protocol SchoolClassScrollDelegate
-(void)scroll:(UIScrollView *)scrollView;
@end

@interface SchoolClassScrollView : UIScrollView<UIScrollViewDelegate>

@property(assign,nonatomic) id<SchoolClassScrollDelegate> schoolClassScrollDelegate;

@property(nonatomic) int week;

-(void) addLine;
-(void) addClassesInScrollView:(NSMutableArray<ClassButton*> *)Schoolclasses;

@end
