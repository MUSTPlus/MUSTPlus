//
//  SubLBXScanViewController.h
//  MUST_Plus
//
//  Created by zbc on 16/10/6.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <LBXScan/LBXScanView.h>
#import "LBXScanViewController.h"


typedef enum {
    signCantFindClassID           = -4,     //Cannot Find the class-ID
    signDateBroken                = -3,     //The data broken
    signSqlBroken                 = -2,     //服务器没挂数据库挂了
    signOutOfTime                 = -1,     //老师没有开放这节课的签到权
    signSigned                    = 0,     //已经签过到
    signOutSchool                 = 1,     //校外签的返回
    signDeviceSigned              = 2,     //机子签到过返回
    signSuccess                   = 3,     //签到成功
    signTooFast                   = 4      //签到太快
} sign;




@interface SubLBXScanViewController : LBXScanViewController<UIAlertViewDelegate>

@end
