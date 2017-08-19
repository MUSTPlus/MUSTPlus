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

        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                              @(ConversationType_GROUP)]];

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

}
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {

    RCSDKConversationViewController *conversation;

    conversation = [[RCSDKConversationViewController alloc]init];

    conversation.conversationType = model.conversationType;

    conversation.targetId = model.targetId;

    conversation.title = model.conversationTitle;

    conversation.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:conversation animated:YES];



}

@end
