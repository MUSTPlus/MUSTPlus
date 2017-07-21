//
//  ComposeViewController.h
//  MUST_Plus
//
//  Created by Cirno on 13/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController
typedef void (^ablock)(NSString *str);

@property (nonatomic,copy) ablock block;//是否成功发送

@end
