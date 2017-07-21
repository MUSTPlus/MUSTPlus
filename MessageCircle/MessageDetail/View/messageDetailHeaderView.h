//
//  messageDetailHeaderView.h
//  MUST_Plus
//
//  Created by zbc on 16/10/26.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WHE.h"
#import "UIImage+CYButtonIcon.h"

@protocol MessageDetailHeadAddButtonDelegate
-(void)ClickAdd:(id)button;
@end

@interface messageDetailHeaderView : UIView
@property(assign,nonatomic) id<MessageDetailHeadAddButtonDelegate> messageDetailHeadAddButtonDelegate;
@property (nonatomic,strong)  UIImage *backIcon;

@end
