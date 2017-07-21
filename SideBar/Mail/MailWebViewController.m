//
//  MailWebViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/11/23.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "MailWebViewController.h"
#import "BasicHead.h"
#import "MCOCIDURLProtocol.h"
@interface MailWebViewController ()<MCOHTMLRendererDelegate,UIWebViewDelegate,UIDocumentInteractionControllerDelegate>

@end

@implementation MailWebViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    static NSString * mainJavascript = @"\
    var imageElements = function() {\
        var imageNodes = document.getElementsByTagName('img');\
        return [].slice.call(imageNodes);\
    };\
    \
    var findCIDImageURL = function() {\
        var images = imageElements();\
        \
        var imgLinks = [];\
        for (var i = 0; i < images.length; i++) {\
            var url = images[i].getAttribute('src');\
            if (url.indexOf('cid:') == 0 || url.indexOf('x-mailcore-image:') == 0)\
                imgLinks.push(url);\
        }\
        return JSON.stringify(imgLinks);\
    };\
    \
    var replaceImageSrc = function(info) {\
        var images = imageElements();\
        \
        for (var i = 0; i < images.length; i++) {\
            var url = images[i].getAttribute('src');\
    if (url.indexOf(info.URLKey) == 0) {\
                images[i].setAttribute('src', info.LocalPathKey);\
    break;\
            }\
        }\
    };";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = _mail.header.subject;
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    MCOMessageParser * msgPareser = _mail;
    NSString *content = [msgPareser htmlRenderingWithDelegate:self];

    NSMutableString * html = [NSMutableString string];
    [html appendFormat:@"<html><head><script>%@</script></head>"
     @"<body>%@</body><iframe src='x-mailcore-msgviewloaded:' style='width: 0px; height: 0px; border: none;'>"
     @"</iframe></html>", mainJavascript, content];
    [_webView loadHTMLString:html baseURL:nil];
    _webView.scalesPageToFit = YES;
    _attachments=[[NSMutableArray alloc]initWithArray:msgPareser.attachments];
    if ([_attachments count]>0){
        UIView* openatt = [[UIView alloc]initWithFrame:CGRectMake(0, Height-44, Width, 44)];
        openatt.backgroundColor = navigationTabColor;
        UILabel* open = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 44)];
        open.text=NSLocalizedString(@"打开附件", "");
        open.textAlignment=NSTextAlignmentCenter;
        open.textColor =[UIColor whiteColor];
        [openatt addSubview:open ];
        open.userInteractionEnabled =YES;
        UITapGestureRecognizer *uiTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAttachment)];
        [open addGestureRecognizer:uiTap2];
        [self.view addSubview:openatt];
    }

}
-(void)openAttachment{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"打开附件", "") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", "") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    for (int i=0;i<[_attachments count];i++){
        UIAlertAction *action = [UIAlertAction actionWithTitle:_attachments[i].filename style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            NSData* attachmentData=[_attachments[i] data];
            NSString *tmpDirectory =NSTemporaryDirectory();
            NSString *filePath=[tmpDirectory stringByAppendingPathComponent : _attachments[i].filename ];
            [attachmentData writeToFile:filePath atomically:YES];
            NSFileManager *fileManger=[NSFileManager defaultManager];
            if ([fileManger fileExistsAtPath:filePath]) {
                UIDocumentInteractionController *documentController =
                [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                [documentController setDelegate:self];
                [UINavigationBar appearance].barTintColor = navigationTabColor;
                [UINavigationBar appearance].tintColor = [UIColor whiteColor];
                [[UINavigationBar appearance] setTitleTextAttributes:
                 @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                [documentController presentPreviewAnimated:YES];
            }
        }];
        [alert addAction:action];
    }
   [self presentViewController:alert animated:YES completion:nil];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSURLRequest *responseRequest = [self webView:webView resource:nil willSendRequest:request redirectResponse:nil fromDataSource:nil];

    if(responseRequest == request) {
        return YES;
    } else {
        [webView loadRequest:responseRequest];
        return NO;
    }
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (NSURLRequest *)webView:(UIWebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(id)dataSource {

    if ([[[request URL] scheme] isEqualToString:@"x-mailcore-msgviewloaded"]) {
        [self _loadImages];
    }
    return request;
}

// 加载网页中的图片
- (void) _loadImages {
    NSString * result = [_webView stringByEvaluatingJavaScriptFromString:@"findCIDImageURL()"];
    if (result == nil || [result isEqualToString:@""]) {
        return;
    }
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray * imagesURLStrings = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    for (NSString * urlString in imagesURLStrings) {
        MCOAbstractPart * part = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        if ([MCOCIDURLProtocol isCID:url]) {
            part = [self _partForCIDURL:url];
        }
        else if ([MCOCIDURLProtocol isXMailcoreImage:url]) {
            NSString * specifier = [url resourceSpecifier];
            NSString * partUniqueID = specifier;
            part = [self _partForUniqueID:partUniqueID];
        }
        if (part == nil) {
            continue;
        }
        NSString * partUniqueID = [part uniqueID];
        MCOAttachment * attachment = (MCOAttachment *) [_mail partForUniqueID:partUniqueID];
        NSData * data =[attachment data];
        if (data!=nil) {

            //获取文件路径
            NSString *tmpDirectory =NSTemporaryDirectory();
            NSString *filePath=[tmpDirectory stringByAppendingPathComponent : attachment.filename ];

            NSFileManager *fileManger=[NSFileManager defaultManager];
            if (![fileManger fileExistsAtPath:filePath]) {
                NSData *attachmentData=[attachment data];
                [attachmentData writeToFile:filePath atomically:YES];
                NSLog(@"资源：%@已经下载至%@", attachment.filename,filePath);
            }

            NSURL * cacheURL = [NSURL fileURLWithPath:filePath];
            NSDictionary * args =@{@"URLKey": urlString,@"LocalPathKey": cacheURL.absoluteString};

            NSString * jsonString = [self _jsonEscapedStringFromDictionary:args];
            NSString * replaceScript = [NSString stringWithFormat:@"replaceImageSrc(%@)", jsonString];
            [_webView stringByEvaluatingJavaScriptFromString:replaceScript];
        }
    }
}

- (NSString *)_jsonEscapedStringFromDictionary:(NSDictionary *)dictionary {

    NSData * json = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString * jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSURL *) _cacheJPEGImageData:(NSData *)imageData withFilename:(NSString *)filename {

    NSString * path = [[NSTemporaryDirectory()stringByAppendingPathComponent:filename]stringByAppendingPathExtension:@"jpg"];
    [imageData writeToFile:path atomically:YES];
    return [NSURL fileURLWithPath:path];
}

- (MCOAbstractPart *) _partForCIDURL:(NSURL *)url {
    return [_mail partForContentID:[url resourceSpecifier]];
}

- (MCOAbstractPart *) _partForUniqueID:(NSString *)partUniqueID {
    return [_mail partForUniqueID:partUniqueID];
}
@end
