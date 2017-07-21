//
//  UILabel+QHLabelCtg.m
//  yimashuo
//
//  Created by imqiuhang on 15/8/17.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "UILabel+QHLabelCtg.h"

@implementation UILabel (QHLabelCtg)

- (void)setText:(NSString *)aText andFont:(UIFont *)aFont andTextColor:(UIColor *)aColor {
    self.text      = aText;
    self.font      = aFont;
    self.textColor = aColor;
}

//price单位是 分
- (void)setAsAttributedPriceLableWithPriceStr:(int)price {
    int realPrice = price/100;
    
    if (realPrice<minPriceShowNoPrice) {
        self.attributedText = nil;
        self.text = @"暂无报价";
    }else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%i",realPrice]];
        
        [attributedString addAttribute:NSFontAttributeName value:systemFont(12) range:NSMakeRange(0, 1)];
        [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(1,attributedString.string.length-1)];
        self.attributedText = attributedString;
    }
    
}

+ (NSAttributedString *)attributedStringWithLineSpacing:(float)lineSpacing andString:(NSString *)string{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//行距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.string.length)];
    
    return [attributedString copy];
}


@end
