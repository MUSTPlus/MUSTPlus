//
//  TimeScrollView.m
//  MUST_Plus
//
//  Created by zbc on 16/10/3.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "TimeScrollView.h"
#import "BasicHead.h"

@implementation TimeScrollView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        self.scrollEnabled = false;
        self.backgroundColor = timeTableColor;
    }
    return self;
}



//显示时间
-(void) drawLeftTimeViewWithColor:(UIColor *)textColor
                        lineColor:(UIColor *)lineColor{
    
    const float OneHour = (self.frame.size.height)/14;

    float x = 0;
    UIView *SeparateLine;
    for(int i=0;i<14;i++){
        SeparateLine = [[UIView alloc] initWithFrame:CGRectMake(0,x,444,1.1)];
        SeparateLine.backgroundColor = lineColor;
        x+=OneHour;
        [self addSubview:SeparateLine];
    }
    
    
    UILabel *HourLabel;
    x=0;
    
    for(int i=0;i<14;i++){
        HourLabel = [[UILabel alloc] initWithFrame:CGRectMake(1,x,30,OneHour-2)];
        HourLabel.textAlignment = NSTextAlignmentCenter;
        HourLabel.text = [NSString stringWithFormat:@"%d",i+8];
        HourLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        HourLabel.textColor = textColor;
        x+=OneHour;
        [self addSubview:HourLabel];
    }
    
}


@end
