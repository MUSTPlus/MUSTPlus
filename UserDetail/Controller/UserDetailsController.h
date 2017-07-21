//
//  UserDetailsController.h
//  MUST_Plus
//
//  Created by Cirno on 30/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "UserChangeDetailsController.h"

@interface UserDetailsController : UIViewController<UIGestureRecognizerDelegate>
@property BOOL isSelf;
@property(nonatomic,strong) NSString* studID;
@property (nonatomic,strong) UserModel * currentUser;
@property (nonatomic,strong) UIImage* backgroundimage;
-(void)back1;
@end
