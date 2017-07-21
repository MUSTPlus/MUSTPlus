//
//  ChangePinNumberView.m
//  MUST_Plus
//
//  Created by zbc on 16/12/6.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "ChangePinNumberView.h"
#import "Account.h"
@implementation ChangePinNumberView{
    UITextField *pin;
    UIButton *btn;
    UITextView *detail;

}
-(void)show{
    Alert *alert = [[Alert alloc] initWithTitle:NSLocalizedString(@"输入PIN码","") message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"取消","")
                              otherButtonTitles:NSLocalizedString(@"确定",""), nil];
    alert.alertStyle = AlertStylePlainTextInput;
    __block Alert*alertV = alert;
    [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
        NSLog(@"%@", alertV.textField.text);
        NSLog(@"%ld",(long)buttonIndex);

        if (buttonIndex == 1) {
            [[Account shared] setPin:alertV.textField.text];

        }
    }];
    [alert setCancelBlock:^(Alert *alertView) {
        // 取消
    }];
    [alert show];
}

//- (void)prepareForContentSubView {
//
//
//        detail = [[UITextView alloc] initWithFrame:CGRectMake(20 ,60,contentView.width - 40, 200)];
//        detail.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
//        [detail setEditable:NO];
//        detail.textAlignment = NSTextAlignmentLeft;
//        detail.text = @"请修改图书馆pin";
//        [contentView addSubview:detail];
//    
//        contentView.backgroundColor = [UIColor whiteColor];
//        pin = [[UITextField alloc] initWithFrame:CGRectMake(20 ,20 , contentView.width - 40, 30)];
//        pin.placeholder = @"Pin";
//        [contentView addSubview:pin];
//        if ([[Account shared] getPin] != NULL){
//            pin.text = [[Account shared] getPin];
//        }
//    
//        btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 308 + 9, contentView.width - 40, 40)];
//        [btn setTitle:NSLocalizedString(@"确定", "") andFont:defaultFont(16) andTitleColor:[UIColor whiteColor] andBgColor:YMSBrandColor andRadius:5];
//        [contentView addSubview:btn];
//        [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionSheet)];
//    tap.delegate = self;
//    [contentView addGestureRecognizer:tap];
//}
//
//-(void)ActionSheet{
//    [pin resignFirstResponder];
//}
//
//-(void) done{
//    [[Account shared] setPin:pin.text];
//    [self hide];
//}
//
//- (void)change1{
//    detail.text = @"请修改图书馆码";
//    btn.frame = CGRectMake(20, 108 , contentView.width - 40, 40);
//}
//
//- (void)change2{
//    detail.text = @"请修改图书馆pin";
//    
//    btn.frame = CGRectMake(20, 308 + 9, contentView.width - 40, 40);
//}

@end
