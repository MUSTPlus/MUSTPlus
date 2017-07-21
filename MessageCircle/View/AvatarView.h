//
//  AvatarView.h
//  MUST_Plus
//
//  Created by Cirno on 16/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@protocol UserDetailsDelegate
-(void)ClickAvatar:(id)button;
@end
@interface AvatarView : UIView
-(void)setUser:(UserModel *)user;
@property (nonatomic, strong) UserModel *user;
@property (assign,nonatomic) id <UserDetailsDelegate> avatarDelegate;

@end
