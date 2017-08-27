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

    }
    return self;
}

-(void)joinGroup{
    NSDictionary *o1 =@{@"ec":@"5000",
                        @"userid":[[Account shared]getStudentLongID]};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager POST:BaseURL parameters:parameters progress:nil success:nil failure:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小纸条";
    NSString* check = [[Account shared]getLoginStatus];
    if (![check isEqual:@"1"]){
        [[Account shared]setLoginStatus];
        [self joinGroup];
    }
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

}
-(void)viewDidAppear:(BOOL)animated{

    [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];

}

-(void)viewWillAppear:(BOOL)animated{

}
-(void)viewWillDisappear:(BOOL)animated{

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
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    [super willReloadTableData:dataSource];
    for (int i=0;i<dataSource.count;i++){
        RCConversationModel* model = dataSource[i];
        if ([model.lastestMessage.senderUserInfo.userId isEqualToString:@"GROUPADMIN"]){
            [[RCIMClient sharedRCIMClient]removeConversation:model.conversationType targetId:model.targetId];
            [self refreshConversationTableViewIfNeeded];
        }
    }
    return dataSource;
}
@end
