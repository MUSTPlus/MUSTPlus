//
//  MyMessageHeader.h
//  MUST_Plus
//
//  Created by zbc on 17/1/8.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WHE.h"
#import "UIImage+CYButtonIcon.h"

@protocol MyMessageDetailHeadAddButtonDelegate
-(void)ClickAdd:(id)button;
@end


@interface MyMessageHeader : UIView

@property(assign,nonatomic) id<MyMessageDetailHeadAddButtonDelegate> myMessageDetailHeadAddButtonDelegate;
@property (nonatomic,strong)  UIImage *backIcon;

@end
