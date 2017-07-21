//
//  ZBCNavigationScrollView.h
//  MUST+
//
//  Created by zbc on 16/10/1.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>




//这个delegate负责viewController的翻页效果
@protocol SchoolNavigationViewDelegate
-(void)ClickNavigationButton:(int) num;
@end

@interface ZBCNavigationScrollView : UIScrollView<UIScrollViewDelegate>

@property(assign,nonatomic) id<SchoolNavigationViewDelegate> schoolNavigationViewDelegate;


@end
