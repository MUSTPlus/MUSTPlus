//
//  CirnoTextView.h
//  MUST_Plus
//
//  Created by Cirno on 07/12/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirnoTextView : UITextView<UITextViewDelegate>
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UILabel *residuLabel;// 输入文本时剩余字数
@property(nonatomic,strong) NSString* placeholder;

@property(nonatomic) int rerest;
@end
