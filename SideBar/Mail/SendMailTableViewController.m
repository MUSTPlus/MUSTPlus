//
//  SendMailTableViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/11/23.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SendMailTableViewController.h"
#import <MailCore/MailCore.h>
#import "BasicHead.h"
#import "MailWebViewController.h"
#import "Account.h"
#import "CirnoError.h"
@interface SendMailTableViewController ()
@end

@implementation SendMailTableViewController{
    NSMutableArray<MCOMessageParser *> *mailArray;
    MCOPOPSession *session;
    UIImage *backIcon;
    int count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:95.0/255.0 green:167.0/255.0 blue:241.0/255.0 alpha:1]];
    if (_dontShowDone==0){
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
    [backBtn setTitle:UIKitLocalizedString(@"Done") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchDown];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.tag = 100;
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(15, StatusBarHeight, 45, 45)];
    [customView addSubview:backBtn];

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];

    self.navigationItem.leftBarButtonItem = backBarButtonItem;
        }
    self.navigationItem.title = NSLocalizedString(@"学生邮箱", "");
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    mailArray = [[NSMutableArray alloc] init];
    
    count = 0;
    
    [self login];
}



-(void)Click:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mailArray count];
}

-(void)show{
    Alert *alert = [[Alert alloc] initWithTitle:NSLocalizedString(@"输入PIN码","") message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"取消","")
                              otherButtonTitles:NSLocalizedString(@"确定",""), nil];
    alert.alertStyle = AlertStylePlainTextInput;
    __block Alert*alertV = alert;
    [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[Account shared] setMailPw:alertV.textField.text];
            [self login];

        }
    }];
    [alert setCancelBlock:^(Alert *alertView) {
        // 取消
    }];
    [alert show];
}
-(void) login{
    session = [[MCOPOPSession alloc] init];
    
    session.hostname = @"mail.student.must.edu.mo";
    
    session.port = 110;
    
    session.checkCertificateEnabled = NO;
    
    [session setUsername:[[Account shared]getStudentShortID]];
    NSString* newpw=[[Account shared]getMailPw];
    if (newpw!=nil)
        [session setPassword:newpw];
    else
        [session setPassword:[[Account shared]getPassword]];
    
    [session setConnectionType:MCOConnectionTypeStartTLS];
    // Do any additional setup after loading the view, typically from a nib.
    MCOPOPOperation * checkOp = [session fetchMessagesOperation];
    [checkOp start:^(NSError *error) {
        NSLog(@"finished checking account.");
        if (error == nil) {
            //正确登录邮箱
            /*在这里获取邮件头，通过邮件头可以获得邮件内容，详情看下面*/
            [self getMail];
            NSLog(@"success");
        } else {
            [CirnoError ShowErrorWithText:error.localizedDescription];
            [self show];
        }
    }];
}


-(void) getMail{
    MCOPOPFetchMessagesOperation * op = [session fetchMessagesOperation];
    [op start:^(NSError * error,NSArray * messages) {
        if (error==nil) {
            //通过messages中的邮件头信息，可以进一步请求获得最终的邮件内容,获取方法见下面4
            for (int i=(int)[messages count]-1;i>0;i--){

                MCOPOPMessageInfo *messageInfo = messages[i];

         //   for(MCOPOPMessageInfo *messageInfo in messages){
                count++;
                if (count < 20){
                [self getOneMail:messageInfo];
                }
                else return;
            }
        }
    }];
}



-(void) getOneMail:(MCOPOPMessageInfo *)messageInfo{
    int index= messageInfo.index;
    MCOPOPFetchMessageOperation*messageOperation=[session fetchMessageOperationWithIndex: index];
    
    
    [messageOperation start:^(NSError * error, NSData *messageData) {
        // messageData is the RFC 822 formatted message data.
        if (!error) {
            //由data转换为MCOMessageParser
            MCOMessageParser * msgPaser =[MCOMessageParser messageParserWithData:messageData];
            //可从msgPaser获得邮件信息，如：msgPaser.header.subject为邮件标题
//            NSString *htmlString=[msgPaser htmlBodyRendering];//获取邮件html正文
//            NSLog(@"%@",htmlString);
            [mailArray addObject:msgPaser];
            [self.tableView reloadData];
            
        }else{
            [CirnoError ShowErrorWithText:error.localizedDescription];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *tcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(tcell == nil){
        tcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    MCOMessageParser * msgPaser = [mailArray objectAtIndex:indexPath.row];
    tcell.textLabel.text = msgPaser.header.subject;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateStyle:NSDateFormatterLongStyle];
    [format setTimeStyle:NSDateFormatterLongStyle];
    tcell.detailTextLabel.text = [format stringFromDate:msgPaser.header.date];

    tcell.textLabel.numberOfLines = 0;
    return tcell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    MCOMessageParser * msgPaser = [mailArray objectAtIndex:indexPath.row];
    CGRect textRect = [[NSString stringWithFormat:@"%@",msgPaser.header.subject] boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT)
                                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSParagraphStyleAttributeName:paragraphStyle}
                                                                                     context:nil];
    CGSize textSize = textRect.size;
    return textSize.height+40;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MailWebViewController *a = [[MailWebViewController alloc] init];
    [a setMail:[mailArray objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:a animated:YES];
}


@end
