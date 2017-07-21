//
//  NewWeekTitleView.h
//  MUST_Plus
//
//  Created by Cirno on 11/02/2017.
//  Copyright © 2017 zbc. All rights reserved.
//
//  新课程表title
//
//
//
#import <UIKit/UIKit.h>
#import "BasicHead.h"
@interface NewWeekTitleView : UIView
@property (nonatomic,strong) UIView * MonthView;
@property (nonatomic,strong) NSMutableArray<UIView*>* DayView;

-(void)drawTitleWithDate:(NSString*)Date;
@end
