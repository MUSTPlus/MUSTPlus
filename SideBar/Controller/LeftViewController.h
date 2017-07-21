//
//  LeftViewController.h
//  MUST_Plus
//
//  Created by Cirno on 22/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CirnoSideBarDelegate.h"
@interface LeftViewController : UIViewController
@property (assign,nonatomic) id<CirnoSideBarDelegate> delegate;
-(void)ClickAvatar;
@end
