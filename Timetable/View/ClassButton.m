//
//  ClassButton.m
//  MUST_Plus
//
//  Created by zbc on 16/10/4.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "ClassButton.h"

@implementation ClassButton

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

-(void) drawClassButton:(SchoolClassModel *)schollClass
                        backGroudColor:(UIColor *)BackGroudColor{
    self.schoolClass = schollClass;
    self.backgroundColor = BackGroudColor;
}

-(SchoolClassModel *) getButtonSchoolClass{
    return self.schoolClass;
}

-(void) click:(id)button{
    [_schoolClassClickDelegate schoolButtonDidClick:button];
}

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            [subview removeFromSuperview];
        }
        
    }
}

@end
