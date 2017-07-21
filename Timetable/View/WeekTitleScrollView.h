//
//  WeekTitleScrollView.h
//  MUST_Plus
//
//  Created by zbc on 16/10/3.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WeakTtileButtonDelegate
-(void)ClickWhichWeek:(int)Which;
@end


@interface WeekTitleScrollView : UIScrollView
-(void) drawTitleWeekWithColor:(UIColor *)textColor
                    TodayColor:(UIColor *)todayColor;
@property(nonatomic) int week;
@property(assign,nonatomic) id<WeakTtileButtonDelegate> weakTtileButtonDelegate;

@end
