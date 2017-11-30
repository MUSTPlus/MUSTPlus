//
//  MailViewController.h
//  MUSTPlus
//
//  Created by Cirno on 2017/11/30.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Account.h"
@interface MailViewController : UIViewController<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView* wkwebView;
@property (nonatomic,strong) NSString* url;
@end
