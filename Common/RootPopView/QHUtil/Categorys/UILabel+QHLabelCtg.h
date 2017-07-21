//
//  UILabel+QHLabelCtg.h
//  yimashuo
//
//  Created by imqiuhang on 15/8/17.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "QHHead.h"

#define minPriceShowNoPrice 10

@interface UILabel (QHLabelCtg)

- (void)setText:(NSString *)aText andFont:(UIFont *)aFont andTextColor:(UIColor *)aColor;

//price单位是 分
- (void)setAsAttributedPriceLableWithPriceStr:(int)price ;

+ (NSAttributedString *)attributedStringWithLineSpacing:(float)lineSpacing andString:(NSString *)string;



@end
