//
//  FileViewController.h
//  MUST_Plus
//
//  Created by Cirno on 17/02/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileViewController : UIDocumentInteractionController
@property (nonatomic,strong) UIWebView* webView;
@property (nonatomic,strong) NSString*url;
@end
