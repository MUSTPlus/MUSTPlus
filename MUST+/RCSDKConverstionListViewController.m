//
//  RCSDKConverstionListViewController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/9/14.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "RCSDKConverstionListViewController.h"

@interface RCSDKConverstionListViewController ()

@end

@implementation RCSDKConverstionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([[cell model].senderUserId isEqualToString:@"GROUPADMIN"]){
        RCConversationCell *conversationCell = (RCConversationCell *)cell;
        conversationCell.bubbleTipView.bubbleTipText = nil;
    }
    [super willDisplayConversationTableCell:cell atIndexPath:indexPath];
}

@end
