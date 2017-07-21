//
//  HeaderView.h
//  MUST_Plus
//
//  Created by zbc on 16/10/7.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

//这个delegate负责点击加号
@protocol HeadButtonDelegate
-(void)ClickAdd:(id)button;
@end

@interface HeaderView : UIView

    
@property(assign,nonatomic) id<HeadButtonDelegate> headButtonDelegate;
@property(strong,nonatomic) UITableView* tableView;

    
//必须在headView init !后！ 调用这个方法，如果不要button的话就传值nil，并且delegate不要设置
-(void)drawHeadViewWithTtile:(NSString *)titleString
                 buttonImage:(NSString *)buttonImgString;


-(void) changeFace;

@end
