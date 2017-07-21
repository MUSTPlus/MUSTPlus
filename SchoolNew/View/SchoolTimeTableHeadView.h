//
//  SchoolTimeTableHeadView.h
//  MUST_Plus
//
//  Created by zbc on 16/10/8.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicHead.h"
@protocol HeadButtonDelegate
-(void)ClickAdd:(id)button;
-(void)ClickFace:(id)button;

@end
@protocol MenuDelegate <NSObject>

- (void)didSelectMenuItem:(NSString *)string;

@end
@interface SchoolTimeTableHeadView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(assign,nonatomic) id<HeadButtonDelegate> headButtonDelegate;
@property(assign,nonatomic) id<MenuDelegate> menuDelegate;
@property(strong,nonatomic) UITableView* tableView;
@property(nonatomic,strong) UILabel* subtitle;
@property(nonatomic,strong) UILabel* title;
@property(nonatomic,strong) UIImageView* menuImage;
@property(nonatomic,strong) UIView* containView;
@property(nonatomic,strong) UICollectionView* collectionView;
@property(nonatomic) BOOL menuShowing;

//必须在headView init !后！ 调用这个方法，如果不要button的话就传值nil，并且delegate不要设置
-(void)drawHeadViewWithTtile:(NSString *)titleString
                 buttonImage:(NSString *)buttonImgString
                    subTitle:(NSString *)subtitleString;
-(void)drawMenuBar;
-(void) changeFace;

@end
