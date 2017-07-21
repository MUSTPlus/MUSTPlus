//
//  XGSim2Tra.h
//  addLocalizal_KeyAt@"Front
//
//  Created by 贾  on 2016/12/29.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 另一种待实现方式 by william
 基本原理
 由上述编码知识可知，字体的切换其实就是编码的切换
 GB2312<->Unicode<->BIG5
 这样一个流程，Unicode充当切换的桥梁。
 */
@interface XGSim2Tra : NSObject
{
    NSString*	_string_GB;
    NSString*	_string_BIG5;
}

/**
 *  MARK:--------------------简体转繁体--------------------
 */
-(NSString*)gbToBig5:(NSString*)srcString;

/**
 *  MARK:--------------------繁体转简体--------------------
 */
-(NSString*)big5ToGb:(NSString*)srcString;

/**
 *  MARK:--------------------简体转繁体(富文本)--------------------
 */
-(NSAttributedString*) gb2Big5WithAttributedString:(NSAttributedString*)attStr;



@end
