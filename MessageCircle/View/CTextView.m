//
//  CTextView.m
//  MUST_Plus
//
//  Created by Cirno on 13/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "CTextView.h"
@interface CTextView()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end
@implementation CTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        UILabel *placeHolderLabel = [[UILabel alloc]init];
        [self addSubview:placeHolderLabel];
        self.placeHolderLabel = placeHolderLabel;
        self.placeHolderLabel.numberOfLines = 0;
    }
    // 文字改变时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    return self;
}
- (void)textChange {
    [self.placeHolderLabel setHidden:self.text.length > 0];
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeHolderLabel.font=font;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    self.placeHolderLabel.textColor = placeHolderColor;
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelWindth =  self.frame.size.width - 8 * 2;
    // calculate text size
    CGSize placeHolderSize =
    [self.placeHolder boundingRectWithSize:CGSizeMake(labelWindth, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:self.placeHolderLabel.font}
                                   context:nil].size;
    // self.placeHolderLabel.backgroundColor = [UIColor redColor];
    self.placeHolderLabel.frame = CGRectMake(8, 10, labelWindth, placeHolderSize.height);
}

- (void)dealloc {
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
