//
//  MessageController.m
//  
//
//  Created by Cirno on 2017/8/6.
//
//

#import "MessageController.h"
@interface MessageController ()

@end

@implementation MessageController
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self) {

        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];

    }
    return self;
}
-(id)init
{
    self =[super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小纸条";
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [[RCIM sharedRCIM] initWithAppKey:@"lmxuhwaglz8gd"];
    [[RCIM sharedRCIM] connectWithToken:@"C/8hTcodGfbULbGteKxhQgrHaABpTcoS6pYHqzmDyhCYmXHSFqPZrG74PWHILVp2HNDvtSorIblcOJK0cC/ad/gMHH/yaFZ+Om17XTQt4As="     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];


    // Do any additional setup after loading the view.
}
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {

    RCSDKConversationViewController *conversationVC = [[RCSDKConversationViewController alloc]initWithConversationType:model.conversationType targetId:model.targetId];
    conversationVC.hidesBottomBarWhenPushed = YES;
    NSLog(@"%@",conversationVC);
    conversationVC.title = @"想显示的会话标题";
    [self.navigationController pushViewController:conversationVC animated:YES];
}


@end
