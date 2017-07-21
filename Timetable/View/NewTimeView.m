//
//  NewTimeView.m
//  MUST_Plus
//
//  Created by Cirno on 13/02/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import "NewTimeView.h"

@implementation NewTimeView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self !=nil){
       // self.backgroundColor = timeTableColor;
    }
    return self;
}
-(void)drawLeftTime{
    const float OneHour = self.frame.size.height / 14;
        UILabel *HourLabel;
    CGFloat x = 0;
    UIView *SeparateLine;
    float blockWidth = (Width - 25)/7;
    for(int i=0;i<14;i++){

        SeparateLine = [[UIView alloc] initWithFrame:CGRectMake(0,x,self.frame.size.width,1)];
        SeparateLine.backgroundColor =[kColor(66, 130, 196) colorWithAlphaComponent:0.3];

        [self addSubview:SeparateLine];
        HourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,x,25,OneHour-2)];
        HourLabel.textAlignment = NSTextAlignmentCenter;
        HourLabel.text = [NSString stringWithFormat:@"%d",i+8];
        HourLabel.font = [UIFont boldSystemFontOfSize:11];
        HourLabel.textColor = kColor(66, 130, 196);
        [self addSubview:HourLabel];
        x+=OneHour;
        for (int _=1;_<7;_++){
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(25+blockWidth*_-2, x, 5, 1)];
            line.backgroundColor =[kColor(66, 130, 196) colorWithAlphaComponent:0.3];
            [self addSubview: line];
        }
    }
}
@end
