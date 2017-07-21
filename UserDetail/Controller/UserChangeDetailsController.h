//
//  UserChangeDetailsController.h
//  MUST_Plus
//
//  Created by Cirno on 07/12/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@protocol ChangeDelegate
-(void)passValue:(NSString*)str;
@end
@interface UserChangeDetailsController : UIViewController
@property (nonatomic,strong) UserModel* usrmodel;
@property (nonatomic,strong) UIBarButtonItem *myButton;
@end
