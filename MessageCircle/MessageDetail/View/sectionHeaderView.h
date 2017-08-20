//
//  sectionHeaderView.h
//  MUSTPlus
//
//  Created by zbc on 2017/8/20.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sectionHeaderView : UIView

@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIButton *likeButton;
-(void) addLine:(int) which;

@end
