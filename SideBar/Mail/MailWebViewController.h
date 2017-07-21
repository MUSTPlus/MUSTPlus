//
//  MailWebViewController.h
//  MUST_Plus
//
//  Created by zbc on 16/11/23.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

@interface MailWebViewController : UIViewController

@property (nonatomic,strong)  MCOMessageParser *mail;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSMutableArray<MCOAttachment*> *attachments;
@end
