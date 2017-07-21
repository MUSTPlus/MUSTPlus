//
//  CirnoSideBarViewController.h
//  MUST_Plus
//
//  Created by Cirno on 22/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CirnoSideBarDelegate.h"
#import "LeftViewController.h"
@protocol AvatarDelegate
-(void)Click:(id)button;
@end
@interface CirnoSideBarViewController : UIViewController<CirnoSideBarDelegate,UINavigationControllerDelegate>
@property (assign,nonatomic) id<AvatarDelegate> avatarDelegate;

@property (strong,nonatomic) UIView * contentView;
@property (strong,nonatomic) UIView * navBackView;
@property (assign,nonatomic) BOOL sideBarShowing;
@property BOOL diabled;
+(id)share;
@end
